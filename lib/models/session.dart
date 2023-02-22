
import 'excercise.dart';

class Session {

  final String name;
  final List<Excercise>? excercises;
  final List<Log>? logs;



  Session({
    required this.name,
    required this.excercises,
    required this.logs,
  });

  Session.fromJson(Map<String, Object?> json)
      : name = json['name'] as String,
        excercises = (json['excercises'] as List)
            .map((e) => Excercise.fromJson(e as Map<String, Object?>))
            .toList(),
        logs = (json['logs'] as List)
            .map((e) => Log.fromJson(e as Map<String, Object?>))
            .toList();

  Map<String, Object?> toJson() {
    return {
      'name': name,
      'excercises': excercises?.map((e) => e.toJson()).toList(),
      'logs': logs?.map((e) => e.toJson()).toList(),
    };
  }
  }






