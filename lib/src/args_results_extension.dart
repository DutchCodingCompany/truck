import 'package:args/args.dart';

extension ArgsResultsExtension on ArgResults {
  ArgResults? getCommand(String name) => command?.name == name ? command : null;

  List<String>? multiOptionOrNull(String name) {
    final options = multiOption(name);
    if (options.isEmpty) {
      return null;
    }
    return options;
  }
}
