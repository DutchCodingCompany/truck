import 'package:args/args.dart';
import 'package:yaml/yaml.dart';

abstract interface class Delivery {

  (String, ArgParser) get parser;

  void deliver(ArgResults args, YamlMap config);
}
