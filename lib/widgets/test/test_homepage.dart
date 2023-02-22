import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:pu_frontend/models/excercise.dart';
import 'package:pu_frontend/services/auth_service.dart';
import 'package:pu_frontend/services/db_service.dart';

class TestHome extends StatefulWidget {
  const TestHome({super.key});

  @override
  State<TestHome> createState() => _TestHomeState();
}

class _TestHomeState extends State<TestHome> {
  @override
  Widget build(BuildContext context) {
    final AuthService _authService = Provider.of<AuthService>(context);
    final DatabaseService _dbService = DatabaseService();
    Excercise excercise = Excercise(
        bodyPart: BodyPart.abs, name: 'test4', type: ExcerciseType.cardio);

    return Container(
      padding: const EdgeInsets.all(80.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          ElevatedButton(
              onPressed: () async {
                Log log = Log(
                    Random.secure().nextInt(100),
                    Random.secure().nextInt(20),
                    DateTime.now(),
                    'Bench Press',
                    Random.secure().nextInt(10000),
                    Random.secure().nextInt(180));

                await _dbService.addLog(log, _authService.uid);
              },
              child: Text('Add bench log')),
          ElevatedButton(
            onPressed: () {
              _authService.signOut();
            },
            child: Text('logout'),
          ),
        ],
      ),
    );
  }
}
