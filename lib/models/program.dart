import 'package:pu_frontend/models/session.dart';
import 'package:pu_frontend/services/auth_service.dart';

import '../services/db_service.dart';
import 'excercise.dart';

/// A program is a collection of sessions, so is complex and can be retreived via
class Program {
  /// Tentativley the name is set to the key attribute in the database
  /// In ER terms program is a weak entity
  final String name;

  /// List of sessionIDs, ensure to use the session.id method when adding sessions
  /// to this list
  final List<String>? sessions;

  Program({
    required this.name,
    this.sessions,
  });

  Program.fromJson(Map<String, Object?> json)
      : name = json['name'] as String,
        sessions = (json['sessions'] as List<dynamic>?)
            ?.map((e) => e as String)
            .toList();

  Map<String, Object?> toJson() {
    return {
      'name': name,
      'sessions': sessions,
    };
  }

  String get id {
    return name;
  }

  Future<List<Session>> getSessionObjects() async {
    DatabaseService db = DatabaseService();
    AuthService auth = AuthService();

    List<Session> sessionList = [];

    for (String session in sessions!) {
      sessionList.add(await db.getSession(
        session,
        auth.uid,
      ));
    }

    return sessionList;
  }
}
