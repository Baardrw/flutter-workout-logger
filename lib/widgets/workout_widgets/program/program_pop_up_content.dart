import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:pu_frontend/models/session.dart';
import 'package:pu_frontend/models/program.dart';

import 'package:pu_frontend/widgets/workout_widgets/popup_card_widget.dart';
import 'package:pu_frontend/widgets/workout_widgets/program/program_screen_button_content.dart';
import 'package:pu_frontend/widgets/workout_widgets/workout/workout_pop_up.dart';
import 'package:pu_frontend/widgets/workout_widgets/workout/workout_screen_button_content.dart';

import '../../../common/appstate.dart';
import '../../../services/db_service.dart';

class ShowProgramButton extends StatelessWidget {
  final ProgramCard card;
  final String string;
  final String uid;

  const ShowProgramButton({
    required this.card,
    required this.string,
    required this.uid,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PopupItemLauncher(
      tag: string,
      outerPadding: EdgeInsets.all(0),
      child: card,
      popUp: PopUpItem(
          // paddingOuter: EdgeInsets.all(0), // Padding outside of the card
          padding: EdgeInsets.all(8), // Padding inside of the card
          color: Color.fromARGB(255, 232, 232, 232), // Color of the card
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(32)), // Shape of the card
          elevation: 2, // Elevation of the card
          tag: string, // MUST BE THE SAME AS IN `PopupItemLauncher`
          child:
              ProgramContent(card.program, uid)), // Your custom child widget.
    );
  }
}

class ProgramContent extends StatelessWidget {
  final Program program;
  final String uid;

  const ProgramContent(
    this.program,
    this.uid, {
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    DatabaseService dbInstanceForSessions = DatabaseService();
    return Container(
      height: MediaQuery.of(context).size.height * 0.75,
      width: MediaQuery.of(context).size.width * 0.9,
      child: FutureBuilder(
          builder: ((context, snapshot) {
            // print('Snap 1: $snapshot');
            if (!snapshot.hasData) {
              return const Center(child: CircularProgressIndicator());
            }
            // print('Snap 2: $snapshot');

            Map<String, List<Session?>> sessionDays =
                snapshot.data as Map<String, List<Session>>;

            List<Widget> mondayCards = sessionDays['monday']!
                .where((element) => element != null)
                .map((e) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: GestureDetector(
                        child: WorkoutCard(e!),
                        onTap: () {},
                      ),
                    ))
                .toList();
            List<Widget> tuesdayCards = sessionDays['tuesday']!
                .where((element) => element != null)
                .map((e) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: WorkoutCard(e!),
                    ))
                .toList();
            List<Widget> wednesdayCards = sessionDays['wednesday']!
                .where((element) => element != null)
                .map((e) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: WorkoutCard(e!),
                    ))
                .toList();

            List<Widget> thursdayCards = sessionDays['thursday']!
                .where((element) => element != null)
                .map((e) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: WorkoutCard(e!),
                    ))
                .toList();
            List<Widget> fridayCards = sessionDays['friday']!
                .where((element) => element != null)
                .map((e) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: WorkoutCard(e!),
                    ))
                .toList();
            List<Widget> saturdayCards = sessionDays['saturday']!
                .where((element) => element != null)
                .map((e) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: WorkoutCard(e!),
                    ))
                .toList();

            List<Widget> sundayCards = sessionDays['sunday']!
                .where((element) => element != null)
                .map((e) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: WorkoutCard(e!),
                    ))
                .toList();

            return ListView(
                padding: const EdgeInsets.all(24.0),
                children: <Widget>[
                  SizedBox(height: 20),
                  Text(
                    program.name,
                    style: Theme.of(context).textTheme.displayLarge,
                  ),
                  SizedBox(height: 15),
                  Text('Description:'),
                  Text(program.description),
                  SizedBox(height: 30),
                  Text(
                    'Monday',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Divider(
                    color: Colors.blueGrey,
                  ),
                  if (mondayCards.isNotEmpty)
                    (Container(
                      height: 200,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        children: mondayCards,
                      ),
                    ))
                  else
                    (Text('No workout')),
                  SizedBox(height: 40),
                  Text(
                    'Tuesday',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Divider(
                    color: Colors.blueGrey,
                  ),
                  if (tuesdayCards.isNotEmpty)
                    (Container(
                      height: 200,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        children: tuesdayCards,
                      ),
                    ))
                  else
                    (Text('No workout')),
                  SizedBox(height: 40),
                  Text(
                    'Wednesday',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Divider(
                    color: Colors.blueGrey,
                  ),
                  if (wednesdayCards.isNotEmpty)
                    (Container(
                      height: 200,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        children: wednesdayCards,
                      ),
                    ))
                  else
                    (Text('No workout')),
                  SizedBox(height: 40),
                  Text(
                    'Thursday',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Divider(
                    color: Colors.blueGrey,
                  ),
                  if (thursdayCards.isNotEmpty)
                    (Container(
                      height: 200,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        children: thursdayCards,
                      ),
                    ))
                  else
                    (Text('No workout')),
                  SizedBox(height: 40),
                  Text(
                    'Friday',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Divider(
                    color: Colors.blueGrey,
                  ),
                  if (fridayCards.isNotEmpty)
                    (Container(
                      height: 200,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        children: fridayCards,
                      ),
                    ))
                  else
                    (Text('No workout')),
                  SizedBox(height: 40),
                  Text(
                    'Saturday',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Divider(
                    color: Colors.blueGrey,
                  ),
                  if (saturdayCards.isNotEmpty)
                    (Container(
                      height: 200,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        children: saturdayCards,
                      ),
                    ))
                  else
                    (Text('No workout')),
                  SizedBox(height: 40),
                  Text(
                    'Sunday',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Divider(
                    color: Colors.blueGrey,
                  ),
                  if (sundayCards.isNotEmpty)
                    GestureDetector(
                      child: (Container(
                        height: 200,
                        child: ListView(
                          scrollDirection: Axis.horizontal,
                          children: sundayCards,
                        ),
                      )),
                    )
                  else
                    (Text('No workout')),
                  SizedBox(height: 40),
                ]);
          }),
          future: program.getSessionObjects(uid)),
    );
  }
}
