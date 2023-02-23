import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pu_frontend/services/auth_service.dart';
import 'package:pu_frontend/services/db_service.dart';

import 'package:pu_frontend/widgets/workout_widgets/workout/workout_card_widget.dart';
import 'package:pu_frontend/widgets/workout_widgets/workout/add_workout_button.dart';
import 'package:pu_frontend/widgets/workout_widgets/workout/show_workout_button.dart';

import '../../../models/session.dart';

class WorkoutsView extends StatelessWidget {
  const WorkoutsView({super.key});

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
                          onLongPress: () {
                            // set up the buttons
                            Widget cancelButton = TextButton(
                              child: Text("Cancel"),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            );
                            Widget continueButton = TextButton(
                              child: Text("Continue"),
                              onPressed: () {
                                db.deleteSession(e, authService.uid);
                                Navigator.of(context).pop();
                              },
                            );

                            // set up the AlertDialog
                            AlertDialog alert = AlertDialog(
                              title: Text("Delete "),
                              content: const Text(
                                  "Are you sure you want to delete this workout program?"),
                              actions: [
                                cancelButton,
                                continueButton,
                              ],
                            );

                            // show the dialog
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return alert;
                              },
                            );
                          },
                          child: ShowWorkoutButton(
                              card: WorkoutCard(e), string: e.id),
                        ),
                      )
                      .toList();

                  return GridView(
                    padding: const EdgeInsets.all(15.0),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 12.0,
                            mainAxisSpacing: 12.0),
                    children: [
                      ...workoutButtons,
                      const AddWorkoudButton(),
                    ],
                  );
                },
                future: db.getSessions(authService.uid));
          },
          stream: db.getSessionStream(authService.uid)),
    );
  }
}
