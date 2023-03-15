import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pu_frontend/services/auth_service.dart';
import 'package:pu_frontend/services/db_service.dart';
import 'package:pu_frontend/widgets/homepage/feedWorkoutContent.dart';

import 'package:pu_frontend/widgets/workout_widgets/workout/workout_screen_button_content.dart';
import 'package:pu_frontend/widgets/workout_widgets/workout/add_workout_pop_up.dart';
import 'package:pu_frontend/widgets/workout_widgets/workout/workout_pop_up.dart';

import '../../../models/session.dart';
import 'friends_workout_card.dart';

class FriendsWorkout extends StatelessWidget {
  const FriendsWorkout({super.key});

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
              List<GestureDetector> workoutButtons = sessions
                  .map(
                    (e) => GestureDetector(
                  child: ShowWorkoutButtonFriend(
                      card: FriendsWorkoutCard(e, 'navn'), string: e.id),
                ),
              )
                  .toList();
              return ListView(
                children: workoutButtons,
              );
            },
            future: db.getSessionsFriend(authService.uid),
          );
        },
        stream: db.getSessionStreamFriends(authService.uid),
      ),
    );
  }
}
