class FirebaseConfig extends FirebaseBaseConfig {
  const FirebaseConfig({
    required this.cliToken,
    required this.android,
    required this.ios,
    required super.releaseNotes,
    required super.groups,
    required super.testers,
  });

  final String cliToken;
  final FirebasePlatformConfig android;
  final FirebasePlatformConfig ios;
}

class FirebaseBaseConfig {

  const FirebaseBaseConfig({
    required this.releaseNotes,
    required this.groups,
    required this.testers,
  });

  final String releaseNotes;
  final List<String> groups;
  final List<String> testers;

}

class FirebasePlatformConfig extends FirebaseBaseConfig {

  const FirebasePlatformConfig({
    required this.appId,
    required this.file,
    required super.releaseNotes,
    required super.groups,
    required super.testers,
  });

  final String appId;
  final String file;
}