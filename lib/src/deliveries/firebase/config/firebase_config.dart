import 'package:args/args.dart';
import 'package:meta/meta.dart';
import 'package:truck/src/args_results_extension.dart';
import 'package:truck/src/deliveries/firebase/config/firebase_base_config.dart';
import 'package:truck/src/deliveries/firebase/config/firebase_platform_config.dart';
import 'package:truck/src/help_util.dart';
import 'package:yaml/yaml.dart';

@immutable
class FirebaseConfig extends FirebaseBaseConfig {
  factory FirebaseConfig.fromYaml(YamlMap yaml) {
    final android = yaml['android'] as YamlMap?;
    final ios = yaml['ios'] as YamlMap?;

    return FirebaseConfig(
      serviceAccountFile: yaml['service_account_file'] as String,
      releaseNotes: yaml['release_notes'] as String?,
      groups: (yaml['groups'] as YamlList?)?.map((e) => e as String).toList(),
      testers: (yaml['testers'] as YamlList?)?.map((e) => e as String).toList(),
      android: android != null ? FirebasePlatformConfig.fromYaml(android) : null,
      ios: ios != null ? FirebasePlatformConfig.fromYaml(ios) : null,
    );
  }

  factory FirebaseConfig.fromArgs(ArgResults args, ArgParser appParser) {
    printHelp(args, appParser);

    final android = args.getCommand('android');

    final ios = args.getCommand('ios');

    return FirebaseConfig(
      serviceAccountFile: args.option('service-account-file'),
      releaseNotes: args.option('release-notes'),
      groups: args.multiOptionOrNull('groups'),
      testers: args.multiOptionOrNull('testers'),
      android: android != null ? FirebasePlatformConfig.fromArgs(android, appParser.commands['android']!) : null,
      ios: ios != null ? FirebasePlatformConfig.fromArgs(ios, appParser.commands['ios']!) : null,
    );
  }

  const FirebaseConfig({
    required this.serviceAccountFile,
    this.android,
    this.ios,
    super.releaseNotes,
    super.groups,
    super.testers,
  });

  final String? serviceAccountFile;
  final FirebasePlatformConfig? android;
  final FirebasePlatformConfig? ios;

  FirebaseConfig join(FirebaseConfig config) {
    return FirebaseConfig(
      serviceAccountFile: config.serviceAccountFile ?? serviceAccountFile,
      releaseNotes: config.releaseNotes ?? releaseNotes,
      groups: config.groups ?? groups,
      testers: config.testers ?? testers,
      android: config.android != null && android != null ? android!.merge(config.android!) : android ?? config.android,
      ios: config.ios != null && ios != null ? ios!.merge(config.ios!) : ios ?? config.ios,
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
    return 'FirebaseConfig($serviceAccountFile, $releaseNotes, $groups, $testers, '
        '$android, $ios)';
  }
}
