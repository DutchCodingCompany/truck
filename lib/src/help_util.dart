import 'dart:io';

import 'package:args/args.dart';

/// Print a help message if the `help` option is provided.
void printHelp(ArgResults result, ArgParser parser) {
  if (result['help'] == false) return;
  print('Usage: deliver [options] <command> [command options]');
  print(parser.usage);
  if (parser.commands.isNotEmpty) {
    for (final command in parser.commands.entries) {
      print('\n${command.key} commands:');
      print(command.value.usage);
    }
  }
  exit(0);
}
