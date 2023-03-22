import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pu_frontend/common/appstate.dart';
import 'package:pu_frontend/services/db_service.dart';

import '../services/auth_service.dart';
import '../models/excercise.dart';
import '../models/session.dart';

class LogWorkoutScreen extends StatelessWidget {
  LogWorkoutScreen({
    super.key,
    required this.sessionID,
    required this.sessionInstance,
  });

  final String? sessionID;
  SessionInstance? sessionInstance;
  bool oldSession = true;

  @override
  Widget build(BuildContext context) {
    // Cant access siessionId over, so must be done here

    if (sessionInstance == null) {
      oldSession = false;

      sessionInstance = SessionInstance(
        sessionId: sessionID!,
        excercises: [],
        sessionInstanceId: DateTime.now(),
        completedBy: Provider.of<AuthService>(context, listen: false).uid,
      );
    }

    Provider.of<AppState>(context, listen: false).isOldSession = oldSession;

    return Scaffold(
        backgroundColor: const Color.fromARGB(255, 225, 225, 225),
        appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 51, 100, 140),
          title: const Text('Loggfør økt'),
          actions: [
            IconButton(
              icon: const Icon(Icons.check),
              onPressed: () {
                // Sets the apps state to inform the app that this session is no longer in progress
                Provider.of<AppState>(context, listen: false).sessionInstance =
                    null;

                sessionInstance!.completed = true;
                Provider.of<DatabaseService>(context, listen: false)
                    .updateSessionInstance(
                  sessionInstance!,
                  Provider.of<AuthService>(context, listen: false).uid,
                );

                // Go back to the previous page
                Navigator.pop(context);
              },
            )
          ],
        ),
        body: Center(
            child: ListView(padding: const EdgeInsets.all(12), children: [
          GetSessionInfo(sessionInstance: sessionInstance!),
          const SizedBox(height: 20),
          const Text(
            'Øvelser',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
          const SizedBox(height: 12),
          GetSessionList(sessionInstance: sessionInstance!),
          const SizedBox(height: 15),
        ])));
  }
}

/// Session information card displayed on the top of the listveiw
class GetSessionInfo extends StatelessWidget {
  final SessionInstance sessionInstance;

  const GetSessionInfo({
    super.key,
    required this.sessionInstance,
  });

  @override
  Widget build(BuildContext context) {
    DatabaseService db = Provider.of<DatabaseService>(context, listen: false);
    AuthService authService = Provider.of<AuthService>(context, listen: false);

    String ID = '';
    Session session = Session(
        name: 'Default',
        date: DateTime.now(),
        description: 'Default',
        timeEstimate: 'Default');

    return Container(
      child: FutureBuilder(
          builder: (context, snapshot) {
            while (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            session = snapshot.data as Session;
            ID = session.id;
            return Container(
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(15))),
              child: Column(
                children: [
                  Text(
                    session.name,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 25,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(session.timeEstimate),
                  const SizedBox(height: 12),
                  Text(session.description),
                ],
              ),
            );
          },
          future: db.getSession(sessionInstance.sessionId,
              Provider.of<AuthService>(context, listen: false).uid)),
    );
  }
}

/// List of exercises in the session
class GetSessionList extends StatelessWidget {
  final SessionInstance sessionInstance;

  const GetSessionList({
    super.key,
    required this.sessionInstance,
  });

  @override
  Widget build(BuildContext context) {
    DatabaseService db = Provider.of<DatabaseService>(context, listen: false);
    AuthService authService = Provider.of<AuthService>(context, listen: false);

    return Container(
      // Gets the excercises in the session, adds them to sessionInstance and updates the database
      // also displays the excercises in the session

      child: FutureBuilder(
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          Session session = snapshot.data as Session;

          // If this isnt a new session set the requirements for an old session
          if (!Provider.of<AppState>(context, listen: false).isOldSession) {
            // Add the excercises included in the session to the session instance
            sessionInstance.excercises = session.excercises;

            // Add session to database
            Provider.of<DatabaseService>(context, listen: false)
                .addSessionInstance(
              sessionInstance,
              Provider.of<AuthService>(context, listen: false).uid,
            );

            // Sets the apps state to inform the app that this session is in progress
            Provider.of<AppState>(context, listen: false).sessionInstance =
                sessionInstance;
          }

          return FutureBuilder(
              builder: ((context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }

                List<Excercise?> excercises = snapshot.data as List<Excercise?>;

                List<Widget> logCards = excercises
                    .where((element) => element != null)
                    .map((e) => Container(
                          child: LogCard(
                            excercise: e!,
                            sessionInstance: sessionInstance,
                          ),
                        ))
                    .toList();
                return Column(
                  children: logCards,
                );
              }),
              future: session.getExcerciseObjects());
        },
        future: db.getSession(sessionInstance.sessionId,
            Provider.of<AuthService>(context, listen: false).uid),
      ),
    );
  }
}

class LogCard extends StatefulWidget {
  final Excercise excercise;
  final SessionInstance sessionInstance;

  const LogCard({
    super.key,
    required this.excercise,
    required this.sessionInstance,
  });

  @override
  State<LogCard> createState() =>
      _LogCardState(excercise: excercise, sessionInstance: sessionInstance);
}

class _LogCardState extends State<LogCard> {
  _LogCardState({
    required this.excercise,
    required this.sessionInstance,
  });

  final List<Repetition> repetitions = [];
  final Excercise excercise;
  final SessionInstance sessionInstance;
  int set = 1;
  int lastRep = 0;
  int lastWeight = 0;

  @override
  Widget build(BuildContext context) {
    // If repetition is empty we add one into the list
    Repetition repetition = Repetition(
      excercise: excercise,
      set: set,
      lastRep: lastRep,
      lastWeight: lastWeight,
      logId: '0',
      delete: deleteRep,
      save: saveRep,
      remove: removeRep,
    );

    sessionInstance.reps ??= [];
    sessionInstance.reps!
        .where((element) => element.excercise.name == excercise.name)
        .where((element) => !repetitions.contains(element))
        .map((e) {
      e.isDone = true;
      return e;
    }).forEach((element) => repetitions.add(element));

    return Column(
      children: [
        Container(
          decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(15))),
          padding: const EdgeInsets.all(20),
          width: MediaQuery.of(context).size.width * 0.9,
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(
              excercise.name,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            const Divider(
              color: Color.fromARGB(255, 190, 190, 190),
              thickness: 3,
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              excercise.description.isEmpty
                  ? 'Ingen beskrivelse'
                  : excercise.description,
            ),
            const SizedBox(
              height: 10,
            ),
            const Divider(
              color: Color.fromARGB(255, 190, 190, 190),
              thickness: 3,
            ),
            const SizedBox(
              height: 20,
            ),
            Column(
              children: [...repetitions, repetition],
            ),
            const SizedBox(
              height: 20,
            ),
            Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: const Color.fromARGB(255, 51, 100, 140),
                ),
                onPressed: () {
                  addSet(repetition);
                },
                child: const Text('Legg til Sett'),
              ),
            ),
          ]),
        ),
        const SizedBox(
          height: 20,
        ),
      ],
    );
  }

  bool addSet(repetition) {
    String repsString = repetition.repsController.text;
    String weightString = repetition.weightController.text;

    if (!repetition.isDone) {
      SnackBar snackBar = const SnackBar(
        content: Text('Du må fullføre forrige sett'),
        duration: Duration(seconds: 5),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      return false;
    }

    int reps = int.parse(repsString);
    int weight = int.parse(weightString);

    setState(() {
      set++;
      lastRep = reps;
      lastWeight = weight;
    });

    return true;
  }

  /// Saves the repetition to the database, the return value indicates if the save was successful
  /// and legal
  Future<bool> saveRep(Repetition repetition) async {
    String repsString = repetition.repsController.text;
    String weightString = repetition.weightController.text;

    if (repsString.isEmpty) {
      return false;
    }
    if (weightString.isEmpty) {
      return false;
    }

    int reps = int.parse(repsString);
    int weight = int.parse(weightString);

    Log push;

    if (repetition.excercise.type == ExcerciseType.strength) {
      push = Log(weight, reps, DateTime.now(), excercise.name, 0, 0,
          sessionInstance.id);
    } else {
      push = Log(0, 0, DateTime.now(), excercise.name, reps, weight,
          sessionInstance.id);
    }

    // NOTE: These reps are not pushed to the db, they are only stored in the session instance
    repetition.logId = push.id;
    Repetition repcopy = Repetition.clone(repetition, sessionInstance.id);

    repcopy.repsController.text = repsString;
    repcopy.weightController.text = weightString;

    sessionInstance.reps ??= [];
    sessionInstance.reps!.add(repcopy);

    // Updates the session instance in the globally available state object
    Provider.of<AppState>(context, listen: false).sessionInstance =
        sessionInstance;

    await Provider.of<DatabaseService>(context, listen: false)
        .addLog(push, Provider.of<AuthService>(context, listen: false).uid);
    return true;
  }

  void deleteRep(Repetition repetition) async {
    print('Deleting repetition');

    DatabaseService db = DatabaseService();

    await db.deleteLog(repetition.logId, repetition.excercise.name,
        Provider.of<AuthService>(context, listen: false).uid);
  }

  void removeRep(Repetition repetition) {
    sessionInstance.reps ??= [];
    if (sessionInstance.reps!.isEmpty) {
      return;
    }

    setState(() {
      sessionInstance.reps!.remove(repetition);
      repetitions.remove(repetition);
    });
  }
}

class Repetition extends StatefulWidget {
  final Excercise excercise;
  final int set;
  final int lastRep;
  final int lastWeight;
  final TextEditingController repsController = TextEditingController();
  final TextEditingController weightController = TextEditingController();
  final Function(Repetition) delete;
  final Function(Repetition) save;
  final Function(Repetition) remove;

  /// 0 if there is no log
  String logId;
  bool isDone;

  Repetition({
    super.key,
    required this.excercise,
    required this.set,
    required this.lastRep,
    required this.lastWeight,
    required this.logId,
    required this.delete,
    required this.save,
    required this.remove,
    this.isDone = false,
  });

  Repetition.clone(Repetition rep, String id)
      : this(
          excercise: rep.excercise,
          set: rep.set,
          lastRep: rep.lastRep,
          lastWeight: rep.lastWeight,
          logId: id,
          delete: rep.delete,
          save: rep.save,
          remove: rep.remove,
          isDone: true,
        );

  @override
  State<Repetition> createState() => _RepetitionState(isDone);
}

class _RepetitionState extends State<Repetition> {
  _RepetitionState(this.isDone);

  bool isDone;

  @override
  Widget build(BuildContext context) {
    String last = widget.excercise.type == ExcerciseType.strength
        ? "${widget.lastRep.toString()} x ${widget.lastWeight.toString()}kg"
        : "${widget.lastRep.toString()}km in ${widget.lastWeight.toString()} min";

    Color? button_colour = isDone ? Colors.green[900] : Colors.grey;

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(widget.set.toString()),
          const Spacer(flex: 25),
          Text(last),
          const Spacer(flex: 35),
          SizedBox(
            height: 44,
            width: 65,
            child: TextField(
              controller: widget.repsController,
              keyboardType: TextInputType.number,
              style: const TextStyle(fontSize: 15.0, height: 2.0),
              enabled: !isDone,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: widget.excercise.type == ExcerciseType.strength
                    ? 'Reps'
                    : 'Distance',
              ),
            ),
          ),
          const Spacer(flex: 5),
          const Text('X'),
          const Spacer(flex: 5),
          SizedBox(
            height: 44,
            width: 65,
            child: TextField(
              controller: widget.weightController,
              keyboardType: TextInputType.number,
              style: const TextStyle(fontSize: 15.0, height: 2.0),
              enabled: !isDone,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: widget.excercise.type == ExcerciseType.strength
                    ? 'kg'
                    : 'Time',
              ),
            ),
          ),
          const Spacer(flex: 15),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10.5),
            child: IconButton(
                onPressed: () async {
                  setState(() {
                    if (widget.repsController.text.isEmpty ||
                        widget.weightController.text.isEmpty && !isDone) {
                      SnackBar snackBar = const SnackBar(
                        content: Text('Du må fylle inn både vekt og reps'),
                        duration: Duration(seconds: 5),
                      );
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      return;
                    }

                    isDone = !isDone;
                    widget.isDone = isDone;
                  });
                  if (isDone) {
                    await widget.save(widget);
                  } else {
                    await widget.delete(widget);
                  }
                },
                icon: Icon(
                  Icons.check_box,
                  color: button_colour,
                  size: 44,
                )),
          ),
        ],
      ),
    );
  }
}
