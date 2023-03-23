import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:path/path.dart';
import 'package:provider/provider.dart';
import 'package:pu_frontend/services/auth_service.dart';
import 'package:pu_frontend/services/db_service.dart';
import 'package:pu_frontend/services/storage_service.dart';
import 'package:pu_frontend/widgets/app_bar.dart';
import 'package:pu_frontend/widgets/progress_card.dart';
import 'package:pu_frontend/widgets/user_admin_widget.dart';

import '../common/bottom_bar.dart';
import '../models/excercise.dart';
import '../models/user.dart';

class Admin extends StatefulWidget {
  Admin({Key? key}) : super(key: key);

  @override
  State<Admin> createState() => _Admin();
}

class _Admin extends State<Admin> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool isCheckedAdmin = false;
  bool isCheckedAdvertiser = false;

  @override
  Widget build(BuildContext context) {
    DatabaseService db = Provider.of<DatabaseService>(context);
    final AuthService _authService = Provider.of<AuthService>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Page'),
        backgroundColor: const Color.fromARGB(255, 51, 100, 140),
        actions: [
          Padding(
              padding: EdgeInsets.only(right: 20.0),
              child: GestureDetector(
                onTap: () async {
                  await _authService.signOut();
                  // ignore: use_build_context_synchronously
                  context.go("/");
                },
                child: Icon(
                  Icons.logout,
                  size: 26.0,
                ),
              )),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Center(
            child: Column(
          children: [
            Center(
              child: Text(
                'Add new user',
                style: Theme.of(context).textTheme.displayLarge,
              ),
            ),
            SizedBox(
              height: 20,
            ),
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                enabledBorder: const OutlineInputBorder(
                  borderSide: BorderSide(),
                ),
                focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey)),
                hintText: 'Name',
              ),
            ),
            SizedBox(height: 15),
            TextField(
              controller: _emailController,
              decoration: InputDecoration(
                enabledBorder: const OutlineInputBorder(
                  borderSide: BorderSide(),
                ),
                focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey)),
                hintText: 'Email',
              ),
            ),
            SizedBox(height: 15),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(
                enabledBorder: const OutlineInputBorder(
                  borderSide: BorderSide(),
                ),
                focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey)),
                hintText: 'Password',
              ),
            ),
            SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Row(
                  children: [
                    Transform.scale(
                      scale: 1.3,
                      child: Checkbox(
                        checkColor: Colors.white,
                        value: isCheckedAdmin,
                        onChanged: (bool? value) {
                          setState(() {
                            isCheckedAdmin = value!;
                            isCheckedAdvertiser = false;
                          });
                        },
                      ),
                    ),
                    Text('Admin'),
                  ],
                ),
                Row(
                  children: [
                    Transform.scale(
                      scale: 1.3,
                      child: Checkbox(
                        checkColor: Colors.white,
                        value: isCheckedAdvertiser,
                        onChanged: (bool? value) {
                          setState(() {
                            isCheckedAdvertiser = value!;
                            isCheckedAdmin = false;
                          });
                        },
                      ),
                    ),
                    Text('Advertiser'),
                  ],
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(4.0),
              child: Card(
                color: Color.fromARGB(255, 223, 228, 231),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0)),
                child: IconButton(
                    onPressed: () async {
                      User? user = await _authService
                          .signUp(_emailController.text,
                              _passwordController.text, _nameController.text)
                          .onError((error, stackTrace) {
                        ScaffoldMessenger.of(context)
                            .showSnackBar(const SnackBar(
                          content: Text('Sorry, invalid email or password.'),
                          duration: Duration(seconds: 3),
                        ));
                      });
                      if (isCheckedAdmin) {
                        user?.setAdmin();
                      }
                      if (isCheckedAdvertiser) {
                        user?.setAdvertiser();
                      }
                      _emailController.clear();
                      _passwordController.clear();
                      _nameController.clear();
                      isCheckedAdmin = false;
                      isCheckedAdvertiser = false;
                      print('user: $user');
                    },
                    icon: Icon(
                      Icons.check,
                      size: 30,
                      color: Colors.green,
                    )),
              ),
            ),
            // Expanded(child: UsersList()) // Must be merged to work
          ],
        )),
      ),
    );
  }
}

class UsersList extends StatefulWidget {
  UsersList({Key? key, this.userUid}) : super(key: key);
  String? userUid;

  @override
  State<UsersList> createState() => _UsersList();
}

class _UsersList extends State<UsersList> {
  @override
  Widget build(BuildContext context) {
    DatabaseService db = DatabaseService();

    return StreamBuilder(
      builder: (context, snapshot) {
        return FutureBuilder(
            builder: (context, snapshot) {
              List<User>? users = snapshot.data;
              print(users);
              if (users == null) {
                return const Center(child: CircularProgressIndicator());
              }
              return ListView(
                children: [
                  ShowUserButton(string: 'string1', card: UserAdminTile()),
                  ShowUserButton(string: 'string2', card: UserAdminTile())
                ],
              );
            },
            future: db.getUsers());
      },
      stream: db.getUsersStream(),
    );
  }
}
