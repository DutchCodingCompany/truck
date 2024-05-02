import 'package:args/args.dart';
import 'package:collection/collection.dart';
import 'package:test/test.dart';
import 'package:truck/src/deliveries/firebase/firebase_delivery.dart';

bool Function(List<String>?, List<String>?) eq = const ListEquality<String>().equals;

void main() {
  late FirebaseDelivery delivery;
  late ArgParser parser;

  setUp(() {
    delivery = const FirebaseDelivery();
    parser = delivery.parser;
  });

  test('parse global firebase options', () {
    final args = _args('--cli-token=token --groups=group1,group2 --testers=tester1,tester2');

    final result = delivery.parseArgs(parser.parse(args));

    expect(result.serviceAccountFile, 'token');
    expect(eq(result.groups, ['group1', 'group2']), isTrue);
    expect(eq(result.testers, ['tester1', 'tester2']), isTrue);
    expect(result.android, null);
    expect(result.ios, null);
  });

  test('parse android firebase options', () {
    final args = _args('android --file pubspec.yaml --app-id 123 --groups=group1,group2 --testers=tester1,tester2');

    final result = delivery.parseArgs(parser.parse(args));

    expect(result.serviceAccountFile, '');
    expect(eq(result.groups, []), isTrue);
    expect(eq(result.testers, []), isTrue);
    expect(result.android, isNotNull);
    expect(result.ios, null);

    expect(eq(result.android?.groups, ['group1', 'group2']), isTrue);
    expect(eq(result.android?.testers, ['tester1', 'tester2']), isTrue);
    expect(result.android?.appId, '123');
    expect(result.android?.file, 'pubspec.yaml');
  });

  test('parse ios firebase options', () {
    final args = _args('ios --file pubspec.yaml --app-id 123 --groups=group1,group2 --testers=tester1,tester2');

    final result = delivery.parseArgs(parser.parse(args));

    expect(result.serviceAccountFile, '');
    expect(eq(result.groups, []), isTrue);
    expect(eq(result.testers, []), isTrue);
    expect(result.ios, isNotNull);
    expect(result.ios, null);

    expect(eq(result.ios?.groups, ['group1', 'group2']), isTrue);
    expect(eq(result.ios?.testers, ['tester1', 'tester2']), isTrue);
    expect(result.ios?.appId, '123');
    expect(result.ios?.file, 'pubspec.yaml');
  });
}

List<String> _args(String args) => args.split(' ');
