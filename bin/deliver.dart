import 'dart:io';

import 'package:args/args.dart';
import 'package:truck/src/deliveries/firebase/firebase_delivery.dart';
import 'package:truck/src/help_util.dart';
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
    print('Your `$path` appears to be empty or malformed.');
    return;
  }

  if (deliveryArgs == null) {
    print('No delivery found');
    exit(1);
  }

  final delivery =
      deliveries.where((d) => d.name == deliveryArgs.name).firstOrNull;
  final yamlConfigMap =
      (yamlMap['truck'] as YamlMap?)?[deliveryArgs.name] as YamlMap?;
  if (delivery == null || yamlConfigMap == null) {
    print('No delivery configuration found');
    exit(1);
  }
  delivery.deliver(deliveryArgs, yamlConfigMap);
}
