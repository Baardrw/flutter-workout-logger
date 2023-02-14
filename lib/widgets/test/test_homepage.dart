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
              onPressed: () {
                _authService.signOut();
              },
              child: const Text('Sign Out')),
          FutureBuilder(
              builder: (context, snapshot) {
                return Text("Future: ${snapshot.data}");
              },
              future: _dbService.users),
          ElevatedButton(
              onPressed: () {
                setState(() {
                  _dbService.addExcercise(excercise);
                });
              },
              child: const Text('Add Excercise')),
          FutureBuilder(
              builder: (context, snapshot) {
                return Text("Future: ${snapshot.data?.length}");
              },
              future: _dbService.excercises),
        ],
      ),
    );
  }
}
