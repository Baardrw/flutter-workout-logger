import 'package:pu_frontend/services/db_service.dart';

import 'excercise.dart';

class Session {
  final String name;
  final String description;
  final String timeEstimate;
  final List<String>? excercises;
  final DateTime date;

  Session({
    required this.name,
    this.excercises,
    required this.date,
    required this.description,
    required this.timeEstimate,
  });

  Session.fromJson(Map<String, Object?> json)
      : name = json['name'] as String,
        description = json['description'] as String,
        timeEstimate = json['timeEstimate'] as String,
        excercises = (json['excercises'] as List<dynamic>?)
            ?.map((e) => e as String)
            .toList(),
        date = DateTime.parse(json['date'] as String);

  Map<String, Object?> toJson() {
    return {
      'name': name,
      'description': description,
      'timeEstimate': timeEstimate,
      'excercises': excercises,
      'date': date.toIso8601String(),
    };
  }

  String get id {
    // Flutter encodes dates differently than firebase, flutter looses the last 3 digits
    return date.microsecondsSinceEpoch.toString().substring(0, 13);
  }

  Future<List<Excercise?>> getExcercisesAsExcercise() async {
    DatabaseService db = DatabaseService();
    List<Excercise?> excerciseList = [];

    for (String excercise in excercises!) {
      excerciseList.add(await db.getExcercise(excercise));
    }

    return excerciseList;
  }
}

class SessionInstance {
  final List<String>? excercises;
  final String sessionId;
  final DateTime sessionInstanceId;

  SessionInstance({
    required this.sessionId,
    required this.sessionInstanceId,
    this.excercises,
  });

  SessionInstance.fromJson(Map<String, Object?> json)
      : sessionId = json['sessionId'] as String,
        excercises = (json['excercises'] as List<dynamic>?)
            ?.map((e) => e as String)
            .toList(),
        sessionInstanceId = DateTime.parse(json['sessionInstanceId'] as String);

  Map<String, Object?> toJson() {
    return {
      'sessionId': sessionId,
      'excercises': excercises,
      'sessionInstanceId': id,
    };
  }

  String get id {
    // Flutter encodes dates differently than firebase, flutter looses the last 3 digits
    return sessionInstanceId.microsecondsSinceEpoch.toString().substring(0, 13);
  }
}
