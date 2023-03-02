import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:pu_frontend/services/db_service.dart';

import '../services/auth_service.dart';
import '../widgets/workout_widgets/workout/workout_card_widget.dart';
import '../widgets/workout_widgets/workout/workouts_view_widget.dart';
import '../widgets/workout_widgets/program/program_screen_button_content.dart';
import '../widgets/workout_widgets/program/program_screen.dart';
import '../widgets/excercise_progression_widgets/excercise_tile.dart';
import '../models/excercise.dart';
import '../models/session.dart';
import '../main.dart';

class Repetition extends StatelessWidget {
  final Excercise excercise;
  final int set;
  final int forrigeRep;
  final int forrigeWeight;

  final TextEditingController repsController = TextEditingController();
  final TextEditingController weightController = TextEditingController();

  Repetition({
    super.key,
    required this.excercise,
    required this.set,
    required this.forrigeRep,
    required this.forrigeWeight,
  });

  @override
  Widget build(BuildContext context) {
    String last = "${forrigeRep.toString()} x ${forrigeWeight.toString()}kg";
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(set.toString()),
          SizedBox(
            width: 37,
          ),
          Text(last),
          SizedBox(
            width: 35,
          ),
          SizedBox(
            height: 44,
            width: 65,
            child: TextField(
              controller: repsController,
              keyboardType: TextInputType.number,
              style: TextStyle(fontSize: 15.0, height: 2.0),
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Reps',
              ),
            ),
          ),
          SizedBox(
            width: 8,
          ),
          Text('X'),
          SizedBox(
            width: 8,
          ),
          SizedBox(
            height: 44,
            width: 65,
            child: TextField(
              controller: weightController,
              keyboardType: TextInputType.number,
              style: TextStyle(fontSize: 15.0, height: 2.0),
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'kg',
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class StatelessRepetition extends StatelessWidget {
  StatelessRepetition({
    super.key,
    required this.reps,
    required this.weight,
    required this.set,
  });

  final int reps;
  final int weight;
  final int set;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(set.toString()),
          SizedBox(
            width: 45,
          ),
          SizedBox(
            width: 45,
          ),
          Text(reps.toString()),
          SizedBox(
            width: 4,
          ),
          Text('X'),
          SizedBox(
            width: 4,
          ),
          Text(weight.toString()),
        ],
      ),
    );
  }
}

class SetList extends StatefulWidget {
  const SetList({
    super.key,
    required this.sessionID,
  });

  final String? sessionID;

  @override
  State<SetList> createState() => _SetList(sessionID: sessionID);
}

class _SetList extends State<SetList> {
  final List<Repetition> repetitions = [];

  _SetList({
    required this.sessionID,
  });

  final String? sessionID;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color.fromARGB(255, 225, 225, 225),
        appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 51, 100, 140),
          title: Text('Loggfør økt'),
        ),
        body: Center(
            child: ListView(padding: EdgeInsets.all(12), children: [
          getSessionInfo(sessionID: sessionID),
          SizedBox(height: 20),
          Text(
            'Øvelser',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
          SizedBox(height: 12),
          // LogCard(sessionID: sessionID),
          getSessionList(sessionID: sessionID),
          SizedBox(height: 15),
        ])));
  }
}

void saveRep(
    Excercise excercise, Repetition repetition, BuildContext context) async {
  String repsString = repetition.repsController.text;
  String weightString = repetition.weightController.text;

  if (repsString.isEmpty) {
    repsString = '0';
  }
  if (weightString.isEmpty) {
    weightString = '0';
  }

  int reps = int.parse(repsString);
  int weight = int.parse(weightString);

  Log push = Log(weight, reps, DateTime.now(), excercise.name, 0, 0);

  await Provider.of<DatabaseService>(context, listen: false)
      .addLog(push, Provider.of<AuthService>(context, listen: false).uid);
}

class getSessionInfo extends StatelessWidget {
  final String? sessionID;

  const getSessionInfo({
    super.key,
    required this.sessionID,
  });

  @override
  Widget build(BuildContext context) {
    DatabaseService db = Provider.of<DatabaseService>(context);
    AuthService authService = Provider.of<AuthService>(context, listen: false);

    String ID = '';
    Session session = Session(
        name: 'Default',
        date: DateTime.now(),
        description: 'Default',
        timeEstimate: 'Default');

    return Container(
      child: StreamBuilder(
          builder: (context, snapshot) {
            return FutureBuilder(
                builder: (context, snapshot) {
                  List<Session>? sessions = snapshot.data;
                  for (var i = 0; i < sessions!.length; i++) {
                    if (sessions[i].id == sessionID) {
                      ID = sessions[i].id;
                      session = sessions[i];
                      print(ID);
                      return Container(
                        padding: EdgeInsets.all(20),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius:
                                BorderRadius.all(Radius.circular(15))),
                        child: Column(
                          children: [
                            Text(
                              session.name,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 25,
                              ),
                            ),
                            SizedBox(height: 12),
                            Text(session.timeEstimate),
                            SizedBox(height: 12),
                            Text(session.description),
                          ],
                        ),
                      );
                    }
                  }
                  return Container(
                    child: Text('Container'),
                  );
                },
                future: db.getSessions(authService.uid));
          },
          stream: db.getSessionStream(authService.uid)),
    );
  }
}

class getSessionList extends StatelessWidget {
  final String? sessionID;

  const getSessionList({
    super.key,
    required this.sessionID,
  });

  @override
  Widget build(BuildContext context) {
    DatabaseService db = Provider.of<DatabaseService>(context);
    AuthService authService = Provider.of<AuthService>(context, listen: false);

    String ID = '';
    Session session = Session(
        name: 'Default',
        date: DateTime.now(),
        description: 'Default',
        timeEstimate: 'Default');

    return Container(
      child: StreamBuilder(
          builder: (context, snapshot) {
            return FutureBuilder(
                builder: (context, snapshot) {
                  List<Session>? sessions = snapshot.data;
                  for (var i = 0; i < sessions!.length; i++) {
                    if (sessions[i].id == sessionID) {
                      ID = sessions[i].id;
                      session = sessions[i];
                      print(ID);
                      return FutureBuilder(
                          builder: ((context, snapshot) {
                            if (!snapshot.hasData) {
                              return const Center(
                                  child: CircularProgressIndicator());
                            }

                            List<Excercise?> excercises =
                                snapshot.data as List<Excercise?>;
                            List<Widget> logCards = excercises
                                .where((element) => element != null)
                                .map((e) => Container(
                                      child: LogCard(excercise: e!),
                                    ))
                                .toList();
                            print(logCards);

                            return Column(
                              children: logCards,
                            );
                          }),
                          future: session.getExcercisesAsExcercise());
                    }
                  }
                  return Container(
                    child: Text('Container'),
                  );
                },
                future: db.getSessions(authService.uid));
          },
          stream: db.getSessionStream(authService.uid)),
    );
  }
}

class LogCard extends StatefulWidget {
  final Excercise excercise;

  const LogCard({
    super.key,
    required this.excercise,
  });

  @override
  State<LogCard> createState() => _LogCardState(excercise: excercise);
}

class _LogCardState extends State<LogCard> {
  _LogCardState({
    required this.excercise,
  });

  final List<StatelessRepetition> repetitions = [];
  final Excercise excercise;
  int set = 1;
  int lastRep = 0;
  int lastWeight = 0;

  @override
  Widget build(BuildContext context) {
    final Repetition repetition = Repetition(
      excercise: excercise,
      set: set,
      forrigeRep: lastRep,
      forrigeWeight: lastWeight,
    );
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(15))),
          padding: EdgeInsets.all(20),
          width: MediaQuery.of(context).size.width * 0.9,
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(
              excercise.name,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            const Divider(
              color: Color.fromARGB(255, 190, 190, 190),
              thickness: 3,
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              excercise.description,
            ),
            SizedBox(
              height: 10,
            ),
            const Divider(
              color: Color.fromARGB(255, 190, 190, 190),
              thickness: 3,
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              children: [
                Text('Set'),
                SizedBox(width: MediaQuery.of(context).size.width * 0.09),
                Text('Forrige'),
                SizedBox(width: MediaQuery.of(context).size.width * 0.155),
                Text('Reps'),
                SizedBox(width: MediaQuery.of(context).size.width * 0.165),
                Text('kg')
              ],
            ),
            SizedBox(
              height: 12,
            ),
            Column(
              children: [...repetitions, repetition],
            ),
            SizedBox(
              height: 20,
            ),
            Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: Color.fromARGB(255, 51, 100, 140),
                ),
                onPressed: () {
                  addSet(repetition);
                  saveRep(excercise, repetition, context);
                },
                child: Text('Lagre'),
              ),
            ),
          ]),
        ),
        SizedBox(
          height: 20,
        ),
      ],
    );
  }

  void addSet(repetition) {
    String repsString = repetition.repsController.text;
    String weightString = repetition.weightController.text;

    if (repsString.isEmpty) {
      repsString = '0';
    }
    if (weightString.isEmpty) {
      weightString = '0';
    }

    int reps = int.parse(repsString);
    int weight = int.parse(weightString);
    setState(() {
      repetitions
          .add(StatelessRepetition(reps: reps, weight: weight, set: set));
      set++;
      lastRep = reps;
      lastWeight = weight;
    });
  }
}
