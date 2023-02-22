import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:pu_frontend/models/excercise.dart';

class WorkoutProgramTile extends StatelessWidget {
  const WorkoutProgramTile({super.key, required this.excercise});
  final Excercise excercise;

  final AssetImage _strengthIcon =
      const AssetImage('assets/icons8-workout-64.png');

  final AssetImage _cardioIcon = const AssetImage(
      'assets/icons8-jogging-for-cardio-exercise-to-enhance-stamina-48.png');

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(excercise.name),
      subtitle: Text(excercise.type.toString()),
      leading: FittedBox(
        fit: BoxFit.fill,
        child: Container(
          width: 60,
          height: 70,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: excercise.type == ExcerciseType.strength
                  ? _strengthIcon
                  : _cardioIcon,
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
    );
  }
}
