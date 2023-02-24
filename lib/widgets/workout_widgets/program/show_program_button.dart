import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pu_frontend/models/session.dart';

import 'package:pu_frontend/widgets/workout_widgets/program/popup_card_widget.dart';
import 'package:pu_frontend/widgets/workout_widgets/program/program_card_widget.dart';
import 'package:pu_frontend/widgets/workout_widgets/workout/show_workout_button.dart';
import 'package:pu_frontend/widgets/workout_widgets/workout/workout_card_widget.dart';

class ShowProgramButton extends StatelessWidget {
  final ProgramCard test;
  final String string;

  const ShowProgramButton({
    required this.test,
    required this.string,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PopupItemLauncher(
      tag: string,
      outerPadding: EdgeInsets.all(0),
      child: test,
      popUp: PopUpItem(
          // paddingOuter: EdgeInsets.all(0), // Padding outside of the card
          padding: EdgeInsets.all(8), // Padding inside of the card
          color: Color.fromARGB(255, 232, 232, 232), // Color of the card
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(32)), // Shape of the card
          elevation: 2, // Elevation of the card
          tag: string, // MUST BE THE SAME AS IN `PopupItemLauncher`
          child: ProgramContent()), // Your custom child widget.
    );
  }
}

class ProgramContent extends StatelessWidget {
  const ProgramContent({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Session test = Session(
        date: DateTime.now(),
        description: 'test',
        name: 'Test',
        timeEstimate: '60',
        excercises: ["Bench Press", "'Pushups"]);

    WorkoutCard workout1 = WorkoutCard(test);
    const String ID20 = 'ID20';
    return Container(
      width: 350,
      height: 600,
      child: ListView(
        padding: const EdgeInsets.all(24.0),
        children: <Widget>[
          SizedBox(height: 10),
          Text('Mandag'),
          Divider(
            color: Colors.blueGrey,
          ),
          // ShowWorkoutButton(test: workout1, string: ID20),
          GestureDetector(
            onTap: () => context.pushNamed('/logNew'),
            child: WorkoutCard(test),
          ),
          SizedBox(height: 40),
          Text('Tirsdag'),
          Divider(
            color: Colors.blueGrey,
          ),
          SizedBox(height: 40),
          Text('Onsdag'),
          Divider(
            color: Colors.blueGrey,
          ),
          workout1,
          SizedBox(height: 40),
          Text('Torsdag'),
          Divider(
            color: Colors.blueGrey,
          ),
          workout1,
          SizedBox(height: 40),
          Text('Fredag'),
          Divider(
            color: Colors.blueGrey,
          ),
          SizedBox(height: 40),
          Text('Lørdag'),
          Divider(
            color: Colors.blueGrey,
          ),
          SizedBox(height: 40),
          Text('Søndag'),
          Divider(
            color: Colors.blueGrey,
          ),
          SizedBox(height: 40),
        ],
      ),
    );
  }
}

// class ShowProgramContent extends StatefulWidget {
//   const ShowProgramContent({super.key});
// 
//   @override
//   State<ShowProgramContent> createState() => _ShowProgramContentState();
// }
// 
// class _ShowProgramContentState {
//   @override
//   Widget build(BuildContext context) {
//     const WorkoutCard workout1 = WorkoutCard();
//     const String ID20 = 'ID20';
//     return GestureDetector(
//       child: Container(
//         width: 350,
//         height: 600,
//         child: ListView(
//           padding: const EdgeInsets.all(24.0),
//           children: const <Widget>[
//             SizedBox(height: 10),
//             Text('Mandag'),
//             Divider(
//               color: Colors.blueGrey,
//             ),
//             // ShowWorkoutButton(test: workout1, string: ID20),
//             workout1,
//             SizedBox(height: 40),
//             Text('Tirsdag'),
//             Divider(
//               color: Colors.blueGrey,
//             ),
//             SizedBox(height: 40),
//             Text('Onsdag'),
//             Divider(
//               color: Colors.blueGrey,
//             ),
//             workout1,
//             SizedBox(height: 40),
//             Text('Torsdag'),
//             Divider(
//               color: Colors.blueGrey,
//             ),
//             workout1,
//             SizedBox(height: 40),
//             Text('Fredag'),
//             Divider(
//               color: Colors.blueGrey,
//             ),
//             SizedBox(height: 40),
//             Text('Lørdag'),
//             Divider(
//               color: Colors.blueGrey,
//             ),
//             SizedBox(height: 40),
//             Text('Søndag'),
//             Divider(
//               color: Colors.blueGrey,
//             ),
//             SizedBox(height: 40),
//           ],
//         ),
//       ),
//       onTap: () {},
//     );
//   }
// }
