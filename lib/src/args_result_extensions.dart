import 'package:args/args.dart';

extension ArgsResultExtension on ArgResults {
  ArgResults? getCommand(String name) => this.command?.name == name ? this.command : null;
}
