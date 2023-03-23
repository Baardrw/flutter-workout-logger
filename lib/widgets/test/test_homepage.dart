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
import 'package:go_router/go_router.dart';

import '../../models/user.dart';

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
        bodyPart: BodyPart.abs,
        name: 'test4',
        type: ExcerciseType.cardio,
        description: 'beskrivelse');

    return Container(
      padding: const EdgeInsets.all(80.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          ElevatedButton(
              onPressed: () async {
                User user = User("12345", "test", "bårds test user");
                await _dbService.addUser(user);
                User? myUser = await _dbService.getUser(_authService.uid);
                myUser?.addFreindRequest("12345");
                await _dbService.updateUser(myUser!);
              },
              child: Text('Add bench log')),
          ElevatedButton(
            onPressed: () async {
              await _authService.signOut();
              context.go("/");
            },
            child: Text('logout'),
          ),
        ],
      ),
    );
  }
}
