import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pu_frontend/services/auth_service.dart';
import 'package:pu_frontend/services/db_service.dart';

import 'package:pu_frontend/widgets/workout_widgets/workout/workout_screen_button_content.dart';
import 'package:pu_frontend/widgets/workout_widgets/workout/add_workout_pop_up.dart';
import 'package:pu_frontend/widgets/workout_widgets/workout/workout_pop_up.dart';

import '../../../models/session.dart';
import 'new_workout_in_program.dart';

class AddWorkoutsView extends StatefulWidget {
  const AddWorkoutsView({
    super.key,
    this.gestureDetectorOnTap,
  });
  final Function(Session)? gestureDetectorOnTap;

  @override
  State<AddWorkoutsView> createState() => _AddWorkoutsView();
}

class _AddWorkoutsView extends State<AddWorkoutsView> {
  @override
  Widget build(BuildContext context) {
    DatabaseService db = Provider.of<DatabaseService>(context);
    AuthService authService = Provider.of<AuthService>(context, listen: false);
    return Scaffold(
      appBar: AppBar(title: Text('Add Session')),
      backgroundColor: Color.fromARGB(255, 225, 225, 225),
      body: StreamBuilder(
          builder: (context, snapshot) {
            return FutureBuilder(
                builder: (context, snapshot) {
                  List<Session>? sessions = snapshot.data;
                  if (sessions == null) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  List<GestureDetector> sessionCards = [];
                  for (Session s in sessions) {
                    sessionCards.add(GestureDetector(
                        child: WorkoutCard(s),
                        onTap: () {
                          if (widget.gestureDetectorOnTap != null) {
                            widget.gestureDetectorOnTap!(s);
                            Navigator.of(context).pop();
                            return;
                          }
                          ;
                        }));
                  }
                  return GridView(
                    padding: const EdgeInsets.all(15.0),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 12.0,
                            mainAxisSpacing: 12.0),
                    children: [
                      ...sessionCards,
                      const AddWorkoutButton(), // This is in new_workout_in_program.dart
                    ],
                  );
                },
                future: db.getSessions(authService.uid));
          },
          stream: db.getSessionStream(authService.uid)),
    );
  }
}
