import 'excercise.dart';

class Program {

  final String name;
  final List<Excercise> excercises;

  Program({
    required this.name,
    required this.excercises,
  });

  Program.fromJson(Map<String, Object?> json)
      : name = json['name'] as String,
        excercises = (json['excercises'] as List)
            .map((e) => Excercise.fromJson(e as Map<String, Object?>))
            .toList();

  Map<String, Object?> toJson() {
    return {
      'name': name,
      'excercises': excercises.map((e) => e.toJson()).toList(),
    };
  }
}
