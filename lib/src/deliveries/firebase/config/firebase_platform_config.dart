import 'package:args/args.dart';
import 'package:meta/meta.dart';
import 'package:truck/src/args_results_extension.dart';
import 'package:truck/src/deliveries/firebase/config/firebase_base_config.dart';
import 'package:truck/src/help_util.dart';
import 'package:yaml/yaml.dart';

/// {@template FirebasePlatformConfig}
/// Configuration for Firebase platform.
/// {@endtemplate}
@immutable
class FirebasePlatformConfig extends FirebaseBaseConfig {
  /// {@macro FirebasePlatformConfig}
  const FirebasePlatformConfig({
    required this.appId,
    required this.file,
    super.releaseNotes,
    super.groups,
    super.testers,
  });

  /// {@macro FirebasePlatformConfig}
  /// Creates a FirebasePlatformConfig from a [YamlMap].
  factory FirebasePlatformConfig.fromYaml(YamlMap yaml) {
    return FirebasePlatformConfig(
      appId: yaml['app_id'] as String,
      file: yaml['file'] as String,
      releaseNotes: yaml['release_notes'] as String?,
      groups: (yaml['groups'] as YamlList?)?.map((e) => e as String).toList(),
      testers: (yaml['testers'] as YamlList?)?.map((e) => e as String).toList(),
    );
  }

  /// {@macro FirebasePlatformConfig}
  /// Creates a FirebasePlatformConfig from [ArgResults].
  factory FirebasePlatformConfig.fromArgs(
      ArgResults args, ArgParser appParser,) {
    printHelp(args, appParser);

    return FirebasePlatformConfig(
      appId: args.option('app-id') ?? '',
      file: args.option('file') ?? '',
      releaseNotes: args.option('release-notes'),
      groups: args.multiOptionOrNull('groups'),
      testers: args.multiOptionOrNull('testers'),
    );
  }

  /// The app identifier from firebase.
  final String appId;

  /// The file path to the artifact to upload.
  final String file;

  /// Merges this configuration with another [FirebasePlatformConfig].
  FirebasePlatformConfig join(FirebasePlatformConfig config) {
    return FirebasePlatformConfig(
      appId: config.appId.isNotEmpty ? config.appId : appId,
      file: config.file.isNotEmpty ? config.file : file,
      releaseNotes: config.releaseNotes ?? releaseNotes,
      groups: config.groups ?? groups,
      testers: config.testers ?? testers,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is FirebasePlatformConfig &&
            super == other &&
            appId == other.appId &&
            file == other.file;
  }

  @override
  int get hashCode => Object.hashAll([
        appId,
        file,
        releaseNotes,
        groups,
        testers,
      ]);

  @override
  String toString() {
    return 'FirebasePlatformConfig($appId, $file, $releaseNotes, $groups, '
        '$testers)';
  }
}
