import 'dart:convert';
import 'dart:io';

import 'package:args/args.dart';
import 'package:googleapis/firebaseappdistribution/v1.dart';
import 'package:googleapis_auth/auth_io.dart';
import 'package:truck/src/deliveries/delivery.dart';
import 'package:truck/src/deliveries/firebase/config/firebase_config.dart';
import 'package:truck/src/deliveries/firebase/config/firebase_platform_config.dart';
import 'package:yaml/yaml.dart';

class FirebaseDelivery implements Delivery {
  const FirebaseDelivery();

  @override
  String get name => 'firebase';

  @override
  Future<void> deliver(ArgResults args, YamlMap config) async {
    final argsConfig = FirebaseConfig.fromArgs(args, parser);
    final yamlConfig = FirebaseConfig.fromYaml(config);
    final mergedConfig = yamlConfig.join(argsConfig);

    // TODO(guldem): check config
    print(mergedConfig);

    final platform = args.command?.name;
    final client = await _getClient(mergedConfig);

    if (platform == 'android') {
      print(' 🚚 Delivering Android to Firebase 🚚');
      await uploadBinary(
        client,
        mergedConfig,
        mergedConfig.android!,
      );
    } else if (platform == 'ios') {
      print(' 🚚 Delivering iOS to Firebase 🚚');
      await uploadBinary(
        client,
        mergedConfig,
        mergedConfig.ios!,
      );
    } else {
      print('Could not deliver to Firebase. Please specify a platform (android/ios)');
    }
  }

  Future<void> uploadBinary(
    AutoRefreshingAuthClient client,
    FirebaseConfig config,
    FirebasePlatformConfig platform,
  ) async {
    final releaseNotes = platform.releaseNotes ?? config.releaseNotes;
    final groups = <String>{...?platform.groups, ...?config.groups}.toList();
    final testers = <String>{...?platform.testers, ...?config.testers}.toList();

    final api = FirebaseAppDistributionApi(client);
    final appId = _projectAppId(platform.appId);
    final file = File(platform.file);
    final fileName = file.uri.pathSegments.last;
    final fileContent = file.readAsBytesSync();

    GoogleFirebaseAppdistroV1Release release;
    try {
      final uploadResponse = await client.post(
        Uri.parse('https://firebaseappdistribution.googleapis.com/upload/v1/$appId/releases:upload'),
        body: fileContent,
        headers: {
          'Content-Type': 'application/octet-stream',
          'X-Goog-Upload-File-Name': fileName,
          'X-Goog-Upload-Protocol': 'raw',
        },
      );

      final operation = GoogleLongrunningOperation.fromJson(
        jsonDecode(uploadResponse.body) as Map<String, dynamic>,
      );
      release = await _poll_operations(api, operation);
    } catch (e) {
      print('Unable to upload binary to Firebase');
      print(e);
      exit(1);
    }

    if (releaseNotes != null) {
      try {
        release.releaseNotes = GoogleFirebaseAppdistroV1ReleaseNotes(text: releaseNotes);
        release = await api.projects.apps.releases.patch(release, release.name!);
      } catch (e) {
        print('Unable to add release notes to release ${release.name}');
        print(e);
        exit(1);
      }

      if (groups.isNotEmpty && testers.isNotEmpty) {
        try {
          final distribution = GoogleFirebaseAppdistroV1DistributeReleaseRequest(
            testerEmails: testers,
            groupAliases: groups,
          );

          await api.projects.apps.releases.distribute(distribution, release.name!);
        } catch (e) {
          print('Unable to distribute release ${release.name} to groups: '
              '${groups.join(',')} and testers: ${testers.join(',')}');
          print(e);
          exit(1);
        }
      }

      print('Release delivered successfully!');
    }
  }

  Future<GoogleFirebaseAppdistroV1Release> _poll_operations(
    FirebaseAppDistributionApi api,
    GoogleLongrunningOperation operation,
  ) async {
    final release = _checkOperation(operation);
    if (release != null) {
      return release;
    }

    for (int i = 0; i < 60; i++) {
      final response = await api.projects.apps.releases.operations.get(operation.name!);
      final release = _checkOperation(response);
      if (release != null) {
        return release;
      }
      await Future<void>.delayed(const Duration(seconds: 5));
    }
    exit(1);
  }

  GoogleFirebaseAppdistroV1Release? _checkOperation(GoogleLongrunningOperation operation) {
    if (operation.done ?? false) {
      if (operation.error != null) {
        print('Error: ${operation.error!.message}');
        exit(1);
      } else {
        return GoogleFirebaseAppdistroV1Release.fromJson(operation.response!['release'] as Map<String, dynamic>);
      }
    }
    return null;
  }

  String _projectAppId(String appId) => 'projects/${appId.split(':')[1]}/apps/$appId';

  Future<AutoRefreshingAuthClient> _getClient(FirebaseConfig config) async {
    final serviceAccountContent = File(config.serviceAccountFile!).readAsStringSync();
    final credentials = ServiceAccountCredentials.fromJson(
      jsonDecode(serviceAccountContent) as Map<String, dynamic>,
    );

    return clientViaServiceAccount(credentials, [FirebaseAppDistributionApi.cloudPlatformScope]);
  }

  @override
  ArgParser get parser {
    final androidParser = _appParser;
    final iosParser = _appParser;
    final baseParser = _baseArgParser
      ..addFlag(
        'help',
        abbr: 'h',
        help: 'Prints usage information.',
        negatable: false,
      )
      ..addOption('service-account-file', abbr: 'c', help: 'Specify CLI Token')
      ..addCommand('android', androidParser)
      ..addCommand('ios', iosParser);

    return baseParser;
  }

  ArgParser get _baseArgParser => ArgParser()
    ..addOption('release-notes', abbr: 'r', help: 'Specify Release Notes')
    ..addMultiOption('groups', abbr: 'g', help: 'Specify Test Groups')
    ..addMultiOption('testers', abbr: 't', help: 'Specify Testers');

  ArgParser get _appParser => _baseArgParser
    ..addFlag(
      'help',
      abbr: 'h',
      help: 'Prints usage information.',
      negatable: false,
    )
    ..addOption('app-id', abbr: 'a', help: 'Specify App ID')
    ..addOption('file', abbr: 'f', help: 'Specify File');
}
