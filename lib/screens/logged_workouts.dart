import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../widgets/workout_widgets/workout_card_widget.dart';
import '../widgets/workout_widgets/workouts_view_widget.dart';
import '../widgets/workout_widgets/program_card_widget.dart';
import '../widgets/workout_widgets/programs_view_widget.dart';
import '../widgets/excercise_progression_widgets/excercise_tile.dart';
import '../models/excercise.dart';
import '../main.dart';

class Logged_workout extends StatelessWidget {
  const Logged_workout({super.key});

  @override
  Widget build(BuildContext context) {
    Excercise ex1 = new Excercise(
        type: ExcerciseType.strength,
        bodyPart: BodyPart.chest,
        name: 'Pushups');
    Repetition rep1 = Repetition();
    Repetition rep2 = Repetition();
    Repetition rep3 = Repetition();
    List<Repetition> repetitions = [rep1, rep2, rep3];
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 225, 225, 225),
      appBar: AppBar(backgroundColor: const Color.fromARGB(255, 51, 100, 140)),
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
                      'Beskrivelse beskrivelse\nHer skal du pushe maks og virkelig gi jernet. Start med 3x10 pushups, ta 2 min pause, osv'),
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
        ExcerciseTile(excercise: ex1),
        const Divider(
          color: Color.fromARGB(255, 190, 190, 190),
          thickness: 3,
        ),
        SizedBox(
          height: 10,
        ),
        const Text(
          'Beskrivelse beskrivelse\nhvordan hvordan',
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
          children: [
            Text('Set'),
            SizedBox(width: MediaQuery.of(context).size.width * 0.09),
            Text('Forrige'),
            SizedBox(width: MediaQuery.of(context).size.width * 0.17),
            Text('Reps'),
            SizedBox(width: MediaQuery.of(context).size.width * 0.2),
            Text('kg')
          ],
        ),
        SizedBox(
          height: 12,
        ),
        Repetition(),
        SizedBox(
          height: 20,
        ),
        Center(
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              primary: Color.fromARGB(255, 51, 100, 140),
            ),
            onPressed: () => SetList(),
            child: Text('Ny rep'),
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
      repetitions.add(Repetition());
    });
  }
}
