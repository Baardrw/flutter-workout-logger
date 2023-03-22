import 'package:flutter/material.dart';
import 'package:pu_frontend/common/bottom_bar.dart';

import '../widgets/workout_widgets/workout/workout_screen_button_content.dart';
import '../widgets/workout_widgets/workout/workouts_view_widget.dart';
import '../widgets/workout_widgets/program/program_screen_button_content.dart';
import '../widgets/workout_widgets/program/program_screen.dart';

class Workouts extends StatelessWidget {
  const Workouts({super.key});

  @override
  Widget build(BuildContext context) {
    BottomBar bottomBar = BottomBar(2);

    return Scaffold(
      body: DefaultTabController(
          length: 2,
          child: Scaffold(
            appBar: AppBar(
                bottom: const TabBar(
                  indicator: UnderlineTabIndicator(),
                  tabs: [
                    Tab(icon: Icon(Icons.calendar_today)),
                    Tab(icon: Icon(Icons.directions_run_rounded)),
                  ],
                ),
                title: const Text('Trening'),
                backgroundColor: const Color.fromARGB(255, 51, 100, 140)),
            body: const TabBarView(
              children: [
                ProgramsView(),
                WorkoutsView(),
              ],
            ),
          )),
      bottomNavigationBar: bottomBar.getBar(context),
    );
  }
}
