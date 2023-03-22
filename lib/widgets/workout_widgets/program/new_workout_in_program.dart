import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pu_frontend/models/session.dart';
import 'package:pu_frontend/screens/excercise_progression.dart';
import 'package:pu_frontend/services/auth_service.dart';
import 'package:pu_frontend/services/db_service.dart';

import 'package:pu_frontend/widgets/workout_widgets/popup_card_widget.dart';

import '../../../models/excercise.dart';
import '../workout/workout_program_tile.dart';

class AddWorkoutButton extends StatelessWidget {
  const AddWorkoutButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.fromLTRB(34, 34, 34, 34),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(32)),
      child: Container(
        child: IconButton(
          iconSize: 35,
          // Pushes the user to the add session screen where they can pick a session
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => NewProgramWorkoutList()));
          },
          icon: const Icon(
            Icons.add,
            color: Colors.lightBlue,
          ),
        ),
      ),
    );
  }
}

class NewProgramWorkoutList extends StatefulWidget {
  const NewProgramWorkoutList({super.key});

  @override
  State<NewProgramWorkoutList> createState() => _NewProgramWorkoutList();
}

class _NewProgramWorkoutList extends State<NewProgramWorkoutList> {
  final List<WorkoutProgramTile> excercises = [];
  final TextEditingController _programNameController = TextEditingController();
  final TextEditingController _programDescriptionController =
      TextEditingController();
  final TextEditingController _timeEstimateController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('New Session')),
      backgroundColor: Color.fromARGB(255, 249, 249, 249),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Program Name',
              ),
              controller: _programNameController,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Program Description',
              ),
              controller: _programDescriptionController,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Time Estimate',
              ),
              keyboardType: TextInputType.number,
              controller: _timeEstimateController,
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Card(
            elevation: 2,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(32)),
            child: IconButton(
              // pushes the user to the excercise progression screen where they can pick an excercise
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ExcerciseProgression(
                              tile: "Pick an Excercise, or Add One",
                              gestureDetectorOnTap: addExcercise,
                            )));
              },
              icon: const Icon(
                Icons.add,
                color: Colors.lightBlue,
              ),
            ),
          ),
          Expanded(
              child: ListView(
            padding: EdgeInsets.zero,
            physics: const BouncingScrollPhysics(
                parent: AlwaysScrollableScrollPhysics()),
            shrinkWrap: true,
            // Excercises are dynamically added to the list using the gestureDetectorOnTap callback
            children: [...excercises],
          )),
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
          const SizedBox(
            height: 50,
          ),
        ]),
      ),
    );
  }

  void _handleProgramFinished() async {
    List<String> program_excercises =
        excercises.map((e) => e.excercise.name).toList();

    String programName = _programNameController.text;
    String programDescription = _programDescriptionController.text;
    String timeEstimate = _timeEstimateController.text;

    if (programName.isEmpty) {
      programName = "New Program";
    }
    if (programDescription.isEmpty) {
      programDescription = "No Description";
    }
    if (timeEstimate.isEmpty) {
      timeEstimate = '60';
    }

    Session push = Session(
        name: programName,
        date: DateTime.now(),
        description: programDescription,
        timeEstimate: timeEstimate,
        excercises: program_excercises);

    await Provider.of<DatabaseService>(context, listen: false)
        .addSession(push, Provider.of<AuthService>(context, listen: false).uid);
  }

  void addExcercise(Excercise excercise) {
    print('Adding excercise: ${excercise.name}');
    if (excercises
        .map(
          (e) => e.excercise.name,
        )
        .contains(excercise.name)) {
      return;
    }
    setState(() {
      excercises.add(WorkoutProgramTile(excercise: excercise));
    });
    print('Excercises: ${excercises.length}');
  }
}
