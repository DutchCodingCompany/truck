import 'dart:async';
import 'dart:convert';

import 'package:fake_async/fake_async.dart';
import 'package:googleapis/firebaseappdistribution/v1.dart';
import 'package:http/http.dart';
import 'package:http/testing.dart';
import 'package:test/test.dart';
import 'package:truck/src/deliveries/firebase/config/firebase_config.dart';
import 'package:truck/src/deliveries/firebase/config/firebase_platform_config.dart';
import 'package:truck/src/deliveries/firebase/firebase_delivery.dart';

import '../../mock_log.dart';

void main() {
  late MockClientHandler mockClientHandler;
  late MockClient mockClient;
  late MockLog mockLog;
  late FirebaseDelivery firebaseDelivery;

  setUp(() {
    mockClientHandler = (req) async => Response('', 200);
    mockClient = MockClient(mockClientHandler);
    mockLog = MockLog();
    firebaseDelivery = FirebaseDelivery(client: mockClient, customLog: mockLog);
  });

  test('projectAppId test', () {
    expect(
      firebaseDelivery.projectAppId(
        '1:123456789012:android:abcdefghijklmno1234567',
      ),
      'projects/123456789012/apps/1:123456789012:android:abcdefghijklmno1234567',
    );
  });

  test('uploadBinary should upload binary and distribute release successfully', () async {
    final mockClient = MockClient((request) async {
      if (request.url.path.contains('upload')) {
        return Response(jsonEncode({'name': 'operationName'}), 200);
      } else if (request.url.path.contains('operations')) {
        return Response(
            jsonEncode({
              'done': true,
              'response': {'release': {}}
            }),
            200);
      } else if (request.url.path.contains('releases')) {
        return Response(jsonEncode({}), 200);
      }
      return Response('', 404);
    });

    final firebaseDelivery = FirebaseDelivery(client: mockClient, customLog: mockLog);
    final config = FirebaseConfig(serviceAccountFile: 'serviceAccountFile');
    final platformConfig = FirebasePlatformConfig(appId: 'appId', file: 'file');

    await firebaseDelivery.uploadBinary(mockClient, config, platformConfig);

    expect(mockLog.logs, contains('Release delivered successfully!'));
  }, skip: 'not working yet');

  test('uploadBinary should log error when unable to upload binary', () async {
    final mockClient = MockClient((request) async {
      return Response('', 404);
    });

    final firebaseDelivery = FirebaseDelivery(client: mockClient, customLog: mockLog);
    final config = FirebaseConfig(serviceAccountFile: 'serviceAccountFile');
    final platformConfig = FirebasePlatformConfig(appId: 'appId', file: 'file');

    await firebaseDelivery.uploadBinary(mockClient, config, platformConfig);

    expect(mockLog.logs, contains('Unable to upload binary to Firebase:'));
  }, skip: 'not working yet');

  test('pollOperations should return release when operation is done', () async {
    final mockClient = MockClient((request) async {
      return Response(
          jsonEncode({
            'done': true,
            'response': {'release': {}}
          }),
          200,
          headers: {'content-type': 'application/json'});
    });

    final firebaseDelivery = FirebaseDelivery(client: mockClient, customLog: mockLog);
    final operation = GoogleLongrunningOperation()..name = 'operationName';

    final api = FirebaseAppDistributionApi(mockClient);
    final release = await firebaseDelivery.pollOperations(api, operation);

    expect(release, isNotNull);
  });

  test('pollOperations should log error when operation has error', () async {
    final mockClient = MockClient((request) async {
      return Response(
          jsonEncode({
            'done': true,
            'error': {'message': 'error'}
          }),
          200,
          headers: {'content-type': 'application/json'});
    });

    final firebaseDelivery = FirebaseDelivery(client: mockClient, customLog: mockLog);
    final operation = GoogleLongrunningOperation()..name = 'operationName';

    final api = FirebaseAppDistributionApi(mockClient);
    try {
      await firebaseDelivery.pollOperations(api, operation);
    } catch (_) {}

    expect(mockLog.logs, contains('Error: error'));
  });

  test('pollOperations should log error when operation times out', () async {
    final mockClient = MockClient((request) async {
      return Response(
        jsonEncode({'done': false}),
        200,
        headers: {'content-type': 'application/json'},
      );
    });

    final firebaseDelivery = FirebaseDelivery(client: mockClient, customLog: mockLog);
    final operation = GoogleLongrunningOperation()..name = 'operationName';

    final api = FirebaseAppDistributionApi(mockClient);

    fakeAsync((async) {
      runZonedGuarded(
        () {
          firebaseDelivery.pollOperations(api, operation);
        },
        (e, s) {},
      );
      async
        ..flushMicrotasks()
        ..elapse(const Duration(seconds: 5 * 60));
    });

    expect(mockLog.logs, contains('Operation timed out'));
  });
}
