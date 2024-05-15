# 🚚 Truck: Your Flutter app's one-stop delivery service for App Stores & Firebase.

## Features ✨
 - Configure your app's deployments in a single file.
 - Deploy to:
    - [x] Firebase App Distribution
    - [ ] Play Store
    - [ ] TestFlight
 - Written in Dart

## Installation 🛠
Add the dependency to your `pubspec.yaml` file:
```yaml
dev_dependencies:
  truck: [latest-version]
```

## Usage 🚀

### Configuration
Specify your app's deployment configuration in your `pubspec.yaml` or custom yaml file.

For example to deploy to Firebase App Distribution:
```yaml
truck:
  firebase:
    # Overal Release notes for the deployment
    release_notes: 'RELEASE: $CI_COMMIT'
    # Google service account file location for authentication with Firebase
    service_account_file: service-account.json
    # Overal groups to distribute the app to
    groups:
      - 'testers'
    # Overal testers to distribute the app to
    testers: 
      - 'test-guy@awesome.com'
    android:
      # Android app id
      app_id: 1:123456789012:android:1234567890123456789012
      # Binary file location to distribute
      file: build/app/outputs/flutter-apk/app-release.apk
    ios:
      # iOS app id
      app_id: 1:123456789012:ios:1234567890123456789012
      # Binary file location to distribute
      file: build/app/outputs/flutter-apk/app-release.ipa
      # iOS groups to distribute the app to
      groups: 
        - 'testers_ios'
      # iOS testers to distribute the app to
      testers:
        - 'the-ios-tester@awesome.com'
        - 'someone-else@awesome.com'
```

### Run the package
Run the package and specify with store to deploy to:
```bash
# Deploy to Firebase App Distribution android configuration
dart run truck:deliver firebase android
# Deploy to Firebase App Distribution ios configuration with custom release notes
dart run truck:deliver firebase ios --release-notes='New release notes'
```


<!-- 
TODO: Add documentation for different deliveries (Firebase, Play Store, TestFlight)

TODO: Add examples for different deliveries (Firebase, Play Store, TestFlight)

## Additional information

TODO: Tell users more about the package: where to find more information, how to 
contribute to the package, how to file issues, what response they can expect 
from the package authors, and more.

```yaml
dev_dependencies:
  csv: ^6.0.0
  very_good_analysis: ^5.1.0
  truck: 1.0.0


truck:
  firebase:
    release_notes: 'RELEASE: $CI_COMMIT'
    cli_token: $FIREBASE_CLI_TOKEN
    groups: 
      - 'testers'
    testers: 
     - 'testers@test.com'
     - 'test2@test.com'
    android:
      release_notes: 'RELEASE: $CI_COMMIT'
      app_id: 1:123456789012:android:1234567890123456789012
      file: build/app/outputs/flutter-apk/app-release.apk
    ios:
      app_id: 1:123456789012:ios:1234567890123456789012
      file: build/app/outputs/flutter-apk/app-release.ipa
      groups: 
        - 'testers'
      testers:
        - 'testers@test.com'
        - 'test2@test.com'
  play_store:
    ....
  test_flight:
    ....
```

```bash
dart run truck:deliver --path=myflavor.yaml firebase-ios
dart run truck:deliver firebase --release-notes= '' android --app_id='' play_store --release-notes=''
dart run truck:deliver firebase --platform=android
dart run truck:deliver firebase --platform=android --release-notes='asdasd' play_store --release-notes='asdasd'
```
-->