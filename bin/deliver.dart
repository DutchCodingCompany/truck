import 'dart:io';

import 'package:args/args.dart';
import 'package:truck/src/firebase_config.dart';
import 'package:yaml/yaml.dart';

void main(List<String> args) {
  final parser = ArgParser();
  parser.addOption('path', abbr: 'p', help: 'Path to the file to deliver');
  //parser.addCommand('firebase', FirebaseDelivery.parser);

  final result = parser.parse(args);

  var path = result.option('path');

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

// loop args
// call deliver with args and configs
}
