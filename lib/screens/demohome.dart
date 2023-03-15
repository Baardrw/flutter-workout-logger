import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pu_frontend/services/auth_service.dart';
import 'package:pu_frontend/services/db_service.dart';
import 'package:pu_frontend/widgets/test/test_homepage.dart';
import '../models/group.dart';
import 'package:pu_frontend/models/user.dart';
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
  final TextEditingController _administrators= TextEditingController();
  
  Future<void> _createGroup() async {
    final groupName = _nameController.text;
    final groupMembers = _membersController.text.split('');
    final groupGoal = _goalController.text;
    final administrators = _administrators.text.split('');

    final DatabaseService _db = Provider.of<DatabaseService>(context, listen: false);
    final AuthService auth = Provider.of<AuthService>(context, listen: false);
    String uid = auth.uid;
    administrators.add(uid);
    groupMembers.add(uid);

    final group = Group(groupName, groupGoal, groupMembers, administrators);
    await _db.addGroup(group);
    
    User? user = await _db.getUser(uid);
    user!.joinGroup(group, true);
    
    await _db.updateUser(user);



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




