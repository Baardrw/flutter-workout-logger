import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/session.dart';
import '../../models/user.dart';
import '../../services/auth_service.dart';
import '../../services/db_service.dart';
import 'feedWorkoutContent.dart';
import 'friends_workout_card.dart';

class FriendsWorkout extends StatelessWidget {
  const FriendsWorkout({Key? key});

  @override
  Widget build(BuildContext context) {
    DatabaseService db = Provider.of<DatabaseService>(context);
    AuthService authService = Provider.of<AuthService>(context, listen: false);

    return Scaffold(
      backgroundColor: Color.fromARGB(255, 225, 225, 225),
      body: StreamBuilder(
        builder: (context, snapshot) {
          return FutureBuilder(
            builder: (context, snapshot) {
              List<Session>? sessions = snapshot.data;
              if (sessions == null) {
                return const Center(child: CircularProgressIndicator());
              }
              return FutureBuilder(
                builder: (context, snapshot) {
                  List<User>? friends = snapshot.data ?? [];
                  if (friends == null) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  List<GestureDetector> workoutButtons = sessions

                      .map((session) => GestureDetector(
                    child: ShowWorkoutButtonFriend(card: FriendsWorkoutCard(session, session.name), string: session.id),
                  ))
                      .toList();

                  return ListView(
                    children: workoutButtons,
                  );
                },
                future: db.getFriends(authService.uid),
              );
            },
            future: db.getSessions(authService.uid),
          );
        },
        stream: db.getSessionStream(authService.uid),
      ),
    );
  }
}
