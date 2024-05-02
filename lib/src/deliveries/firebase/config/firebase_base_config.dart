import 'package:collection/collection.dart';
import 'package:meta/meta.dart';

@immutable
class FirebaseBaseConfig {
  const FirebaseBaseConfig({
    this.releaseNotes,
    this.groups,
    this.testers,
  });

  final String? releaseNotes;
  final List<String>? groups;
  final List<String>? testers;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is FirebaseBaseConfig &&
            releaseNotes == other.releaseNotes &&
            const DeepCollectionEquality().equals(groups, other.groups) &&
            const DeepCollectionEquality().equals(testers, other.testers);
  }

  @override
  int get hashCode => Object.hashAll([releaseNotes, groups, testers]);
}
