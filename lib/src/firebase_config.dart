import 'package:yaml/yaml.dart';

class FirebaseConfig extends FirebaseBaseConfig {
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

  static FirebaseConfig fromYaml(YamlMap yaml) {
    final android = yaml['android'] as YamlMap?;
    final ios = yaml['ios'] as YamlMap?;

    return FirebaseConfig(
      cliToken: yaml['cli_token'] as String,
      releaseNotes: yaml['release_notes'] as String?,
      groups: (yaml['groups'] as YamlList?)?.map((e) => e as String).toList(),
      testers: (yaml['testers'] as YamlList?)?.map((e) => e as String).toList(),
      android: android != null
          ? FirebasePlatformConfig(
              appId: android['app_id'] as String,
              file: android['file'] as String,
              releaseNotes: android['release_notes'] as String?,
              groups: (android['groups'] as YamlList?)?.map((e) => e as String).toList(),
              testers: (android['testers'] as YamlList?)?.map((e) => e as String).toList(),
            )
          : null,
      ios: ios != null
          ? FirebasePlatformConfig(
              appId: ios['app_id'] as String,
              file: ios['file'] as String,
              releaseNotes: ios['release_notes'] as String?,
              groups: (ios['groups'] as YamlList?)?.map((e) => e as String).toList(),
              testers: (ios['testers'] as YamlList?)?.map((e) => e as String).toList(),
            )
          : null,
    );
  }

  @override
  String toString() {
    return 'FirebaseConfig(cliToken: $cliToken, android: $android, ios: $ios, '
        'releaseNotes: $releaseNotes, groups: $groups, testers: $testers)';
  }
}

class FirebaseBaseConfig {
  const FirebaseBaseConfig({
    this.releaseNotes,
    this.groups,
    this.testers,
  });

  final String? releaseNotes;
  final List<String>? groups;
  final List<String>? testers;
}

class FirebasePlatformConfig extends FirebaseBaseConfig {
  const FirebasePlatformConfig({
    required this.appId,
    required this.file,
    super.releaseNotes,
    super.groups,
    super.testers,
  });

  final String appId;
  final String file;

  @override
  String toString() {
    return 'FirebasePlatformConfig(appId: $appId, file: $file, releaseNotes: '
        '$releaseNotes, groups: $groups, testers: $testers)';
  }
}
