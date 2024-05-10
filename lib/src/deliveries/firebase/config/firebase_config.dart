import 'package:args/args.dart';
import 'package:meta/meta.dart';
import 'package:truck/src/deliveries/firebase/config/firebase_base_config.dart';
import 'package:truck/src/deliveries/firebase/config/firebase_platform_config.dart';
import 'package:truck/src/util/args_results_extension.dart';
import 'package:truck/src/util/help_util.dart';
import 'package:yaml/yaml.dart';

///{@template firebase_config}
/// Configuration for Firebase.
/// {@endtemplate}
@immutable
class FirebaseConfig extends FirebaseBaseConfig {
  /// {@macro firebase_config}
  const FirebaseConfig({
    required this.serviceAccountFile,
    this.android,
    this.ios,
    super.releaseNotes,
    super.groups,
    super.testers,
  });

  /// {@macro firebase_config}
  /// Creates a FirebaseConfig from a [YamlMap].
  factory FirebaseConfig.fromYaml(YamlMap yaml) {
    final android = yaml['android'] as YamlMap?;
    final ios = yaml['ios'] as YamlMap?;

    return FirebaseConfig(
      serviceAccountFile: yaml['service_account_file'] as String,
      releaseNotes: yaml['release_notes'] as String?,
      groups: (yaml['groups'] as YamlList?)?.map((e) => e as String).toList(),
      testers: (yaml['testers'] as YamlList?)?.map((e) => e as String).toList(),
      android:
          android != null ? FirebasePlatformConfig.fromYaml(android) : null,
      ios: ios != null ? FirebasePlatformConfig.fromYaml(ios) : null,
    );
  }

  /// {@macro firebase_config}
  /// Creates a FirebaseConfig from [ArgResults].
  factory FirebaseConfig.fromArgs(ArgResults args, ArgParser appParser) {
    printHelp(args, appParser);

    final android = args.getCommand('android');

    final ios = args.getCommand('ios');

    return FirebaseConfig(
      serviceAccountFile: args.option('service-account-file'),
      releaseNotes: args.option('release-notes'),
      groups: args.multiOptionOrNull('groups'),
      testers: args.multiOptionOrNull('testers'),
      android: android != null
          ? FirebasePlatformConfig.fromArgs(
              android,
              appParser.commands['android']!,
            )
          : null,
      ios: ios != null
          ? FirebasePlatformConfig.fromArgs(ios, appParser.commands['ios']!)
          : null,
    );
  }

  /// The service account file path.
  final String? serviceAccountFile;

  /// The Android platform configuration.
  final FirebasePlatformConfig? android;

  /// The iOS platform configuration.
  final FirebasePlatformConfig? ios;

  /// Merges two [FirebaseConfig]s.
  FirebaseConfig join(FirebaseConfig config) {
    return FirebaseConfig(
      serviceAccountFile: config.serviceAccountFile ?? serviceAccountFile,
      releaseNotes: config.releaseNotes ?? releaseNotes,
      groups: config.groups ?? groups,
      testers: config.testers ?? testers,
      android: config.android != null && android != null
          ? android!.join(config.android!)
          : android ?? config.android,
      ios: config.ios != null && ios != null
          ? ios!.join(config.ios!)
          : ios ?? config.ios,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is FirebaseConfig &&
            super == other &&
            serviceAccountFile == other.serviceAccountFile &&
            android == other.android &&
            ios == other.ios;
  }

  @override
  int get hashCode => Object.hashAll([
        serviceAccountFile,
        releaseNotes,
        groups,
        testers,
        android,
        ios,
      ]);

  @override
  String toString() {
    return 'FirebaseConfig($serviceAccountFile, $releaseNotes, $groups, '
        '$testers, $android, $ios)';
  }
}
