import 'package:pu_frontend/models/session.dart';

import 'excercise.dart';

class Program {
  final String name;
  // These lists result in a lot of redundant storage TODO : Change
  final List<Excercise>? excercises;
  final List<Session>? sessions;

  Program({
    required this.name,
    this.excercises,
    this.sessions,
  });

  Program.fromJson(Map<String, Object?> json)
      : name = json['name'] as String,
        excercises = (json['excercises'] as List)
            .map((e) => Excercise.fromJson(e as Map<String, Object?>))
            .toList(),
        sessions = (json['sessions'] as List)
            .map((e) => Session.fromJson(e as Map<String, Object?>))
            .toList();

  Map<String, Object?> toJson() {
    return {
      'name': name,
      'excercises': excercises?.map((e) => e.toJson()).toList(),
      'sessions': sessions?.map((e) => e.toJson()).toList(),
    };
  }
}
