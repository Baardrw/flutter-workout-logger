import 'package:flutter/material.dart';

import '../widgets/workout_widgets/workout/workout_card_widget.dart';
import '../widgets/workout_widgets/workout/workouts_view_widget.dart';
import '../widgets/workout_widgets/program_card_widget.dart';
import '../widgets/workout_widgets/programs_view_widget.dart';

class Workouts extends StatelessWidget {
  const Workouts({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
              bottom: const TabBar(
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
              // Icon(Icons.construction),
              WorkoutsView(),
            ],
          ),
          // bottomNavigationBar: BottomNavigationBar(
          //   items: const <BottomNavigationBarItem>[
          //     BottomNavigationBarItem(
          //       icon: Icon(Icons.fitness_center),
          //       label: 'Trening',
          //     ),
          //     BottomNavigationBarItem(
          //       icon: Icon(Icons.home),
          //       label: 'Hjem',
          //     ),
          //     BottomNavigationBarItem(
          //       icon: Icon(Icons.account_circle_outlined),
          //       label: 'Profil',
          //     )
          //   ],
          //   selectedItemColor: const Color.fromARGB(255, 51, 100, 140),
          // ),
        ));
  }
}
