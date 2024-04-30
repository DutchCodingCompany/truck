import 'package:collection/collection.dart';
import 'package:meta/meta.dart';
import 'package:yaml/yaml.dart';

@immutable
class FirebaseConfig extends FirebaseBaseConfig {
  factory FirebaseConfig.fromYaml(YamlMap yaml) {
    final android = yaml['android'] as YamlMap?;
    final ios = yaml['ios'] as YamlMap?;

    return FirebaseConfig(
      cliToken: yaml['cli_token'] as String,
      releaseNotes: yaml['release_notes'] as String?,
      groups: (yaml['groups'] as YamlList?)?.map((e) => e as String).toList(),
      testers: (yaml['testers'] as YamlList?)?.map((e) => e as String).toList(),
      android: android != null ? FirebasePlatformConfig.fromYaml(android) : null,
      ios: ios != null ? FirebasePlatformConfig.fromYaml(ios) : null,
    );
  }

  const FirebaseConfig({
    required this.cliToken,
    this.android,
    this.ios,
    super.releaseNotes,
    super.groups,
    super.testers,
  });

  final String cliToken;
  final FirebasePlatformConfig? android;
  final FirebasePlatformConfig? ios;

  FirebaseConfig merge(FirebaseConfig config) {
    return FirebaseConfig(
      cliToken: config.cliToken.isNotEmpty ? config.cliToken : cliToken,
      releaseNotes: config.releaseNotes ?? releaseNotes,
      groups: config.groups ?? groups,
      testers: config.testers ?? testers,
      android: config.android != null && android != null ? android!.merge(config.android!) : android ?? config.android,
      ios: config.ios != null && ios != null ? ios!.merge(config.ios!) :  ios ?? config.ios,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is FirebaseConfig &&
            super == other &&
            cliToken == other.cliToken &&
            android == other.android &&
            ios == other.ios;
  }

  @override
  int get hashCode => Object.hashAll([
        cliToken,
        releaseNotes,
        groups,
        testers,
        android,
        ios,
      ]);

  @override
  String toString() {
    return 'FirebaseConfig($cliToken, $releaseNotes, $groups, $testers, '
        '$android, $ios)';
  }
}

@immutable
class FirebaseBaseConfig {
  const FirebaseBaseConfig({
    this.releaseNotes,
    this.groups,
    this.testers,
  });

  final String? releaseNotes;
  final List<String>? groups;
  final List<String>? testers;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is FirebaseBaseConfig &&
            releaseNotes == other.releaseNotes &&
            const DeepCollectionEquality().equals(groups, other.groups) &&
            const DeepCollectionEquality().equals(testers, other.testers);
  }

  @override
  int get hashCode => Object.hashAll([releaseNotes, groups, testers]);
}

@immutable
class FirebasePlatformConfig extends FirebaseBaseConfig {
  const FirebasePlatformConfig({
    required this.appId,
    required this.file,
    super.releaseNotes,
    super.groups,
    super.testers,
  });

  factory FirebasePlatformConfig.fromYaml(YamlMap yaml) {
    return FirebasePlatformConfig(
      appId: yaml['app_id'] as String,
      file: yaml['file'] as String,
      releaseNotes: yaml['release_notes'] as String?,
      groups: (yaml['groups'] as YamlList?)?.map((e) => e as String).toList(),
      testers: (yaml['testers'] as YamlList?)?.map((e) => e as String).toList(),
    );
  }

  final String appId;
  final String file;

  FirebasePlatformConfig merge(FirebasePlatformConfig config) {
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
        other is FirebasePlatformConfig && super == other && appId == other.appId && file == other.file;
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
