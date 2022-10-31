import 'package:uuid/uuid.dart';

class Person {
  final String name;
  final String uid;
  final int age;

  Person({required this.name, required this.age, String? uid})
      : uid = uid ?? const Uuid().v4();

  Person updated([String? name, int? age]) =>
      Person(age: age ?? this.age, name: name ?? this.name, uid: uid);

  String get displayName => '$name ($age years old)';

  @override
  bool operator ==(covariant Person other) => uid == other.uid;

  @override
  int get hashCode => Object.hash(name, age, uid);

  @override
  String toString() {
    return 'Person(name: $name, age: $age, uid: $uid)';
  }
}
