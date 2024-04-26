<!-- 
This README describes the package. If you publish this package to pub.dev,
this README's contents appear on the landing page for your package.

For information about how to write a good package README, see the guide for
[writing package pages](https://dart.dev/guides/libraries/writing-package-pages). 

For general information about developing packages, see the Dart guide for
[creating packages](https://dart.dev/guides/libraries/create-library-packages)
and the Flutter guide for
[developing packages and plugins](https://flutter.dev/developing-packages). 
-->

TODO: Put a short description of the package here that helps potential users
know whether this package might be useful for them.

## Features

TODO: List what your package can do. Maybe include images, gifs, or videos.

## Getting started

TODO: List prerequisites and provide or point to information on how to
start using the package.

## Usage

TODO: Include short and useful examples for package users. Add longer examples
to `/example` folder. 

```dart
const like = 'sample';
```

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