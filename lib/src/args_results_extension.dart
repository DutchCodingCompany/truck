import 'package:args/args.dart';

extension ArgsResultsExtension on ArgResults {
  ArgResults? getCommand(String name) => command?.name == name ? command : null;
}
