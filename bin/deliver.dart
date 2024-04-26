import 'package:args/args.dart';

void main(List<String> args) {
 print('booop: ${args.join(', ')}');

 final parser= ArgParser();
 parser.addOption('path', abbr: 'p', help: 'Path to the file to deliver');
 parser.addCommand('firebase', FirebaseDelivery.parser);

  final result = parser.parse(args);

 var path = result.option('path');

 if (path != null) {
   print('Delivering $path');
 } else {
  path = 'pubspec.yaml';
 }

// parse yaml
// configs


// loop args
// call deliver with args and configs
}
