import 'dart:io';

import 'package:args/args.dart';
import 'package:truck/src/deliveries/firebase/firebase_delivery.dart';
import 'package:truck/src/util/help_util.dart';
import 'package:truck/src/util/logging.dart';
import 'package:yaml/yaml.dart';

const deliveries = [
  FirebaseDelivery(),
];

void main(List<String> args) {
  final parser = ArgParser()
    ..addOption('path', abbr: 'p', help: 'Specify Path')
    ..addFlag(
      'help',
      abbr: 'h',
      help: 'Prints usage information.',
      negatable: false,
    );
  for (final delivery in deliveries) {
    parser.addCommand(delivery.name, delivery.parser);
  }

  // parse args
  final result = parser.parse(args);
  printHelp(result, parser);
  final path = result.option('path') ?? 'pubspec.yaml';
  final deliveryArgs = result.command;

  final YamlMap yamlMap;
  try {
    yamlMap = loadYaml(File(path).readAsStringSync()) as YamlMap;
  } catch (e) {
    log.error('Your `$path` appears to be empty or malformed.');
  }

  if (deliveryArgs == null) {
    log.error('No delivery found');
  }

  final delivery =
      deliveries.where((d) => d.name == deliveryArgs.name).firstOrNull;
  final yamlConfigMap =
      (yamlMap['truck'] as YamlMap?)?[deliveryArgs.name] as YamlMap?;
  if (delivery == null || yamlConfigMap == null) {
    log.error('No delivery configuration found');
  }
  delivery.deliver(deliveryArgs, yamlConfigMap);
}
