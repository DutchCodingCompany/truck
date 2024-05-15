import 'dart:io';

final _exp = RegExp(r'\$(?<ENV>\w*)');

String applyEnviroments(String original) {
  return original.replaceAllMapped(_exp, (match) {
    final key = match.group(1);
    if (key != null) {
      if (Platform.environment.containsKey(key)) {
        return Platform.environment[key]!;
      } else {
        return match.group(0)!;
      }
    } else {
      return '';
    }
  });
}
