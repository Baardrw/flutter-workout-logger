import 'package:alphabet_scroll_view/alphabet_scroll_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../../models/excercise.dart';
import '../../screens/excercise_history.dart';
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
          onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    ExcerciseHistory(excercise: excercises[int]),
              )),
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
