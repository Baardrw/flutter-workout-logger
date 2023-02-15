import 'dart:ffi';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:provider/provider.dart';
import 'package:pu_frontend/models/excercise.dart';
import 'package:pu_frontend/services/auth_service.dart';
import 'package:pu_frontend/services/db_service.dart';

import '../widgets/excercise_progression_widgets/cardio_tile.dart';
import '../widgets/excercise_progression_widgets/weight_tile.dart';

class ExcerciseHistory extends StatelessWidget {
  final Excercise excercise;
  ExcerciseHistory({super.key, required this.excercise});

  @override
  Widget build(BuildContext context) {
    final DatabaseService _dbService = Provider.of<DatabaseService>(context);
    final AuthService _authService = Provider.of<AuthService>(context);
    final bool excerciseIsCardio = excercise.type == ExcerciseType.cardio;

    return Scaffold(
        appBar: AppBar(title: Text('${excercise.name} History')),
        body: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Card(
                  elevation: 8,
                  child: FutureBuilder(
                    builder: (context, snapshot) => Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'Personal Best: ${excerciseIsCardio ? snapshot.data?.distance : snapshot.data?.weight}',
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                    ),
                    future: excerciseIsCardio
                        ? _dbService.getCardioPersonalRecord(
                            excercise.name, _authService.uid)
                        : _dbService.getWeightLiftingPersonalRecord(
                            excercise.name, _authService.uid),
                  )),
              SizedBox(height: 10),
              Expanded(
                child: FutureBuilder(
                  builder: (context, snapshot) {
                    return Container(
                        height: 200,
                        child: ListView.builder(
                          itemCount: (snapshot.data as List<Log>).length,
                          shrinkWrap: true,
                          itemBuilder: ((context, index) => excerciseIsCardio
                              ? CardioTile(log: snapshot.data![index])
                              : WeightTile(log: snapshot.data![index])),
                        ));
                  },
                  future: _dbService.getLogs(excercise.name, _authService.uid),
                ),
              )
            ],
          ),
        ));
  }
}
