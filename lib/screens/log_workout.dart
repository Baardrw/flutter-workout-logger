import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../widgets/workout_widgets/workout_card_widget.dart';
import '../widgets/workout_widgets/workouts_view_widget.dart';
import '../widgets/workout_widgets/program_card_widget.dart';
import '../widgets/workout_widgets/programs_view_widget.dart';
import '../main.dart';

class Log_workout extends StatelessWidget {
  const Log_workout({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: const Color.fromARGB(255, 51, 100, 140)),
      body: Center(
        child: GestureDetector(
          onTap: () => context.push('/workouts'),
          child: Container(
            height: 200,
            width: 200,
            child: Text('Her registrerer man økten'),
          ),
        ),
      ),
    );
  }
}
