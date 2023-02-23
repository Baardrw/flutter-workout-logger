import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:pu_frontend/widgets/workout_widgets/popup_card_widget.dart';
import 'package:pu_frontend/widgets/workout_widgets/workout/workout_card_widget.dart';

import '../../../models/excercise.dart';
import '../../excercise_progression_widgets/excercise_tile.dart';

class ShowWorkoutButton extends StatelessWidget {
  final WorkoutCard test;
  final String string;

  const ShowWorkoutButton({
    required this.test,
    required this.string,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PopupItemLauncher(
      tag: string,
      outerPadding: const EdgeInsets.all(0),
      child: test,
      popUp: PopUpItem(
        // paddingOuter: EdgeInsets.all(0), // Padding outside of the card
        padding: const EdgeInsets.all(8), // Padding inside of the card
        color: const Color.fromARGB(255, 232, 232, 232), // Color of the card
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(32)), // Shape of the card
        elevation: 2, // Elevation of the card
        tag: string, // MUST BE THE SAME AS IN `PopupItemLauncher`
        child: WorkoutContent(),
      ), // Your custom child widget.
    );
  }
}

class WorkoutContent extends StatelessWidget {
  WorkoutContent({
    Key? key,
  }) : super(key: key);

  Excercise ex1 = Excercise(
      type: ExcerciseType.strength, bodyPart: BodyPart.chest, name: 'Pushups');
  Excercise ex2 = Excercise(
      type: ExcerciseType.strength, bodyPart: BodyPart.chest, name: 'Pullups');

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 350,
      height: 600,
      child: ListView(
        padding: const EdgeInsets.all(20.0),
        children: <Widget>[
          const SizedBox(height: 10),
          const Text(
            'Tittel',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
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
              children: const [
                Text(
                  'Beskrivelse',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),
                SizedBox(height: 12),
                Text(
                    'Beskrivelse beskrivelse\nHer skal du pushe maks og virkelig gi jernet. Start med 3x10 pushups, ta 2 min pause, osv'),
              ],
            ),
          ),
          const SizedBox(height: 30),
          Excercise_log_card(ex1: ex1),
          const SizedBox(height: 30),
          Excercise_log_card(ex1: ex2),
          const SizedBox(height: 30),
          ElevatedButton(
            // Knapp for å registrere en ny logg/instans av økten
            style: ElevatedButton.styleFrom(
              primary: const Color.fromARGB(255, 51, 100, 140),
            ),
            onPressed: () => context.push('/logWorkout'),
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
          Container(
              decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(15))),
              padding: const EdgeInsets.all(20),
              width: MediaQuery.of(context).size.width,
              child: const Center(child: Text('23.01.2023'))),
          const SizedBox(height: 30),
          Container(
              decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(15))),
              padding: const EdgeInsets.all(20),
              width: MediaQuery.of(context).size.width,
              child: const Center(child: Text('12.12.2022'))),
          const SizedBox(height: 30),
        ],
      ),
    );
  }
}

class Excercise_log_card extends StatelessWidget {
  const Excercise_log_card({
    super.key,
    required this.ex1,
  });

  final Excercise ex1;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(15))),
      padding: const EdgeInsets.all(20),
      width: MediaQuery.of(context).size.width * 0.95,
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(
          children: [
            Container(height: 40, child: Text(ex1.name)),
            Expanded(child: Container()),
            ElevatedButton(
              // Knapp for å registrere en ny logg/instans av økten
              style: ElevatedButton.styleFrom(
                primary: const Color.fromARGB(255, 51, 100, 140),
              ),
              onPressed: () => context.push('/ExcerciseProgression'),
              child: const Icon(Icons.bar_chart),
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
        const Text(
          'Beskrivelse beskrivelse\nhvordan hvordan',
        ),
        const SizedBox(
          height: 10,
        ),
      ]),
    );
  }
}
