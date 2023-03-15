import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../widgets/app_bar.dart';
import '../widgets/workout_widgets/workout/workouts_view_widget.dart';
import '../widgets/excercise_progression_widgets/excercise_tile.dart';
import '../models/excercise.dart';
import '../main.dart';

class LoggedWorkout extends StatelessWidget {
  const LoggedWorkout({super.key});

  @override
  Widget build(BuildContext context) {
    Excercise ex1 = Excercise(
        type: ExcerciseType.strength,
        bodyPart: BodyPart.chest,
        name: 'Pushups',
        description: 'Dytt henda mot gulvet');
    Repetition rep1 = Repetition();
    Repetition rep2 = Repetition();
    Repetition rep3 = Repetition();
    List<Repetition> repetitions = [rep1, rep2, rep3];
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 225, 225, 225),
      appBar: GlobalAppBar(
        title: '23.01.2023',
      ),
      body: Center(
        child: ListView(
          padding: EdgeInsets.all(12),
          children: [
            Container(
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(15))),
              child: Column(
                children: [
                  Text(
                    'Beskrivelse av økten / tittel',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                  SizedBox(height: 12),
                  Text(
                      'Med denne økten er det meningen at du skal\nbli komfortabel med å holde ut i den posisjonen lenge.\nStart med 3x10 pushups, ta 2 min pause, osv'),
                ],
              ),
            ),
            SizedBox(height: 40),
            Text(
              'Øvelser',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            SizedBox(height: 12),
            Excercise_log_card(ex1: ex1),
          ],
        ),
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
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(15))),
      padding: EdgeInsets.all(20),
      width: MediaQuery.of(context).size.width * 0.9,
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text('Pushups',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
            )),
        const Divider(
          color: Color.fromARGB(255, 190, 190, 190),
          thickness: 3,
        ),
        SizedBox(
          height: 10,
        ),
        const Text(
          'Varierer hvordan du posisjonerer hendene dine.\nDersom du ønsker størree utfordring kan du legge en vekt på ryggen din.',
        ),
        SizedBox(
          height: 10,
        ),
        const Divider(
          color: Color.fromARGB(255, 190, 190, 190),
          thickness: 3,
        ),
        SizedBox(
          height: 20,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Set'),
            Text('Rep          kg    '),
          ],
        ),
        SizedBox(
          height: 12,
        ),
        Repetition(),
        SizedBox(
          height: 20,
        ),
      ]),
    );
  }
}

class Repetition extends StatelessWidget {
  const Repetition({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: const [
            Text('1'),
            Text('10    x    10     '),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: const [
            Text('2'),
            Text('12    x    15     '),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: const [
            Text('3'),
            Text('12    x    20     '),
          ],
        ),
      ],
    );
  }
}
