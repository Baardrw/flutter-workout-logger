import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:pu_frontend/services/auth_service.dart';

import '../models/user.dart';

class signUp extends StatefulWidget {
  const signUp({super.key});

  @override
  State<signUp> createState() => _DemoPageState();
}

class _DemoPageState extends State<signUp> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  late User? _user;

  @override
  Widget build(BuildContext context) {
    final AuthService _authService = Provider.of<AuthService>(context);

    return Scaffold(
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(80.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Welcome',
                style: Theme.of(context).textTheme.displayLarge,
              ),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(
                  hintText: 'Username',
                ),
              ),
              TextFormField(
                controller: _passwordController,
                decoration: const InputDecoration(hintText: 'Password'),
                obscureText: true,
              ),
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(hintText: 'Password'),
                obscureText: true,
              ),
              const SizedBox(
                height: 24,
              ),
              ElevatedButton(
                onPressed: () async {
                  User? user = await _authService
                      .signUp(_emailController.text, _passwordController.text,
                          _nameController.text)
                      .onError((error, stackTrace) {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text('Invalid Credentials'),
                      duration: Duration(seconds: 3),
                    ));
                  });
                  print('user: $user');
                  // If this line of code is reached then the user has failed to log in
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.yellow,
                ),
                child: const Text('ENTER'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
