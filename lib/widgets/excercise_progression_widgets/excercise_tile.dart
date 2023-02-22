import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/excercise.dart';
import '../../services/db_service.dart';

/// Tile that displays the name and body part of an excercise
/// used in the add_workout_button to display the excercises that
/// are added
class ExcerciseTile extends StatelessWidget {
  const ExcerciseTile({
    Key? key,
    required this.excercise,
    required this.workoutProgram,
  }) : super(key: key);

  final bool workoutProgram;

  final Excercise excercise;
  final AssetImage _strengthIcon =
      const AssetImage('assets/icons8-workout-64.png');

  final AssetImage _cardioIcon = const AssetImage(
      'assets/icons8-jogging-for-cardio-exercise-to-enhance-stamina-48.png');

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        FittedBox(
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
        const SizedBox(width: 20),
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              excercise.name,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            Text(excercise.bodyPart.toShortString(),
                style: Theme.of(context).textTheme.labelLarge),
          ],
        ),
        Expanded(
          child: Container(),
        ),
        workoutProgram
            ? const SizedBox()
            : IconButton(
                onPressed: () {
                  Provider.of<DatabaseService>(context, listen: false)
                      .deleteExcercise(excercise);
                },
                icon: const Icon(
                  Icons.delete,
                  color: Colors.blueGrey,
                )),
        const SizedBox(width: 10),
      ],
    );
  }
}
