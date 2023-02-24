import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:pu_frontend/models/session.dart';

import 'package:pu_frontend/widgets/workout_widgets/program/popup_card_widget.dart';
import 'package:pu_frontend/widgets/workout_widgets/workout/workout_card_widget.dart';

import '../../../models/excercise.dart';
import '../../../screens/excercise_history.dart';
import '../../../services/auth_service.dart';
import '../../../services/db_service.dart';
import '../../excercise_progression_widgets/excercise_tile.dart';

class ShowWorkoutButton extends StatelessWidget {
  final WorkoutCard card;
  final String string;

  const ShowWorkoutButton({
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
    return Container(
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
              style: TextStyle(
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
                  'Beskrivelse',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),
                SizedBox(height: 12),
                Text(
                  session.description,
                ),
              ],
            ),
          ),
          SizedBox(height: 20),
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
              future: session.getExcercisesAsExcercise()),
          SizedBox(height: 20),
          ElevatedButton(
            // Knapp for å registrere en ny logg/instans av økten
            style: ElevatedButton.styleFrom(
              primary: const Color.fromARGB(255, 51, 100, 140),
            ),
            onPressed: () {
              Session sessionLog = session;
              String? tester = session.id;
              context.pushNamed(
                'logNew',
                params: {'param1': tester},
              );
            },
            child: const Text('Registrer ny økt'),
          ),
          const SizedBox(height: 30),
          const Divider(
            color: Colors.blueGrey,
            thickness: 5,
          ),
          const SizedBox(height: 30),
          const Center(
            child: Text(
              'Tidligere logger',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
          ),
          const SizedBox(height: 30),
          GestureDetector(
            onTap: () => context.push('/loggedWorkout'),
            child: Container(
                decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(15))),
                padding: const EdgeInsets.all(20),
                width: MediaQuery.of(context).size.width,
                child: const Center(child: Text('23.01.2023'))),
          ),
          const SizedBox(height: 30),
        ],
      ),
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
            Container(
                height: 40,
                child: Center(
                  child: Text(
                    excercise.name,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                )),
            Expanded(child: Container()),
            Container(
              height: 30,
              width: 30,
              child: ElevatedButton(
                  // Knapp for å registrere en ny logg/instans av økten
                  style: ElevatedButton.styleFrom(
                      primary: Color.fromARGB(255, 51, 100, 140),
                      padding: EdgeInsets.all(1)),
                  onPressed: () => context.push('/ExcerciseProgression'),
                  child: Icon(
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
