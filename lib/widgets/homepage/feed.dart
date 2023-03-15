import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/group.dart';
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
    final db = Provider.of<DatabaseService>(context);
    final authService = Provider.of<AuthService>(context, listen: false);
    final user = Provider.of<User?>(context);

    return Scaffold(
      backgroundColor: Color.fromARGB(255, 225, 225, 225),
      body: StreamBuilder<List<Group>>(
        builder: (context, snapshot) {
          final groups = snapshot.data ?? [];

          if (groups.isEmpty) {
            return const Center(
              child: Text("Empty group list"),
            );
          }
          Group group;
          group = groups[1];
          return StreamBuilder<List<Session>>(
            builder: (context, snapshot) {
              final sessions = snapshot.data ?? [];
              if (sessions.isEmpty) {
                return Center(

                  child: Text(group.name),
                );
              }
              final workoutButtons = sessions
                  .map(
                    (session) => GestureDetector(
                  child: ShowWorkoutButtonFriend(
                    card: FriendsWorkoutCard(session, session.name),
                    string: session.id,
                  ),
                ),
              )
                  .toList();

              return ListView(
                children: workoutButtons,
              );
            },
            stream: db.getSessionsFromUsersInGroupStream(group.id),
          );
        },
        stream: db.getAllGroupsStream(),
      ),
    );
  }
}
