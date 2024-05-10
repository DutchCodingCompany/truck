@TestOn('vm')

import 'dart:convert';
import 'dart:io';

import 'package:test/test.dart';

void main() {
  test('Logs result from pubspec.yaml if no path is provided', () async {
    const pubspec = 'pubspec.yaml';
    final process = await Process.start(
      'dart',
      ['run', 'truck:deliver firebase'],
    );

    final lineStream = process.stdout
        .transform(const Utf8Decoder())
        .transform(const LineSplitter());

    expect(
      lineStream,
      emitsInOrder([
        pubspec,
        r'$FIREBASE_CLI_TOKEN',
      ]),
    );
  });
  test(
      'Logs result from provided path in CLI and prints messages that '
          'the path does not exist',
      () async {
    const path = 'does-not-exist.yaml';
    final process = await Process.start(
      'dart',
      ['run', 'truck:deliver', 'firebase', '--path=$path'],
    );

    final lineStream = process.stdout
        .transform(const Utf8Decoder())
        .transform(const LineSplitter());

    expect(
      lineStream,
      emitsInOrder([
        path,
        'Your `$path` appears to be empty or malformed.',
        emitsDone,
      ]),
    );
  });

  test('Logs result from provided path in CLI', () async {
    const path = 'test/sample_yamls/truck.yaml';
    final process = await Process.start(
      'dart',
      ['run', 'truck:deliver', 'firebase', '--path=$path'],
    );

    final lineStream = process.stdout
        .transform(const Utf8Decoder())
        .transform(const LineSplitter());

    expect(
      lineStream,
      emitsInOrder([
        path,
        r'$FIREBASE_CLI_TOKEN',
      ]),
    );
  });
}
