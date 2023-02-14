import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:pu_frontend/models/excercise.dart';

class ExcerciseHistory extends StatelessWidget {
  final Excercise excercise;
  const ExcerciseHistory({super.key, required this.excercise});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('${excercise.name} History')),
        body: Container(
            // TODO : Implement database logging of excercise history
            ));
  }
}
