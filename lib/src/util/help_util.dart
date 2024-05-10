import 'dart:io';

import 'package:args/args.dart';
import 'package:truck/src/util/logging.dart';

/// Print a help message if the `help` option is provided.
void printHelp(ArgResults result, ArgParser parser) {
  if (result['help'] == false) return;
  log
    ..info('Usage: deliver [options] <command> [command options]')
    ..info(parser.usage);
  if (parser.commands.isNotEmpty) {
    for (final command in parser.commands.entries) {
      log
        ..info('\n${command.key} commands:')
        ..info(command.value.usage);
    }
  }
  exit(0);
}
