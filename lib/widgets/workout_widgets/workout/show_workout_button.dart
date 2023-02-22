import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:pu_frontend/widgets/workout_widgets/popup_card_widget.dart';
import 'package:pu_frontend/widgets/workout_widgets/workout/workout_card_widget.dart';

class ShowWorkoutButton extends StatelessWidget {
  final WorkoutCard test;
  final String string;

  const ShowWorkoutButton({
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
        color: Colors.white, // Color of the card
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(32)), // Shape of the card
        elevation: 2, // Elevation of the card
        tag: string, // MUST BE THE SAME AS IN `PopupItemLauncher`
        child: WorkoutContent(),
      ), // Your custom child widget.
    );
  }
}

class WorkoutContent extends StatelessWidget {
  const WorkoutContent({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 350,
      height: 500,
      child: ListView(
        padding: const EdgeInsets.all(24.0),
        children: <Widget>[
          SizedBox(height: 10),
          Text('Tittel'),
          Divider(
            color: Colors.blueGrey,
          ),
          SizedBox(height: 30),
          Text('Beskrivelse osv osv osv'),
          SizedBox(height: 300),
          Text('Knapp for å opprette en ny instans/økt'),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              primary: Color.fromARGB(255, 51, 100, 140),
            ),
            onPressed: () => context.push('/logWorkout'),
            child: Text('Registrer ny økt'),
          ),
          SizedBox(height: 30),
          Divider(
            color: Colors.blueGrey,
            thickness: 5,
          ),
          SizedBox(height: 30),
          Text('Her kommer tidligere gjennomførte økter'),
          SizedBox(height: 30),
          Text('23.01.2023'),
          SizedBox(height: 30),
          Text('12.12.2022')
        ],
      ),
    );
  }
}
