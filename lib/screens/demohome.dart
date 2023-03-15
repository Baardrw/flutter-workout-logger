import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pu_frontend/widgets/test/test_homepage.dart';
import '../models/group.dart';
import '../common/bottom_bar.dart';

class DemoHome extends StatelessWidget {
  const DemoHome({super.key});

  @override
  Widget build(BuildContext context) {
    BottomBar bottomBar = BottomBar(0);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        backgroundColor: const Color.fromARGB(255, 51, 100, 140),
        actions: [
          IconButton(
            onPressed:  () => showDialog(context: context, builder: (BuildContext context) {
              return CreateGroup();
            }), 
            icon: const Icon(Icons.group_add))
        ],
      ),
      body: const Center(
        child: TestHome(),
        // child: TestHome(),
      ),
      bottomNavigationBar: bottomBar.getBar(context),
    );
  }
}

class CreateGroup extends StatefulWidget {
  const CreateGroup({super.key});

  @override
  _CreateGroupState createState() => _CreateGroupState();
}

class _CreateGroupState extends State<CreateGroup> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _membersController = TextEditingController();
  final TextEditingController _goalController = TextEditingController();
  
  Future<void> _createGroup() async {
    final groupName = _nameController.text;
    final groupMembers = _membersController.text.split('');
    final groupGoal = _goalController.text;

    try{
      final groupRef = FirebaseFirestore.instance.collection('groups');
      final group = Group(groupName, groupMembers, groupGoal);
      await groupRef.doc(groupName).set(group.toMap());
      print('Group created: $group');
      Navigator.pop(context);
    } catch(e) {
      print('Error creating group: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Create a new group'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Group name',
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _goalController,
              decoration: const InputDecoration(
                labelText: 'Group goal',
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context), 
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _createGroup, 
          child: const Text('Create'),
        ),
      ],
    );
  }
}

