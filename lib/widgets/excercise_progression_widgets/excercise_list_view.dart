import 'dart:ffi';

import 'package:alphabet_scroll_view/alphabet_scroll_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:pu_frontend/services/auth_service.dart';

import '../../models/excercise.dart';
import '../../screens/excercise_history.dart';
import '../../services/db_service.dart';
import 'excercise_tile.dart';

class ExcerciseScroller extends StatelessWidget {
  ExcerciseScroller(this.excercises, {super.key, this.gestureDetectorOnTap});
  Function(Excercise)? gestureDetectorOnTap;
  final List<Excercise> excercises;

  @override
  Widget build(BuildContext context) {
    return AlphabetScrollView(
      list: excercises.map((e) => AlphaModel(e.name)).toList(),
      itemExtent: 50,
      alignment: LetterAlignment.right,
      itemBuilder: (BuildContext _, int index, String __) {
        return GestureDetector(
          onTap: () async {
            // If a gestureDetectorOnTap function is provided, it is called instead of the default function
            // This signals that excercise scroller is used somewhere with another function
            // For example to pick an excercise for a workout program
            if (gestureDetectorOnTap != null) {
              gestureDetectorOnTap!(excercises[index]);
              Navigator.of(context).pop();
              return;
            }
            await _showExcerciseHistory(context, excercises, index);
          },
          child: Card(
            elevation: 8,
            child: ExcerciseTile(
              excercise: excercises[index],
              workoutProgram: gestureDetectorOnTap != null,
            ),
          ),
        );
      },
      selectedTextStyle: const TextStyle(color: Colors.black),
      unselectedTextStyle: const TextStyle(color: Colors.grey),
    );
  }

  Future<void> _showExcerciseHistory(
      BuildContext context, List<Excercise> excercises, int index) async {
    // Checks if the excercise has logs in the database
    if (!await Provider.of<DatabaseService>(context, listen: false).logExists(
        excercises[index].name,
        Provider.of<AuthService>(context, listen: false).uid)) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('No logs for this excercise'),
        duration: Duration(seconds: 3),
      ));
      return;
    }
    // Logs for the chosen excercise are fetched
    List<Log> logs = await Provider.of<DatabaseService>(context, listen: false)
        .getLogs(excercises[index].name,
            Provider.of<AuthService>(context, listen: false).uid);

    // The user is navigated to the excercise history screen where the logs are displayed
    // ignore: use_build_context_synchronously
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return ExcerciseHistory(excercise: excercises[index], logs: logs);
    }));
  }
}
