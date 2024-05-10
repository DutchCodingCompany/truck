import 'package:args/args.dart';
import 'package:yaml/yaml.dart';

/// Interface for creating a delivery.
abstract interface class Delivery {
  /// Name of the delivery.
  String get name;

  /// The command line argument parser for the delivery.
  ArgParser get parser;

  /// Delivers the app to the specified platform.
  void deliver(ArgResults args, YamlMap config);
}
