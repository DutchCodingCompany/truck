import 'package:args/args.dart';
import 'package:args/src/arg_results.dart';
import 'package:test/test.dart';
import 'package:truck/src/args_results_extension.dart';

void main() {
  test('getCommand from argresult by name', () {
    final commandResults = newArgResults(
      ArgParser(),
      {},
      'commandName',
      null,
      [],
      [],
    );
    final argResults = newArgResults(
      ArgParser(),
      {},
      'normalResultsName',
      commandResults,
      [],
      [],
    );

    final result = argResults.getCommand('commandName');

    expect(result, commandResults);
  });

  test('getCommand from argresult by name returns null if name doenst match', () {
    final commandResults = newArgResults(
      ArgParser(),
      {},
      'commandName',
      null,
      [],
      [],
    );
    final argResults = newArgResults(
      ArgParser(),
      {},
      'normalResultsName',
      commandResults,
      [],
      [],
    );

    final result = argResults.getCommand('wrong');

    expect(result, isNull);
  });

  test('getCommand from argresult by name returns null if there is no '
      'command result', () {
    final argResults = newArgResults(
      ArgParser(),
      {},
      'normalResultsName',
      null,
      [],
      [],
    );

    final result = argResults.getCommand('something');

    expect(result, isNull);
  });
}
