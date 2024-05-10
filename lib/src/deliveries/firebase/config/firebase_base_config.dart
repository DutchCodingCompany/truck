import 'package:collection/collection.dart';
import 'package:meta/meta.dart';

/// {@template firebase_base_config}
/// Base configuration for Firebase.
/// {@endtemplate}
@immutable
class FirebaseBaseConfig {
  /// {@macro firebase_base_config}
  const FirebaseBaseConfig({
    this.releaseNotes,
    this.groups,
    this.testers,
  });

  /// {@template releaseNotes}
  /// Release notes for the Firebase distribution.
  /// {@endtemplate}
  final String? releaseNotes;

  /// {@template groups}
  /// Groups for the Firebase distribution.
  /// {@endtemplate}
  final List<String>? groups;

  /// {@template testers}
  /// Testers for the Firebase distribution.
  /// {@endtemplate}
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
