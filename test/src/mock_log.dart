import 'dart:async';

import 'package:truck/src/util/logging.dart';

class MockLog implements Log {
  final List<Object?> logs = [];

  @override
  Never error(Object? message) {
    logs.add(message);
    // ignore: only_throw_errors
    throw Never;
  }

  @override
  void info(Object? message) => logs.add(message);
}
