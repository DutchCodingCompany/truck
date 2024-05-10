import 'dart:io';

/// A simple logger.
const log = Log();

/// A simple logger.
class Log {
  /// A simple logger.
  const Log();

//ignore: avoid_print
  void _log(String message) => print(message);

  /// Logs an info message.
  void info(Object? message) => _log('🚚 $message');

  /// Logs an error message and exits the process.
  Never error(Object? message) {
    _log('💣 $message');
    exit(1);
  }
}
