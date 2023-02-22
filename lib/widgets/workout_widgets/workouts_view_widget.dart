import 'package:flutter/material.dart';

import 'package:pu_frontend/widgets/workout_widgets/workout_card_widget.dart';
import 'package:pu_frontend/widgets/workout_widgets/add_workout_button.dart';
import 'package:pu_frontend/widgets/workout_widgets/show_workout_button.dart';

class WorkoutsView extends StatelessWidget {
  const WorkoutsView({super.key});

  @override
  Widget build(BuildContext context) {
    const WorkoutCard test = WorkoutCard();
    const String ID1 = '1';
    const String ID2 = '2';
    const String ID3 = '3';
    const String ID4 = '4';
    const String ID5 = '5';
    return Scaffold(
        backgroundColor: Color.fromARGB(255, 225, 225, 225),
        body: GridView(
          padding: const EdgeInsets.all(15.0),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, crossAxisSpacing: 12.0, mainAxisSpacing: 12.0),
          children: const [
            ShowWorkoutButton(test: test, string: ID1),
            ShowWorkoutButton(test: test, string: ID2),
            ShowWorkoutButton(test: test, string: ID3),
            ShowWorkoutButton(test: test, string: ID4),
            ShowWorkoutButton(test: test, string: ID5),
            AddWorkoudButton(),
          ],
        )
        // body: GridView.builder(
        //   itemCount: 5,
        //   padding: EdgeInsets.all(15),
        //   gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        //       crossAxisCount: 2, crossAxisSpacing: 12.0, mainAxisSpacing: 12.0),
        //   itemBuilder: (context, index) {
        //     return ExerciseCard();
        //   },
        // )
        );
  }
}
