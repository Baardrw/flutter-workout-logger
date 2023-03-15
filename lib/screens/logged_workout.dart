import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../widgets/workout_widgets/workout/workouts_view_widget.dart';
import '../widgets/excercise_progression_widgets/excercise_tile.dart';
import '../models/excercise.dart';
import '../main.dart';

class LoggedWorkout extends StatelessWidget {
  const LoggedWorkout({super.key});

  @override
  Widget build(BuildContext context) {
    Excercise ex1 = new Excercise(
        type: ExcerciseType.strength,
        bodyPart: BodyPart.chest,
        name: 'Pushups',
        description: 'Push against the ground with your arms while keeping the core and legs engaged.');
    Repetition rep1 = Repetition();
    Repetition rep2 = Repetition();
    Repetition rep3 = Repetition();
    List<Repetition> repetitions = [rep1, rep2, rep3];
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 225, 225, 225),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 51, 100, 140),
        title: Text('23.01.2023'),
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
                    'Description of the session / title',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                  SizedBox(height: 12),
                  Text(
                      'With this session, the goal is for you to become comfortable with holding the position for a long time. Start with 3 sets of 10 pushups, take a 2-minute break, etc.'),
                ],
              ),
            ),
            SizedBox(height: 40),
            Text(
              'Exercises',
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
          'Vary how you position your hands. If you want a greater challenge, you can add weight to your back.',
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
