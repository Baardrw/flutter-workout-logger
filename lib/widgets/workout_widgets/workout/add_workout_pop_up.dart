import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pu_frontend/models/session.dart';
import 'package:pu_frontend/screens/excercise_progression.dart';
import 'package:pu_frontend/services/auth_service.dart';
import 'package:pu_frontend/services/db_service.dart';

import 'package:pu_frontend/widgets/workout_widgets/popup_card_widget.dart';

import '../../../models/excercise.dart';
import 'workout_program_tile.dart';

class AddWorkoudButton extends StatelessWidget {
  const AddWorkoudButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PopupItemLauncher(
      tag: 'test',
      popUp: PopUpItem(
          padding: const EdgeInsets.all(0),
          // paddingOuter: EdgeInsets.all(62), // Padding inside of the card
          color: Colors.white, // Color of the card
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(32)), // Shape of the card
          elevation: 2, // Elevation of the card
          tag: 'test', // MUST BE THE SAME AS IN `PopupItemLauncher`
          child: SizedBox(
            height: MediaQuery.of(context).size.height * 0.9,
            width: MediaQuery.of(context).size.width * 0.9,
            child: SizedBox(
                height: MediaQuery.of(context).size.height * 0.9,
                child: const WorkoutProgramList()),
          )),
      child: Material(
        color: Colors.white,
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(32)),
        child: const Icon(
          Icons.add_rounded,
          size: 45,
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
  final List<WorkoutProgramTile> excercises = [];
  final TextEditingController _programNameController = TextEditingController();
  final TextEditingController _programDescriptionController =
      TextEditingController();
  final TextEditingController _timeEstimateController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(mainAxisAlignment: MainAxisAlignment.start, children: [
      const SizedBox(
        height: 20,
      ),
      // Input fields for program name, description and time estimate
      Text(
        'New Program',
        style: Theme.of(context).textTheme.displayLarge,
      ),
      const SizedBox(
        height: 20,
      ),
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
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(32)),
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
    ]);
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
