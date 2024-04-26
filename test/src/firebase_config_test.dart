// test the fromYaml functionality in the FirebaseConfig file

import 'package:test/test.dart';
import 'package:truck/src/firebase_config.dart';
import 'package:yaml/yaml.dart';

void main() {
  test('fromYaml returns a FirebaseConfig object', () {
    final yaml = loadYaml('''
release_notes: 'RELEASE: CI_COMMIT'
cli_token: test
groups: 
  - 'testers'
testers: 
  - 'testers@test.com'
  - 'test2@test.com'
android:
  release_notes: 'RELEASE: Android'
  app_id: 1:123456789012:android:1234567890123456789012
  file: build/app/outputs/flutter-apk/app-release.apk
ios:
  app_id: 1:123456789012:ios:1234567890123456789012
  file: build/app/outputs/flutter-apk/app-release.ipa
  groups: 
    - 'testersIos'
  testers:
    - 'testers@test.com'
  ''') as YamlMap;

    final config = FirebaseConfig.fromYaml(yaml);

    expect(config, isA<FirebaseConfig>());
    expect(config.cliToken, 'test');
    expect(config.releaseNotes, 'RELEASE: CI_COMMIT');
    expect(config.groups, ['testers']);
    expect(config.testers, ['testers@test.com', 'test2@test.com']);

    expect(config.android, isA<FirebasePlatformConfig>());
    expect(config.android!.appId, '1:123456789012:android:1234567890123456789012');
    expect(config.android!.file, 'build/app/outputs/flutter-apk/app-release.apk');
    expect(config.android!.releaseNotes, 'RELEASE: Android');

    expect(config.ios, isA<FirebasePlatformConfig>());
    expect(config.ios!.appId, '1:123456789012:ios:1234567890123456789012');
    expect(config.ios!.file, 'build/app/outputs/flutter-apk/app-release.ipa');
    expect(config.ios!.groups, ['testersIos']);
    expect(config.ios!.testers, ['testers@test.com']);
  });
}
