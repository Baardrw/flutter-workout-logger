import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:pu_frontend/common/appstate.dart';
import 'package:pu_frontend/models/session.dart';

import 'package:pu_frontend/widgets/workout_widgets/popup_card_widget.dart';
import 'package:pu_frontend/widgets/workout_widgets/workout/workout_screen_button_content.dart';

import '../../../models/excercise.dart';
import '../../../screens/excercise_history.dart';
import '../../../services/auth_service.dart';
import '../../../services/db_service.dart';
import '../../excercise_progression_widgets/excercise_tile.dart';

class ShowWorkoutButton extends StatelessWidget {
  final WorkoutCard card;
  final String string;
  final Function(Session)? gestureDetectorOnTap;

  const ShowWorkoutButton({
    this.gestureDetectorOnTap,
    required this.card,
    required this.string,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PopupItemLauncher(
      tag: string,
      outerPadding: const EdgeInsets.all(0),
      popUp: PopUpItem(
        // paddingOuter: EdgeInsets.all(0), // Padding outside of the card
        padding: const EdgeInsets.all(8), // Padding inside of the card
        color: const Color.fromARGB(255, 232, 232, 232), // Color of the card
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(32)), // Shape of the card
        elevation: 2, // Elevation of the card
        tag: string, // MUST BE THE SAME AS IN `PopupItemLauncher`
        child: WorkoutContent(card.session),
      ),
      child: card, // Your custom child widget.
    );
  }
}

class WorkoutContent extends StatelessWidget {
  WorkoutContent(
    this.session, {
    Key? key,
  }) : super(key: key);

  final Session session;

  @override
  Widget build(BuildContext context) {
    DatabaseService dbInstanceForSessions = DatabaseService();

    return SizedBox(
      width: 350,
      height: 600,
      child: ListView(
        padding: const EdgeInsets.all(20.0),
        children: <Widget>[
          const SizedBox(height: 10),
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Text(
              session.name,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
          ),
          const Divider(
            color: Colors.blueGrey,
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(15))),
            child: Column(
              children: [
                const Text(
                  'Description',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),
                const SizedBox(height: 12),
                Text('Time estimate: ${session.timeEstimate} min'),
                Text(
                  session.description,
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          // Excercise Log cards:
          FutureBuilder(
              builder: ((context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }

                List<Excercise?> excercises = snapshot.data as List<Excercise?>;
                List<Widget> logCards = excercises
                    .where((element) => element != null)
                    .map((e) => Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: ExcerciseLogCard(excercise: e!),
                        ))
                    .toList();

                return Column(
                  children: logCards,
                );
              }),
              future: session.getExcerciseObjects()),
          const SizedBox(height: 20),
          ElevatedButton(
            // Knapp for å registrere en ny logg/instans av økten
            style: ElevatedButton.styleFrom(
              primary: const Color.fromARGB(255, 51, 100, 140),
            ),
            onPressed: () {
              SessionInstance? sessionInstance =
                  Provider.of<AppState>(context, listen: false).sessionInstance;
              print("session.id: ${session.id}");

              if (sessionInstance != null) {
                // show a dialog that allows the user to finisht the workout or delete it
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('You have an ongoing session'),
                    content: const Text(
                        'You have to complete, continue or cancel the session before you can start a new one.'),
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
                        child: const Text('Continue'),
                      ),
                      TextButton(
                        onPressed: () {
                          // Saves session as completed
                          sessionInstance.completed = true;

                          Provider.of<DatabaseService>(context, listen: false)
                              .updateSessionInstance(
                            sessionInstance,
                            Provider.of<AuthService>(context, listen: false)
                                .uid,
                          );

                          Provider.of<AppState>(context, listen: false)
                              .sessionInstance = null;

                          context.pop(); // closes the dialog

                          context.pushNamed(
                            'logNew',
                            params: {'param1': session.id, 'completed': 'f'},
                          );
                        },
                        child: const Text('Complete'),
                      ),
                      TextButton(
                        onPressed: () {
                          // Deletes sessionInstance
                          Provider.of<DatabaseService>(context, listen: false)
                              .deleteSessionInstance(
                            sessionInstance,
                            Provider.of<AuthService>(context, listen: false)
                                .uid,
                          );

                          Provider.of<AppState>(context, listen: false)
                              .sessionInstance = null;

                          context.pop(); // closes the dialog

                          context.pushNamed(
                            'logNew',
                            params: {'param1': session.id, 'completed': 'f'},
                          );
                        },
                        child: const Text('Cancel'),
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
            },
            child: const Text('Register new session'),
          ),
          const SizedBox(height: 30),
          const Divider(
            color: Colors.blueGrey,
            thickness: 5,
          ),
          const SizedBox(height: 30),
          const Center(
            child: Text(
              'Completed sessions',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
          ),
          const SizedBox(height: 30),

          FutureBuilder(
              builder: ((context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (!snapshot.hasData) {
                  return const Center(child: Text('Ingen tidligere logger'));
                }

                List<SessionInstance?> sessionInstances =
                    snapshot.data as List<SessionInstance?>;

                List<Widget> logCards = sessionInstances
                    .where((element) => element != null)
                    .where((element) => element!.completed)
                    .map((e) => Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: SessionInstanceCard(
                            sessionInstance: e!,
                          ),
                        ))
                    .toList();

                return Column(
                  children: logCards,
                );
              }),
              future: dbInstanceForSessions.getInstancesOfSession(session.id,
                  Provider.of<AuthService>(context, listen: false).uid)),
          const SizedBox(height: 30),
        ],
      ),
    );
  }
}

class SessionInstanceCard extends StatelessWidget {
  final SessionInstance sessionInstance;

  SessionInstanceCard({
    super.key,
    required this.sessionInstance,
  });

  @override
  Widget build(BuildContext context) {
    DateTime date = sessionInstance.sessionInstanceId;

    // TODO: dynamacise logged workout
    return GestureDetector(
      onTap: () => context.pushNamed(
        'logNew',
        params: {'param1': sessionInstance.sessionId, 'completed': 'true'},
        extra: sessionInstance,
      ),
      child: Container(
          decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(15))),
          padding: const EdgeInsets.all(20),
          width: MediaQuery.of(context).size.width,
          child: Center(child: Text(DateFormat('dd.MM.yyyy').format(date)))),
    );
  }
}

class ExcerciseLogCard extends StatelessWidget {
  const ExcerciseLogCard({
    super.key,
    required this.excercise,
  });

  final Excercise excercise;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(15))),
      width: MediaQuery.of(context).size.width * 0.95,
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(
          children: [
            SizedBox(
                height: 40,
                child: Center(
                  child: Text(
                    excercise.name,
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                )),
            Expanded(child: Container()),
            SizedBox(
              height: 30,
              width: 30,
              child: ElevatedButton(
                  // Knapp for å registrere en ny logg/instans av økten
                  style: ElevatedButton.styleFrom(
                      primary: const Color.fromARGB(255, 51, 100, 140),
                      padding: const EdgeInsets.all(1)),
                  onPressed: () => _showExcerciseHistory(context, excercise),
                  child: const Icon(
                    Icons.bar_chart,
                    size: 15,
                  )),
            ),
          ],
        ),
        const Divider(
          color: Color.fromARGB(255, 190, 190, 190),
          thickness: 3,
        ),
        const SizedBox(
          height: 10,
        ),
        Text(
          excercise.description,
        ),
        const SizedBox(
          height: 10,
        ),
      ]),
    );
  }

  Future<void> _showExcerciseHistory(
      BuildContext context, Excercise excercise) async {
    // Checks if the excercise has logs in the database
    if (!await Provider.of<DatabaseService>(context, listen: false).logExists(
        excercise.name, Provider.of<AuthService>(context, listen: false).uid)) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('No logs for this excercise'),
        duration: Duration(seconds: 3),
      ));
      return;
    }
    // Logs for the chosen excercise are fetched
    List<Log> logs = await Provider.of<DatabaseService>(context, listen: false)
        .getLogs(excercise.name,
            Provider.of<AuthService>(context, listen: false).uid);

    // The user is navigated to the excercise history screen where the logs are displayed
    // ignore: use_build_context_synchronously
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return ExcerciseHistory(excercise: excercise, logs: logs);
    }));
  }
}
