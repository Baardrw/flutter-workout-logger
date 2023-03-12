import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:provider/provider.dart';
import 'package:pu_frontend/services/db_service.dart';
import 'package:pu_frontend/widgets/single_select_toggle_bar.dart';

import '../models/excercise.dart';
import '../services/auth_service.dart';
import 'excercise_progression_widgets/linechart.dart';

/// Very bad code, all ive done is copy some old code, but Lazyness for the win
class ProgressCard extends StatefulWidget {
  const ProgressCard(this.excercise, this.logs, {super.key});

  final Excercise excercise;
  final List<Log> logs;

  @override
  State<ProgressCard> createState() => _ProgressCardState();
}

class _ProgressCardState extends State<ProgressCard> {
  final List<Text> weightSortOptions = [
    const Text('Date'),
    const Text('Weight'),
    const Text('volume')
  ];

  final List<Text> cardioSortOptions = [
    const Text('Date'),
    const Text('Distance'),
    const Text('AvgSpeed')
  ];

  final List<bool> isSelected = [true, false, false];

  @override
  Widget build(BuildContext context) {
    final bool excerciseIsCardio =
        widget.excercise.type == ExcerciseType.cardio;

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        elevation: 8,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(widget.excercise.name,
                  style: Theme.of(context).textTheme.headlineSmall),
              excerciseIsCardio
                  ? const SizedBox()
                  : Text(
                      'Personal Best: ${_getPersonalBest(widget.logs, excerciseIsCardio)}',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
              // PB
              const SizedBox(height: 10),
              // Sorting options
              SingleSelectButtonBar(
                  excerciseIsCardio ? cardioSortOptions : weightSortOptions,
                  'Sort by:',
                  isSelected,
                  sort),
              ExcerciseHistoryChart(widget.logs, excerciseIsCardio),
            ],
          ),
        ),
      ),
    );
  }

  int? _getPersonalBest(List<Log> logs, bool excerciseIsCardio) {
    return logs
        .reduce((curr, next) => curr.weight! > next.weight! ? curr : next)
        .weight;
  }

  void sort() {
    final bool excerciseIsCardio =
        widget.excercise.type == ExcerciseType.cardio;

    if (isSelected[0]) {
      setState(() {
        widget.logs.sort((a, b) => b.date.compareTo(a.date));
      });
    }

    if (excerciseIsCardio) {
      if (isSelected[1]) {
        setState(() {
          widget.logs.sort((a, b) => b.distance!.compareTo(a.distance!));
        });
      } else if (isSelected[2]) {
        setState(() {
          widget.logs.sort((a, b) {
            final double aAvgSpeed = a.distance! / a.duration!;
            final double bAvgSpeed = b.distance! / b.duration!;
            return bAvgSpeed.compareTo(aAvgSpeed);
          });
        });
      }
    } else {
      if (isSelected[1]) {
        setState(() {
          widget.logs.sort((a, b) => b.weight!.compareTo(a.weight!));
        });
      } else if (isSelected[2]) {
        setState(() {
          widget.logs.sort((a, b) {
            final int aVolume = a.weight! * a.reps!;
            final int bVolume = b.weight! * b.reps!;
            return bVolume.compareTo(aVolume);
          });
        });
      }
    }
  }
}
