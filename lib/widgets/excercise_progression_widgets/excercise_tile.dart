import 'package:flutter/material.dart';

import '../../models/excercise.dart';

class ExcerciseTile extends StatelessWidget {
  const ExcerciseTile({
    Key? key,
    required this.excercise,
  }) : super(key: key);

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
        )
      ],
    );
  }
}
