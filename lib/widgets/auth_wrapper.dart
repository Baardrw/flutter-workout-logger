import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pu_frontend/screens/login.dart';
import 'package:pu_frontend/screens/workouts.dart';

import '../models/user.dart';
import '../screens/admin.dart';
import '../screens/advertiser.dart';
import '../screens/demohome.dart';
import '../screens/excercise_progression.dart';
import '../services/auth_service.dart';
import '../services/db_service.dart';

/// AuthWrapper is a widget that will listen to the AuthService user stream and direct
/// between home page and login page whenever the user logs in or out.
class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final _authService = Provider.of<AuthService>(context);
    DatabaseService db = Provider.of<DatabaseService>(context);
    return StreamBuilder<User?>(
        stream: _authService.user,
        builder: (_, AsyncSnapshot<User?> snap) {
          if (snap.connectionState != ConnectionState.active) {
            return const Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }

          final User? user = snap.data;
          if (user == null) {
            return const LoginPage();
          }

          return FutureBuilder(
            builder: (context, snapshot) {
              if (snap.connectionState == ConnectionState.active) {
                User? user = snapshot.data;
                if (user == null) {
                  return const LoginPage();
                } else if (user.isAdmin()) {
                  // user.isAdmin()
                  return Admin();
                } else if (user.isAdvertiser()) {
                  // user.isAdvertiser()
                  return Advertiser();
                }
                return const Workouts();
              }
              return const Scaffold(
                body: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            },
            future: db.getUser(user.uid),
          );
        });
  }
}
