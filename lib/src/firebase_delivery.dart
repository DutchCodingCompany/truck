import 'package:args/args.dart';
import 'package:truck/src/delivery.dart';
import 'package:yaml/yaml.dart';

class FirebaseDelivery implements Delivery {
  const FirebaseDelivery();

  @override
  (String, ArgParser) get parser {
    final argsParser = ArgParser();

    return ('firebase', ArgParser());
  }

  @override
  void deliver(ArgResults args, YamlMap config) {
    print('Delivering via Firebase');
  }
}
