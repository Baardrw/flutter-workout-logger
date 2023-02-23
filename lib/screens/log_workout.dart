import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../widgets/workout_widgets/workout/workout_card_widget.dart';
import '../widgets/workout_widgets/workout/workouts_view_widget.dart';
import '../widgets/workout_widgets/program/program_card_widget.dart';
import '../widgets/workout_widgets/program/programs_view_widget.dart';
import '../widgets/excercise_progression_widgets/excercise_tile.dart';
import '../models/excercise.dart';
import '../main.dart';

class Log_workout extends StatelessWidget {
  const Log_workout({super.key});

  @override
  Widget build(BuildContext context) {
    Excercise ex1 = Excercise(
        type: ExcerciseType.strength,
        bodyPart: BodyPart.chest,
        name: 'Pushups');
    Repetition rep1 = const Repetition();
    Repetition rep2 = const Repetition();
    Repetition rep3 = const Repetition();
    List<Repetition> repetitions = [rep1, rep2, rep3];
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 225, 225, 225),
      appBar: AppBar(backgroundColor: const Color.fromARGB(255, 51, 100, 140)),
      body: Center(
        child: ListView(
          padding: const EdgeInsets.all(12),
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(15))),
              child: Column(
                children: [
                  const Text(
                    'Beskrivelse av økten / tittel',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                      'Beskrivelse beskrivelse\nHer skal du pushe maks og virkelig gi jernet. Start med 3x10 pushups, ta 2 min pause, osv'),
                ],
              ),
            ),
            const SizedBox(height: 40),
            const Text(
              'Øvelser',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            const SizedBox(height: 12),
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
      decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(15))),
      padding: const EdgeInsets.all(20),
      width: MediaQuery.of(context).size.width * 0.9,
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        ExcerciseTile(
          excercise: ex1,
          workoutProgram: true,
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
        const Divider(
          color: Color.fromARGB(255, 190, 190, 190),
          thickness: 3,
        ),
        const SizedBox(
          height: 20,
        ),
        Row(
          children: [
            const Text('Set'),
            SizedBox(width: MediaQuery.of(context).size.width * 0.09),
            const Text('Forrige'),
            SizedBox(width: MediaQuery.of(context).size.width * 0.17),
            const Text('Reps'),
            SizedBox(width: MediaQuery.of(context).size.width * 0.2),
            const Text('kg')
          ],
        ),
        const SizedBox(
          height: 12,
        ),
        const Repetition(),
        const SizedBox(
          height: 20,
        ),
        Center(
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              primary: const Color.fromARGB(255, 51, 100, 140),
            ),
            onPressed: () => const SetList(),
            child: const Text('Ny rep'),
          ),
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
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: const [
        Text('1'),
        SizedBox(
          width: 40,
        ),
        Text('12 x 35kg'),
        SizedBox(
          width: 40,
        ),
        SizedBox(
          height: 50,
          width: 70,
          child: TextField(
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              hintText: 'Reps',
            ),
          ),
        ),
        SizedBox(
          width: 10,
        ),
        Text('X'),
        SizedBox(
          width: 10,
        ),
        SizedBox(
          height: 50,
          width: 70,
          child: TextField(
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              hintText: 'kg',
            ),
          ),
        ),
      ],
    );
  }
}

class SetList extends StatefulWidget {
  const SetList({super.key});

  @override
  State<SetList> createState() => _SetList();
}

class _SetList extends State<SetList> {
  final List<Repetition> repetitions = [];

  @override
  Widget build(BuildContext context) {
    return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [const SizedBox()]);
  }

  void addSet(Excercise excercise) {
    print('Adding excercise: ${excercise.name}');
    setState(() {
      repetitions.add(const Repetition());
    });
  }
}
