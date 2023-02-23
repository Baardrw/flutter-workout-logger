
import 'excercise.dart';

class Session {

  final String name;
  final List<Excercise>? excercises;
  final DateTime date;

  Session({
    required this.name,
    this.excercises,
    required this.date,
  });

  Session get session {
    return Session(
      name: name,
      excercises: excercises,
      date: date,
    );
  }

  Session.fromJson(Map<String, Object?> json)
      : name = json['name'] as String,
        excercises = (json['excercises'] as List<dynamic>?)
            ?.map((e) => Excercise.fromJson(e as Map<String, Object?>))
            .toList(),
        date = DateTime.parse(json['date'] as String);

  Map<String, Object?> toJson() {
    return {
      'name': name,
      'excercises': excercises?.map((e) => e.toJson()).toList(),
      'date': date.toIso8601String(),
    };
  }
  String get id {
    // Flutter encodes dates differently than firebase, flutter looses the last 3 digits
    return date.microsecondsSinceEpoch.toString().substring(0, 13);
  }

}






