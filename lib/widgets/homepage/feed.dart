import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pu_frontend/services/auth_service.dart';
import 'package:pu_frontend/services/db_service.dart';
import 'package:pu_frontend/widgets/homepage/feedWorkoutContent.dart';

import 'package:pu_frontend/widgets/workout_widgets/workout/workout_screen_button_content.dart';
import 'package:pu_frontend/widgets/workout_widgets/workout/add_workout_pop_up.dart';
import 'package:pu_frontend/widgets/workout_widgets/workout/workout_pop_up.dart';

import '../../models/session.dart';
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
          if (!snapshot.hasData || snapshot.data == null) {
            print("SessionInstances snapshot is null or has no data.");
            return const SizedBox.shrink();
          }
          List<SessionInstance>? sessionInstances = snapshot.data;
          //Sorts the list of sessionInstances by date
          sessionInstances!.sort(
              (a, b) => b.sessionInstanceId.compareTo(a.sessionInstanceId));

          print("SessionInstances length: ${sessionInstances!.length}");

          return ListView.builder(
            itemCount: sessionInstances.length,
            itemBuilder: (BuildContext context, int index) {
              SessionInstance sessionInstance = sessionInstances[index];
              return FutureBuilder<Session?>(
                future: db.getAllSessionsAndCheckSession(
                    sessionInstance.sessionId,
                    sessionInstances[index].completedBy!),
                builder: (context, snapshot) {
                  if (!snapshot.hasData || snapshot.data == null) {
                    print("Session snapshot is null or has no data.");
                    return const SizedBox.shrink();
                  }
                  Session session = snapshot.data!;
                  return FutureBuilder<String?>(
                    future: sessionInstance.completedBy != "0"
                        ? db.getUsernameByUid(
                            sessionInstance.completedBy as String)
                        : Future.value("Big Chungus"),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData || snapshot.data == null) {
                        print("Username snapshot is null or has no data.");
                        return const SizedBox.shrink();
                      }
                      String username = snapshot.data!;
                      return ShowWorkoutButtonFriend(
                        card: FriendsWorkoutCard(session, username),
                        string: session.id,
                      );
                    },
                  );
                },
              );
            },
          );
        },
        stream: db.getSessionFriends(authService.uid),
      ),
    );
  }
}
