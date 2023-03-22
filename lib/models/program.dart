import 'package:flutter/material.dart';
import 'package:pu_frontend/models/session.dart';
import 'package:pu_frontend/services/auth_service.dart';
import 'package:pu_frontend/widgets/workout_widgets/workout/workout_screen_button_content.dart';

import '../services/db_service.dart';
import 'excercise.dart';

/// A program is a collection of sessions, so is complex and can be retreived via
class Program {
  /// Tentativley the name is set to the key attribute in the database
  /// In ER terms program is a weak entity
  final String name;
  final String description;
  final DateTime date;

  /// List of sessionIDs, ensure to use the session.id method when adding sessions
  /// to this list
  final Map<String, List<String>>? days;

  Program(
      {required this.name,
      required this.description,
      required this.date,
      this.days});

  Program.fromJson(Map<String, Object?> json)
      : name = json['name'] as String,
        description = json['description'] as String,
        date = DateTime.parse(json['date'] as String),
        days = {
          if (json['days'] != null)
            for (var e in (json['days'] as Map<String, dynamic>).entries)
              e.key: List<String>.from(
                  (e.value as List<dynamic>).map((v) => v as String))
        };

  Map<String, Object?> toJson() {
    return {
      'name': name,
      'description': description,
      'date': date.toIso8601String(),
      'days': days,
    };
  }

  String get id {
    return date.microsecondsSinceEpoch.toString().substring(0, 13);
  }

  Map<String, List<String>>? getSessions() {
    return days;
  }

  Future<Map<String, List<Session>>> getSessionObjects(String uid) async {
    DatabaseService db = DatabaseService();
    Map<String, List<Session>>? daysList = {
      'monday': [],
      'tuesday': [],
      'wednesday': [],
      'thursday': [],
      'friday': [],
      'saturday': [],
      'sunday': []
    };

    for (String key in days!.keys) {
      List<Session> sessionsInDay = [];
      for (String session in days![key]!) {
        Session sessionObject = await db.getSession(session, uid);
        sessionsInDay.add(sessionObject);
      }
      daysList[key]!.addAll(sessionsInDay);
    }
    return daysList;
  }
}
