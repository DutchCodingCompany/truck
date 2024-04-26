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
}
