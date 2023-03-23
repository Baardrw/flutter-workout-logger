import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pu_frontend/services/auth_service.dart';
import 'package:pu_frontend/services/db_service.dart';

import 'package:pu_frontend/widgets/workout_widgets/workout/workout_screen_button_content.dart';
import 'package:pu_frontend/widgets/workout_widgets/program/program_screen_button_content.dart';
import 'package:pu_frontend/widgets/workout_widgets/program/add_program_pop_up.dart';
import 'package:pu_frontend/widgets/workout_widgets/workout/workout_pop_up.dart';
import 'package:pu_frontend/widgets/workout_widgets/program/program_pop_up_content.dart';

import '../../../models/program.dart';

class ProgramsView extends StatelessWidget {
  const ProgramsView({super.key});

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
                  List<Program>? programs = snapshot.data;
                  if (programs == null) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  List<GestureDetector> programButtons = programs
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
                                db.deleteProgram(e, authService.uid);
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
                          child: Column(
                            children: [
                              SizedBox(height: 8),
                              ShowProgramButton(
                                card: ProgramCard(e),
                                string: e.id,
                                uid: authService.uid,
                              ),
                            ],
                          ),
                        ),
                      )
                      .toList();

                  return ListView(
                    padding: const EdgeInsets.all(10.0),
                    children: [
                      ...programButtons,
                      const AddProgramButton(),
                    ],
                  );
                },
                future: db.getPrograms(authService.uid));
          },
          stream: db.getProgramStrean(authService.uid)),
    );
  }
}
