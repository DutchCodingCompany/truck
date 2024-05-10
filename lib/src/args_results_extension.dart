import 'package:args/args.dart';

/// Extension for [ArgResults]
extension ArgsResultsExtension on ArgResults {
  /// Returns the command with the given [name] or `null` if it does not exist.
  ArgResults? getCommand(String name) => command?.name == name ? command : null;

  /// Returns the value of the option with the given [name] or `null` if it
  /// does not exist.
  List<String>? multiOptionOrNull(String name) {
    final options = multiOption(name);
    if (options.isEmpty) {
      return null;
    }
    return options;
  }
}
