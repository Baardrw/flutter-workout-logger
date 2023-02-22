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
  List<Excercise> excercises;
  ExcerciseScroller(this.excercises);

  @override
  Widget build(BuildContext context) {
    return AlphabetScrollView(
      list: excercises.map((e) => AlphaModel(e.name)).toList(),
      itemExtent: 50,
      alignment: LetterAlignment.right,
      itemBuilder: (BuildContext _, int index, String __) {
        return GestureDetector(
          onTap: () async {
            // Checks if the excercise has logs in the database
            if (!await Provider.of<DatabaseService>(context, listen: false)
                .logExists(excercises[index].name,
                    Provider.of<AuthService>(context, listen: false).uid)) {
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                content: Text('No logs for this excercise'),
                duration: Duration(seconds: 3),
              ));
              return;
            }
            // Logs for the chosen excercise are fetched
            List<Log> logs =
                await Provider.of<DatabaseService>(context, listen: false)
                    .getLogs(excercises[index].name,
                        Provider.of<AuthService>(context, listen: false).uid);

            // The user is navigated to the excercise history screen where the logs are displayed
            // ignore: use_build_context_synchronously
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return ExcerciseHistory(excercise: excercises[index], logs: logs);
            }));
          },
          child: Card(
            elevation: 8,
            child: ExcerciseTile(excercise: excercises[index]),
          ),
        );
      },
      selectedTextStyle: const TextStyle(color: Colors.black),
      unselectedTextStyle: const TextStyle(color: Colors.grey),
    );
  }
}
