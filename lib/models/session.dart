import 'package:pu_frontend/screens/log_workout.dart';
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

  Future<List<Excercise?>> getExcerciseObjects() async {
    DatabaseService db = DatabaseService();
    List<Excercise?> excerciseList = [];

    for (String excercise in excercises!) {
      excerciseList.add(await db.getExcercise(excercise));
    }

    return excerciseList;
  }
}

/// A session instance is a specific instance of a session, it is a weak entity
/// to allow for an instance without a session the session id 0 is reserved for no session instances
/// this will allow the database to find them, and show them, despite them not being in a session
class SessionInstance {
  List<String>? excercises;

  /// This list is never pushed to the db, as it leads to redundancy, this is only locally constructed
  /// for ease of use in the app
  List<Repetition>? reps;
  late String sessionId;
  final DateTime sessionInstanceId;
  bool completed = false;
  String? picture;

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
        sessionInstanceId = DateTime.fromMicrosecondsSinceEpoch(
            int.parse(('${json['sessionInstanceId'] as String}000'))),
        completed = json['completed'] as bool,
        picture = json['picture'] as String?;

  Map<String, Object?> toJson() {
    return {
      'sessionId': sessionId,
      'excercises': excercises,
      'sessionInstanceId': id,
      'completed': completed,
      'picture': picture,
    };
  }

  String get id {
    // Flutter encodes dates differently than firebase, flutter looses the last 3 digits
    return sessionInstanceId.microsecondsSinceEpoch.toString().substring(0, 13);
  }

  Future<List<Excercise?>> getExcerciseObjects() async {
    DatabaseService db = DatabaseService();
    List<Excercise?> excerciseList = [];

    for (String excercise in excercises!) {
      excerciseList.add(await db.getExcercise(excercise));
    }

    return excerciseList;
  }
}
