import 'dart:io';

import 'package:args/args.dart';
import 'package:truck/src/firebase_config.dart';
import 'package:truck/src/firebase_delivery.dart';
import 'package:truck/src/help_util.dart';
import 'package:yaml/yaml.dart';

const deliveries = [
  FirebaseDelivery(),
];

void main(List<String> args) {
  print('booop: ${args.join(', ')}');

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

  final result = parser.parse(args);

  printHelp(result, parser);
  var path = result.option('path');
  final deliveryArgs = result.command;

  if (path != null) {
    // print('Delivering $path');
  } else {
    path = 'pubspec.yaml';
  }

  print(path);

  final YamlMap yamlMap;
  try {
    yamlMap = loadYaml(File(path).readAsStringSync()) as YamlMap;
  } catch (e) {
    print('Your `$path` appears to be empty or malformed.');
    return;
  }

  final config = FirebaseConfig.fromYaml((yamlMap['truck'] as YamlMap)['firebase'] as YamlMap);

  print(config.cliToken);

// parse yaml
// configs

  final delivery = deliveries.where((d) => d.name == deliveryArgs?.name).firstOrNull;
  if (delivery == null || deliveryArgs == null) {
    print('No delivery found');
    return;
  }
  delivery.deliver(deliveryArgs, YamlMap());
// loop args
// call deliver with args and configs
}
