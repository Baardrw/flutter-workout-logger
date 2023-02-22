import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pu_frontend/screens/login.dart';

import '../models/user.dart';
import '../screens/demohome.dart';
import '../services/auth_service.dart';

/// AuthWrapper is a widget that will listen to the AuthService user stream and direct
/// between home page and login page whenever the user logs in or out.
class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final _authService = Provider.of<AuthService>(context);
    return StreamBuilder<User?>(
        stream: _authService.user,
        builder: (_, AsyncSnapshot<User?> snap) {
          if (snap.connectionState == ConnectionState.active) {
            final User? user = snap.data;
            if (user == null) {
              return const LoginPage();
            }
            return const ExcerciseProgression();
          }
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        });
  }
}
