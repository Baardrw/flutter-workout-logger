import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:pu_frontend/common/appstate.dart';
import 'package:pu_frontend/models/session.dart';
import 'package:pu_frontend/widgets/homepage/friends_workout_card.dart';

import 'package:pu_frontend/widgets/workout_widgets/popup_card_widget.dart';
import 'package:pu_frontend/widgets/workout_widgets/workout/workout_screen_button_content.dart';

import '../../../models/excercise.dart';
import '../../../screens/excercise_history.dart';
import '../../../services/auth_service.dart';
import '../../../services/db_service.dart';
import '../../screens/log_workout.dart';

class ShowWorkoutButtonFriend extends StatelessWidget {
  final FriendsWorkoutCard card;
  final String string;

  const ShowWorkoutButtonFriend({
    required this.card,
    required this.string,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PopupItemLauncher(
      tag: string,
      outerPadding: const EdgeInsets.all(0),
      popUp: PopUpItem(
        // paddingOuter: EdgeInsets.all(0), // Padding outside of the card
        padding: const EdgeInsets.all(8), // Padding inside of the card
        color: const Color.fromARGB(255, 232, 232, 232), // Color of the card
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(32)), // Shape of the card
        elevation: 2, // Elevation of the card
        tag: string, // MUST BE THE SAME AS IN `PopupItemLauncher`
        child: WorkoutContent(
          card.session,
          card.sessionInstance,
        ),
      ),
      child: card, // Your custom child widget.
    );
  }
}

class WorkoutContent extends StatelessWidget {
  const WorkoutContent(this.session, this.sessionInstance, {super.key});
  final Session session;
  final SessionInstance sessionInstance;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.8,
      width: MediaQuery.of(context).size.width * 0.8,
      child: Center(
          child: ListView(padding: const EdgeInsets.all(12), children: [
        GetSessionInfo(
            sessionInstance: sessionInstance, url: sessionInstance.picture),
        const SizedBox(height: 20),
        const Text(
          'Exercises',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        const SizedBox(height: 12),
        GetSessionList(sessionInstance: sessionInstance, completed: true),
        const SizedBox(height: 15),
      ])),
    );
  }
}
