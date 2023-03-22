import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:pu_frontend/models/session.dart';
import 'package:pu_frontend/models/program.dart';

import 'package:pu_frontend/widgets/workout_widgets/popup_card_widget.dart';
import 'package:pu_frontend/widgets/workout_widgets/program/program_screen_button_content.dart';
import 'package:pu_frontend/widgets/workout_widgets/workout/workout_pop_up.dart';
import 'package:pu_frontend/widgets/workout_widgets/workout/workout_screen_button_content.dart';

import '../../../common/appstate.dart';
import '../../../services/auth_service.dart';
import '../../../services/db_service.dart';

class ShowProgramButton extends StatelessWidget {
  final ProgramCard card;
  final String string;
  final String uid;

  const ShowProgramButton({
    required this.card,
    required this.string,
    required this.uid,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PopupItemLauncher(
      tag: string,
      outerPadding: EdgeInsets.all(0),
      child: card,
      popUp: PopUpItem(
          // paddingOuter: EdgeInsets.all(0), // Padding outside of the card
          padding: EdgeInsets.all(8), // Padding inside of the card
          color: Color.fromARGB(255, 232, 232, 232), // Color of the card
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(32)), // Shape of the card
          elevation: 2, // Elevation of the card
          tag: string, // MUST BE THE SAME AS IN `PopupItemLauncher`
          child:
              ProgramContent(card.program, uid)), // Your custom child widget.
    );
  }
}

class ProgramContent extends StatelessWidget {
  final Program program;
  final String uid;

  const ProgramContent(
    this.program,
    this.uid, {
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    DatabaseService dbInstanceForSessions = DatabaseService();
    return Container(
      height: MediaQuery.of(context).size.height * 0.75,
      width: MediaQuery.of(context).size.width * 0.9,
      child: FutureBuilder(
          builder: ((context, snapshot) {
            // print('Snap 1: $snapshot');
            if (!snapshot.hasData) {
              return const Center(child: CircularProgressIndicator());
            }
            // print('Snap 2: $snapshot');

            Map<String, List<Session?>> sessionDays =
                snapshot.data as Map<String, List<Session>>;

            List<Widget> mondayCards = sessionDays['monday']!
                .where((element) => element != null)
                .map((e) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: GestureDetector(
                        child: WorkoutCard(e!),
                        onTap: () {
                          SessionInstance? sessionInstance =
                              Provider.of<AppState>(context, listen: false)
                                  .sessionInstance;
                          onPressedSession(sessionInstance, context, e);
                        },
                      ),
                    ))
                .toList();
            List<Widget> tuesdayCards = sessionDays['tuesday']!
                .where((element) => element != null)
                .map((e) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: GestureDetector(
                        child: WorkoutCard(e!),
                        onTap: () {
                          SessionInstance? sessionInstance =
                              Provider.of<AppState>(context, listen: false)
                                  .sessionInstance;
                          onPressedSession(sessionInstance, context, e);
                        },
                      ),
                    ))
                .toList();
            List<Widget> wednesdayCards = sessionDays['wednesday']!
                .where((element) => element != null)
                .map((e) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: GestureDetector(
                        child: WorkoutCard(e!),
                        onTap: () {
                          SessionInstance? sessionInstance =
                              Provider.of<AppState>(context, listen: false)
                                  .sessionInstance;
                          onPressedSession(sessionInstance, context, e);
                        },
                      ),
                    ))
                .toList();

            List<Widget> thursdayCards = sessionDays['thursday']!
                .where((element) => element != null)
                .map((e) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: GestureDetector(
                        child: WorkoutCard(e!),
                        onTap: () {
                          SessionInstance? sessionInstance =
                              Provider.of<AppState>(context, listen: false)
                                  .sessionInstance;
                          onPressedSession(sessionInstance, context, e);
                        },
                      ),
                    ))
                .toList();
            List<Widget> fridayCards = sessionDays['friday']!
                .where((element) => element != null)
                .map((e) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: GestureDetector(
                        child: WorkoutCard(e!),
                        onTap: () {
                          SessionInstance? sessionInstance =
                              Provider.of<AppState>(context, listen: false)
                                  .sessionInstance;
                          onPressedSession(sessionInstance, context, e);
                        },
                      ),
                    ))
                .toList();
            List<Widget> saturdayCards = sessionDays['saturday']!
                .where((element) => element != null)
                .map((e) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: GestureDetector(
                        child: WorkoutCard(e!),
                        onTap: () {
                          SessionInstance? sessionInstance =
                              Provider.of<AppState>(context, listen: false)
                                  .sessionInstance;
                          onPressedSession(sessionInstance, context, e);
                        },
                      ),
                    ))
                .toList();

            List<Widget> sundayCards = sessionDays['sunday']!
                .where((element) => element != null)
                .map((e) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: GestureDetector(
                        child: WorkoutCard(e!),
                        onTap: () {
                          SessionInstance? sessionInstance =
                              Provider.of<AppState>(context, listen: false)
                                  .sessionInstance;
                          onPressedSession(sessionInstance, context, e);
                        },
                      ),
                    ))
                .toList();

            return ListView(
                padding: const EdgeInsets.all(10.0),
                children: <Widget>[
                  SizedBox(height: 20),
                  Center(
                    child: Text(
                      program.name,
                      style: Theme.of(context).textTheme.displayLarge,
                    ),
                  ),
                  SizedBox(height: 15),
                  Text('Description:'),
                  Text(program.description),
                  SizedBox(height: 30),
                  Text(
                    'Monday',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Divider(
                    color: Colors.blueGrey,
                  ),
                  if (mondayCards.isNotEmpty)
                    (Container(
                      height: 200,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        children: mondayCards,
                      ),
                    ))
                  else
                    (Text('No workout')),
                  SizedBox(height: 40),
                  Text(
                    'Tuesday',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Divider(
                    color: Colors.blueGrey,
                  ),
                  if (tuesdayCards.isNotEmpty)
                    (Container(
                      height: 200,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        children: tuesdayCards,
                      ),
                    ))
                  else
                    (Text('No workout')),
                  SizedBox(height: 40),
                  Text(
                    'Wednesday',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Divider(
                    color: Colors.blueGrey,
                  ),
                  if (wednesdayCards.isNotEmpty)
                    (Container(
                      height: 200,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        children: wednesdayCards,
                      ),
                    ))
                  else
                    (Text('No workout')),
                  SizedBox(height: 40),
                  Text(
                    'Thursday',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Divider(
                    color: Colors.blueGrey,
                  ),
                  if (thursdayCards.isNotEmpty)
                    (Container(
                      height: 200,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        children: thursdayCards,
                      ),
                    ))
                  else
                    (Text('No workout')),
                  SizedBox(height: 40),
                  Text(
                    'Friday',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Divider(
                    color: Colors.blueGrey,
                  ),
                  if (fridayCards.isNotEmpty)
                    (Container(
                      height: 200,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        children: fridayCards,
                      ),
                    ))
                  else
                    (Text('No workout')),
                  SizedBox(height: 40),
                  Text(
                    'Saturday',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Divider(
                    color: Colors.blueGrey,
                  ),
                  if (saturdayCards.isNotEmpty)
                    (Container(
                      height: 200,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        children: saturdayCards,
                      ),
                    ))
                  else
                    (Text('No workout')),
                  SizedBox(height: 40),
                  Text(
                    'Sunday',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Divider(
                    color: Colors.blueGrey,
                  ),
                  if (sundayCards.isNotEmpty)
                    GestureDetector(
                      child: (Container(
                        height: 200,
                        child: ListView(
                          scrollDirection: Axis.horizontal,
                          children: sundayCards,
                        ),
                      )),
                    )
                  else
                    (Text('No workout')),
                  SizedBox(height: 40),
                ]);
          }),
          future: program.getSessionObjects(uid)),
    );
  }

  void onPressedSession(
      SessionInstance? sessionInstance, BuildContext context, Session session) {
    if (sessionInstance != null) {
      // show a dialog that allows the user to finisht the workout or delete it
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Du har allerede en økt i gang'),
          content: const Text(
              'Du må fullføre, fortsette eller avbryte den økten før du kan starte en ny.'),
          actions: [
            TextButton(
              onPressed: () {
                // Re routes the user to the workout page, allowing the user to
                // continue the workout
                context.pop(); // closes the dialog

                context.pushNamed(
                  'logNew',
                  params: {'param1': session.id, 'completed': 'f'},
                  extra: sessionInstance,
                );
              },
              child: const Text('Fortsett'),
            ),
            TextButton(
              onPressed: () {
                // Saves session as completed
                sessionInstance.completed = true;

                Provider.of<DatabaseService>(context, listen: false)
                    .updateSessionInstance(
                  sessionInstance,
                  Provider.of<AuthService>(context, listen: false).uid,
                );

                Provider.of<AppState>(context, listen: false).sessionInstance =
                    null;

                context.pop(); // closes the dialog

                context.pushNamed(
                  'logNew',
                  params: {'param1': session.id, 'completed': 'f'},
                );
              },
              child: const Text('Fullfør'),
            ),
            TextButton(
              onPressed: () {
                // Deletes sessionInstance
                Provider.of<DatabaseService>(context, listen: false)
                    .deleteSessionInstance(
                  sessionInstance,
                  Provider.of<AuthService>(context, listen: false).uid,
                );

                Provider.of<AppState>(context, listen: false).sessionInstance =
                    null;

                context.pop(); // closes the dialog

                context.pushNamed(
                  'logNew',
                  params: {'param1': session.id, 'completed': 'f'},
                );
              },
              child: const Text('Avbryt'),
            ),
          ],
        ),
      );
    } else {
      context.pushNamed(
        'logNew',
        params: {'param1': session.id, 'completed': 'f'},
      );
    }
  }
}
