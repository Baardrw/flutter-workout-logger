import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pu_frontend/models/program.dart';
import 'package:pu_frontend/models/session.dart';
import 'package:pu_frontend/screens/excercise_progression.dart';
import 'package:pu_frontend/services/auth_service.dart';
import 'package:pu_frontend/services/db_service.dart';

import 'package:pu_frontend/widgets/workout_widgets/popup_card_widget.dart';
import 'package:pu_frontend/widgets/workout_widgets/program/show_workouts_view.dart';
import 'package:pu_frontend/widgets/workout_widgets/workout/workout_screen_button_content.dart';
import 'package:pu_frontend/widgets/workout_widgets/workout/workouts_view_widget.dart';

import '../../../models/excercise.dart';
// import 'workout_program_tile.dart';

class AddProgramButton extends StatelessWidget {
  const AddProgramButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PopupItemLauncher(
      tag: 'test',
      popUp: PopUpItem(
          padding: const EdgeInsets.all(0),
          // paddingOuter: EdgeInsets.all(62), // Padding inside of the card
          color: Color.fromARGB(255, 243, 243, 243), // Color of the card
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(32)), // Shape of the card
          elevation: 2, // Elevation of the card
          tag: 'test', // MUST BE THE SAME AS IN `PopupItemLauncher`
          child: SizedBox(
            height: MediaQuery.of(context).size.height * 0.75,
            width: MediaQuery.of(context).size.width * 0.9,
            child: SizedBox(
                height: MediaQuery.of(context).size.height * 0.75,
                child: const WorkoutProgramList()),
          )),
      child: SizedBox(
        height: 70,
        child: Card(
          margin: EdgeInsets.fromLTRB(30, 0, 30, 0),
          color: Colors.white,
          elevation: 2,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(32)),
          child: const Icon(
            Icons.add_rounded,
            color: Colors.lightBlue,
            size: 45,
          ),
        ),
      ),
    );
  }
}

class WorkoutProgramList extends StatefulWidget {
  const WorkoutProgramList({super.key});

  @override
  State<WorkoutProgramList> createState() => _WorkoutProgramListState();
}

class _WorkoutProgramListState extends State<WorkoutProgramList> {
  // final List<WorkoutCard> sessions = [];
  final TextEditingController _programNameController = TextEditingController();
  final TextEditingController _programDescriptionController =
      TextEditingController();
  List<List<WorkoutCard>> programDays = [];
  List<WorkoutCard> programMonday = [];
  List<WorkoutCard> programTuesday = [];
  List<WorkoutCard> programWednesday = [];
  List<WorkoutCard> programThursday = [];
  List<WorkoutCard> programFriday = [];
  List<WorkoutCard> programSaturday = [];
  List<WorkoutCard> programMSunday = [];

  @override
  Widget build(BuildContext context) {
    return ListView(padding: EdgeInsets.all(20), children: [
      SizedBox(height: 15),
      Center(
        child: Text(
          'New Program',
          style: Theme.of(context).textTheme.displayLarge,
        ),
      ),
      const SizedBox(
        height: 20,
      ),
      TextField(
        decoration: const InputDecoration(
          border: OutlineInputBorder(),
          labelText: 'Program Name',
        ),
        controller: _programNameController,
      ),
      SizedBox(height: 12),
      TextField(
        decoration: const InputDecoration(
          border: OutlineInputBorder(),
          labelText: 'Program Description',
        ),
        controller: _programDescriptionController,
      ),
      const SizedBox(
        height: 20,
      ),
      SizedBox(height: 10),
      Text(
        'Monday',
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      Divider(
        color: Colors.blueGrey,
      ),
      SizedBox(
        height: 200,
        child: ListView(
          scrollDirection: Axis.horizontal,
          children: [
            ...programMonday,
            Padding(
              padding: const EdgeInsets.all(30.0),
              child: Card(
                margin: EdgeInsets.fromLTRB(0, 20, 0, 20),
                elevation: 2,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(32)),
                child: Container(
                  width: 100,
                  child: IconButton(
                    iconSize: 35,
                    // Pushes the user to the add session screen where they can pick a session
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => AddWorkoutsView(
                                  gestureDetectorOnTap: addSessionMon)));
                    },
                    icon: const Icon(
                      Icons.add,
                      color: Colors.lightBlue,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      SizedBox(height: 40),
      Text(
        'Tuesday',
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      Divider(
        color: Colors.blueGrey,
      ),
      SizedBox(
        height: 200,
        child: ListView(
          scrollDirection: Axis.horizontal,
          children: [
            ...programTuesday,
            Padding(
              padding: const EdgeInsets.all(30.0),
              child: Card(
                margin: EdgeInsets.fromLTRB(0, 20, 0, 20),
                elevation: 2,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(32)),
                child: SizedBox(
                  width: 100,
                  child: IconButton(
                    iconSize: 35,
                    // Pushes the user to the add session screen where they can pick a session
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => AddWorkoutsView(
                                  gestureDetectorOnTap: addSessionTue)));
                    },
                    icon: const Icon(
                      Icons.add,
                      color: Colors.lightBlue,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      SizedBox(height: 40),
      Text(
        'Wednesday',
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      Divider(
        color: Colors.blueGrey,
      ),
      SizedBox(
        height: 200,
        child: ListView(
          scrollDirection: Axis.horizontal,
          children: [
            ...programWednesday,
            Padding(
              padding: const EdgeInsets.all(30.0),
              child: Card(
                margin: EdgeInsets.fromLTRB(0, 20, 0, 20),
                elevation: 2,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(32)),
                child: Container(
                  width: 100,
                  child: IconButton(
                    iconSize: 35,
                    // Pushes the user to the add session screen where they can pick a session
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => AddWorkoutsView(
                                  gestureDetectorOnTap: addSessionWed)));
                    },
                    icon: const Icon(
                      Icons.add,
                      color: Colors.lightBlue,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      SizedBox(height: 40),
      Text(
        'Thursday',
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      Divider(
        color: Colors.blueGrey,
      ),
      SizedBox(
        height: 200,
        child: ListView(
          scrollDirection: Axis.horizontal,
          children: [
            ...programThursday,
            Padding(
              padding: const EdgeInsets.all(30.0),
              child: Card(
                margin: EdgeInsets.fromLTRB(0, 20, 0, 20),
                elevation: 2,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(32)),
                child: Container(
                  width: 100,
                  child: IconButton(
                    iconSize: 35,
                    // Pushes the user to the add session screen where they can pick a session
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => AddWorkoutsView(
                                  gestureDetectorOnTap: addSessionThu)));
                    },
                    icon: const Icon(
                      Icons.add,
                      color: Colors.lightBlue,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      SizedBox(height: 40),
      Text(
        'Friday',
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      Divider(
        color: Colors.blueGrey,
      ),
      SizedBox(
        height: 200,
        child: ListView(
          scrollDirection: Axis.horizontal,
          children: [
            ...programFriday,
            Padding(
              padding: const EdgeInsets.all(30.0),
              child: Card(
                margin: EdgeInsets.fromLTRB(0, 20, 0, 20),
                elevation: 2,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(32)),
                child: Container(
                  width: 100,
                  child: IconButton(
                    iconSize: 35,
                    // Pushes the user to the add session screen where they can pick a session
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => AddWorkoutsView(
                                  gestureDetectorOnTap: addSessionFri)));
                    },
                    icon: const Icon(
                      Icons.add,
                      color: Colors.lightBlue,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      SizedBox(height: 40),
      Text(
        'Saturday',
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      Divider(
        color: Colors.blueGrey,
      ),
      SizedBox(
        height: 200,
        child: ListView(
          scrollDirection: Axis.horizontal,
          children: [
            ...programSaturday,
            Padding(
              padding: const EdgeInsets.all(30.0),
              child: Card(
                margin: EdgeInsets.fromLTRB(0, 20, 0, 20),
                elevation: 2,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(32)),
                child: Container(
                  width: 100,
                  child: IconButton(
                    iconSize: 35,
                    // Pushes the user to the add session screen where they can pick a session
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => AddWorkoutsView(
                                  gestureDetectorOnTap: addSessionSat)));
                    },
                    icon: const Icon(
                      Icons.add,
                      color: Colors.lightBlue,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      SizedBox(height: 40),
      Text(
        'Sunday',
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      Divider(
        color: Colors.blueGrey,
      ),
      SizedBox(
        height: 200,
        child: ListView(
          scrollDirection: Axis.horizontal,
          children: [
            ...programMSunday,
            Padding(
              padding: const EdgeInsets.all(30.0),
              child: Card(
                margin: EdgeInsets.fromLTRB(0, 20, 0, 20),
                elevation: 2,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24)),
                child: Container(
                  width: 100,
                  child: IconButton(
                    iconSize: 35,
                    // Pushes the user to the add session screen where they can pick a session
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => AddWorkoutsView(
                                    gestureDetectorOnTap: addSessionSun,
                                  )));
                    },
                    icon: const Icon(
                      Icons.add,
                      color: Colors.lightBlue,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      SizedBox(height: 40),
      IconButton(
          onPressed: () async {
            _handleProgramFinished();
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.done_outline_rounded,
            color: Colors.green,
          ),
          iconSize: 40),
    ]);
  }

  void _handleProgramFinished() async {
    List<String> programMon = programMonday.map((e) => e.session.id).toList();
    List<String> programTue = programTuesday.map((e) => e.session.id).toList();
    List<String> programWed =
        programWednesday.map((e) => e.session.id).toList();
    List<String> programThu = programThursday.map((e) => e.session.id).toList();
    List<String> programFri = programFriday.map((e) => e.session.id).toList();
    List<String> programSat = programSaturday.map((e) => e.session.id).toList();
    List<String> programSun = programMSunday.map((e) => e.session.id).toList();

    Map<String, List<String>>? sessionDays = {
      'monday': programMon,
      'tuesday': programTue,
      'wednesday': programWed,
      'thursday': programThu,
      'friday': programFri,
      'saturday': programSat,
      'sunday': programSun
    };

    String programName = _programNameController.text;
    String programDescription = _programDescriptionController.text;

    if (programName.isEmpty) {
      programName = "New Program";
    }
    if (programDescription.isEmpty) {
      programDescription = "No Description";
    }

    Program push = Program(
      name: programName,
      description: programDescription,
      date: DateTime.now(),
      days: sessionDays,
    );
    // monday: programMon,
    // tuesday: programTue,
    // wednesday: programWed,
    // thursday: programThu,
    // friday: programFri,
    // saturday: programSat,
    // sunday: programSun);

    await Provider.of<DatabaseService>(context, listen: false)
        .addProgram(push, Provider.of<AuthService>(context, listen: false).uid);
  }

  void addSessionMon(Session session) {
    if (programMonday
        .map(
          (e) => e.session.id,
        )
        .contains(session.id)) {
      return;
    }
    setState(() {
      programMonday.add(WorkoutCard(session));
    });
  }

  void addSessionTue(Session session) {
    if (programTuesday
        .map(
          (e) => e.session.id,
        )
        .contains(session.id)) {
      return;
    }
    setState(() {
      programTuesday.add(WorkoutCard(session));
    });
  }

  void addSessionWed(Session session) {
    if (programWednesday
        .map(
          (e) => e.session.id,
        )
        .contains(session.id)) {
      return;
    }
    setState(() {
      programWednesday.add(WorkoutCard(session));
    });
  }

  void addSessionThu(Session session) {
    if (programThursday
        .map(
          (e) => e.session.id,
        )
        .contains(session.id)) {
      return;
    }
    setState(() {
      programThursday.add(WorkoutCard(session));
    });
  }

  void addSessionFri(Session session) {
    if (programFriday
        .map(
          (e) => e.session.id,
        )
        .contains(session.id)) {
      return;
    }
    setState(() {
      programFriday.add(WorkoutCard(session));
    });
  }

  void addSessionSat(Session session) {
    if (programSaturday
        .map(
          (e) => e.session.id,
        )
        .contains(session.id)) {
      return;
    }
    setState(() {
      programSaturday.add(WorkoutCard(session));
    });
  }

  void addSessionSun(Session session) {
    if (programMSunday
        .map(
          (e) => e.session.id,
        )
        .contains(session.id)) {
      return;
    }
    setState(() {
      programMSunday.add(WorkoutCard(session));
    });
  }
}
