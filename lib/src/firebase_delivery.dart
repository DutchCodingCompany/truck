import 'package:args/args.dart';
import 'package:truck/src/args_results_extension.dart';
import 'package:truck/src/delivery.dart';
import 'package:truck/src/firebase_config.dart';
import 'package:truck/src/help_util.dart';
import 'package:yaml/yaml.dart';

class FirebaseDelivery implements Delivery {
  const FirebaseDelivery();

  @override
  String get name => 'firebase';

  @override
  ArgParser get parser {
    final androidParser = _appParser;
    final iosParser = _appParser;
    final baseParser = _baseArgParser
      ..addFlag(
        'help',
        abbr: 'h',
        help: 'Prints usage information.',
        negatable: false,
      )
      ..addOption('cli-token', abbr: 'c', help: 'Specify CLI Token')
      ..addCommand('android', androidParser)
      ..addCommand('ios', iosParser);

    return baseParser;
  }

  @override
  void deliver(ArgResults args, YamlMap config) {
    final argsConfig = parseArgs(args);
    final yamlConfig = FirebaseConfig.fromYaml(config);
    final mergedConfig = yamlConfig.merge(argsConfig);
    print(' 🚚 Delivering to Firebase 🚚');
    print(mergedConfig);
  }

  FirebaseConfig parseArgs(ArgResults args) {
    printHelp(args, parser);
    return FirebaseConfig(
      cliToken: args.option('cli-token') ?? '',
      releaseNotes: args.option('release-notes'),
      groups: args.multiOption('groups'),
      testers: args.multiOption('testers'),
      android: parseAppArgs(args.getCommand('android')),
      ios: parseAppArgs(args.getCommand('ios')),
    );
  }

  FirebasePlatformConfig? parseAppArgs(ArgResults? args) {
    if (args == null) return null;
    printHelp(args, _appParser);

    return FirebasePlatformConfig(
      appId: args.option('app-id') ?? '',
      file: args.option('file') ?? '',
      releaseNotes: args.option('release-notes'),
      groups: args.multiOption('groups'),
      testers: args.multiOption('testers'),
    );
  }

  ArgParser get _baseArgParser => ArgParser()
    ..addOption('release-notes', abbr: 'r', help: 'Specify Release Notes')
    ..addMultiOption('groups', abbr: 'g', help: 'Specify Test Groups')
    ..addMultiOption('testers', abbr: 't', help: 'Specify Testers');

  ArgParser get _appParser => _baseArgParser
    ..addFlag(
      'help',
      abbr: 'h',
      help: 'Prints usage information.',
      negatable: false,
    )
    ..addOption('app-id', abbr: 'a', help: 'Specify App ID')
    ..addOption('file', abbr: 'f', help: 'Specify File');
}
