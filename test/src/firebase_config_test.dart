// test the fromYaml functionality in the FirebaseConfig file

import 'package:parameterized_test/parameterized_test.dart';
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

  parameterizedTest('config merge test', [
    [
      const FirebaseConfig(cliToken: 'token1'),
      const FirebaseConfig(cliToken: 'token2'),
      const FirebaseConfig(cliToken: 'token2'),
    ],
    [
      const FirebaseConfig(cliToken: 'token1'),
      const FirebaseConfig(cliToken: 'token2', groups: ['1']),
      const FirebaseConfig(cliToken: 'token2', groups: ['1']),
    ],
    [
      const FirebaseConfig(cliToken: 'token1', testers: ['1']),
      const FirebaseConfig(cliToken: 'token2', groups: ['2']),
      const FirebaseConfig(cliToken: 'token2', groups: ['2'], testers: ['1']),
    ],
    [
      const FirebaseConfig(
        cliToken: 'token1',
        android: FirebasePlatformConfig(appId: '1', file: '2'),
      ),
      const FirebaseConfig(
        cliToken: 'token2',
        android: FirebasePlatformConfig(appId: '3', file: '4'),
      ),
      const FirebaseConfig(
        cliToken: 'token2',
        android: FirebasePlatformConfig(appId: '3', file: '4'),
      ),
    ],
    [
      const FirebaseConfig(
        cliToken: 'token1',
        android: FirebasePlatformConfig(appId: '1', file: '2'),
      ),
      const FirebaseConfig(
        cliToken: 'token2',
        ios: FirebasePlatformConfig(appId: '3', file: '4'),
      ),
      const FirebaseConfig(
        cliToken: 'token2',
        android: FirebasePlatformConfig(appId: '1', file: '2'),
        ios: FirebasePlatformConfig(appId: '3', file: '4'),
      ),
    ],
    [
      const FirebaseConfig(
        cliToken: 'token1',
        android: FirebasePlatformConfig(appId: '11', file: '2'),
        ios: FirebasePlatformConfig(appId: '33', file: '4'),
      ),
      const FirebaseConfig(
        cliToken: 'token2',
        android: FirebasePlatformConfig(appId: '11', file: '3'),
        ios: FirebasePlatformConfig(appId: '33', file: '5'),
      ),
      const FirebaseConfig(
        cliToken: 'token2',
        android: FirebasePlatformConfig(appId: '11', file: '3'),
        ios: FirebasePlatformConfig(appId: '33', file: '5'),
      ),
    ],
    [
      const FirebaseConfig(
        cliToken: 'token1',
        releaseNotes: 'releaseNotes1',
        groups: ['group1'],
        testers: ['tester1'],
        android: FirebasePlatformConfig(
          appId: 'android appId1',
          file: 'android file1',
          releaseNotes: 'android releaseNotes1',
          groups: ['android group1'],
          testers: ['android tester1'],
        ),
        ios: FirebasePlatformConfig(
          appId: 'ios appId1',
          file: 'ios file1',
          releaseNotes: 'ios releaseNotes1',
          groups: ['ios group1'],
          testers: ['ios tester1'],
        ),
      ),
      const FirebaseConfig(
        cliToken: 'token2',
        releaseNotes: 'releaseNotes2',
        groups: ['group2'],
        testers: ['tester2'],
        android: FirebasePlatformConfig(
          appId: 'android appId2',
          file: 'android file2',
          releaseNotes: 'android releaseNotes2',
          groups: ['android group2'],
          testers: ['android tester2'],
        ),
        ios: FirebasePlatformConfig(
          appId: 'ios appId2',
          file: 'ios file2',
          releaseNotes: 'ios releaseNotes2',
          groups: ['ios group2'],
          testers: ['ios tester2'],
        ),
      ),
      const FirebaseConfig(
        cliToken: 'token2',
        releaseNotes: 'releaseNotes2',
        groups: ['group2'],
        testers: ['tester2'],
        android: FirebasePlatformConfig(
          appId: 'android appId2',
          file: 'android file2',
          releaseNotes: 'android releaseNotes2',
          groups: ['android group2'],
          testers: ['android tester2'],
        ),
        ios: FirebasePlatformConfig(
          appId: 'ios appId2',
          file: 'ios file2',
          releaseNotes: 'ios releaseNotes2',
          groups: ['ios group2'],
          testers: ['ios tester2'],
        ),
      ),
    ],
  ], (FirebaseConfig config1, FirebaseConfig config2, FirebaseConfig expected) {
    final result = config1.merge(config2);
    expect(result, expected);
  });
}
