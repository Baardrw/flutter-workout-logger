
import 'excercise.dart';

class Session {

  final String name;
  final List<Excercise> excercises;



  Session({
    required this.name,
    required this.excercises,
  });

  Session.fromJson(Map<String, Object?> json)
      : name = json['name'] as String,
        excercises = (json['excercises'] as List)
            .map((e) => Excercise.fromJson(e as Map<String, Object?>))
            .toList();
  }






