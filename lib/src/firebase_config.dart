import 'package:yaml/yaml.dart';

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
      android: config.android != null && android != null ? android!.merge(config.android!) : android,
      ios: config.ios != null && ios != null ? ios!.merge(config.ios!) : ios,
    );
  }

  @override
  String toString() {
    return 'FirebaseConfig(\n\tcliToken: $cliToken,\n\tandroid: $android,'
        '\n\tios: $ios,\n\treleaseNotes: $releaseNotes,\n\tgroups: $groups,'
        '\n\ttesters: $testers\n)';
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
  String toString() {
    return 'FirebasePlatformConfig(\n\tappId: $appId,\n\tfile: $file,'
        '\n\treleaseNotes: $releaseNotes,\n\tgroups: $groups,'
        '\n\ttesters: $testers\n)';
  }
}
