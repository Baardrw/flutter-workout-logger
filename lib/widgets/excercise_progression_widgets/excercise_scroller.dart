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
      itemBuilder: (BuildContext, int, String) {
        return GestureDetector(
          onTap: () async {
            // Checks if the excercise has logs in the database
            if (!await Provider.of<DatabaseService>(context, listen: false)
                .logExists(excercises[int].name,
                    Provider.of<AuthService>(context, listen: false).uid)) {
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                content: Text('No logs for this excercise'),
                duration: Duration(seconds: 3),
              ));
              return;
            }

            List<Log> logs =
                await Provider.of<DatabaseService>(context, listen: false)
                    .getLogs(excercises[int].name,
                        Provider.of<AuthService>(context, listen: false).uid);

            // if it does, navigate to the excercise history screen
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return ExcerciseHistory(excercise: excercises[int], logs: logs);
            }));
          },
          child: Card(
            elevation: 8,
            child: ExcerciseTile(excercise: excercises[int]),
          ),
        );
      },
      selectedTextStyle: const TextStyle(color: Colors.black),
      unselectedTextStyle: const TextStyle(color: Colors.grey),
    );
  }
}
