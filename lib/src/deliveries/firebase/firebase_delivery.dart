import 'dart:convert';
import 'dart:io';

import 'package:args/args.dart';
import 'package:googleapis/firebaseappdistribution/v1.dart';
import 'package:googleapis/vmwareengine/v1.dart';
import 'package:googleapis_auth/auth_io.dart';
import 'package:truck/src/args_results_extension.dart';
import 'package:truck/src/deliveries/delivery.dart';
import 'package:truck/src/deliveries/firebase/config/firebase_config.dart';
import 'package:truck/src/deliveries/firebase/config/firebase_platform_config.dart';
import 'package:truck/src/deliveries/firebase/firebase_api.dart';
import 'package:truck/src/help_util.dart';
import 'package:yaml/yaml.dart';

class FirebaseDelivery implements Delivery {
  const FirebaseDelivery();

  @override
  String get name => 'firebase';

  @override
  Future<void> deliver(ArgResults args, YamlMap config) async {
    final argsConfig = FirebaseConfig.fromArgs(args, parser);
    final yamlConfig = FirebaseConfig.fromYaml(config);
    final mergedConfig = yamlConfig.merge(argsConfig);

    // TODO(guldem): check config
    print(mergedConfig);

    final platform = args.command?.name;
    final client = await _getClient(mergedConfig);

    if (platform == 'android') {
      uploadBinary(
        client,
        mergedConfig,
        mergedConfig.android,
      );
    } else if (platform == 'ios') {
    } else {
      print('Could not deliver to Firebase. Please specify a platform (android/ios)');
    }

    print(' 🚚 Delivering to Firebase 🚚');
  }
  void uploadBinary(client, FirebaseConfig mergedConfig, FirebasePlatformConfig? android) {}

  Future<dynamic> _getClient(FirebaseConfig config) async {
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
