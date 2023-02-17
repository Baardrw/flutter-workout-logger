import 'dart:ffi';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:provider/provider.dart';
import 'package:pu_frontend/models/excercise.dart';
import 'package:pu_frontend/services/auth_service.dart';
import 'package:pu_frontend/services/db_service.dart';
import 'package:pu_frontend/widgets/excercise_progression_widgets/linechart.dart';
import 'package:pu_frontend/widgets/single_select_toggle_bar.dart';

import '../widgets/excercise_progression_widgets/cardio_tile.dart';
import '../widgets/excercise_progression_widgets/weight_tile.dart';

class ExcerciseHistory extends StatefulWidget {
  final Excercise excercise;
  ExcerciseHistory({super.key, required this.excercise, required this.logs});

  final List<Log> logs;

  @override
  State<ExcerciseHistory> createState() => _ExcerciseHistoryState(logs);
}

class _ExcerciseHistoryState extends State<ExcerciseHistory> {
  _ExcerciseHistoryState(this.logs);

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
  final List<Log> logs;

  @override
  Widget build(BuildContext context) {
    final DatabaseService dbService = Provider.of<DatabaseService>(context);
    final AuthService authService = Provider.of<AuthService>(context);
    final bool excerciseIsCardio =
        widget.excercise.type == ExcerciseType.cardio;

    print('rebuilding');
    return Scaffold(
        appBar: AppBar(title: Text('${widget.excercise.name} History')),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Card holding PB and and sorting options
            Card(
              elevation: 8,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    excerciseIsCardio
                        ? const SizedBox()
                        : Text(
                            'Personal Best: ${_getPersonalBest(logs, excerciseIsCardio)}',
                            style: Theme.of(context).textTheme.headlineSmall,
                          ),
                    // PB
                    const SizedBox(height: 10),
                    // Sorting options
                    SingleSelectButtonBar(
                        excerciseIsCardio
                            ? cardioSortOptions
                            : weightSortOptions,
                        'Sort by:',
                        isSelected,
                        sort),
                    ExcerciseHistoryChart(logs, excerciseIsCardio),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: logs.length,
                itemBuilder: ((context, index) => excerciseIsCardio
                    ? CardioTile(log: logs[index])
                    : WeightTile(log: logs[index])),
              ),
            )
            // List of logs for the excercise
          ],
        ));
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
        logs.sort((a, b) => b.date.compareTo(a.date));
      });
    }

    if (excerciseIsCardio) {
      if (isSelected[1]) {
        setState(() {
          logs.sort((a, b) => b.distance!.compareTo(a.distance!));
        });
      } else if (isSelected[2]) {
        setState(() {
          logs.sort((a, b) {
            final double aAvgSpeed = a.distance! / a.duration!;
            final double bAvgSpeed = b.distance! / b.duration!;
            return bAvgSpeed.compareTo(aAvgSpeed);
          });
        });
      }
    } else {
      if (isSelected[1]) {
        setState(() {
          logs.sort((a, b) => b.weight!.compareTo(a.weight!));
        });
      } else if (isSelected[2]) {
        setState(() {
          logs.sort((a, b) {
            final int aVolume = a.weight! * a.reps!;
            final int bVolume = b.weight! * b.reps!;
            return bVolume.compareTo(aVolume);
          });
        });
      }
    }
  }
}
