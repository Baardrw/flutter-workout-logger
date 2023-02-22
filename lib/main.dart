import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:pu_frontend/firebase_options.dart';
import 'package:pu_frontend/screens/demohome.dart';
import 'package:pu_frontend/common/theme.dart';
import 'package:pu_frontend/screens/excercise_progression.dart';
import 'package:pu_frontend/screens/login.dart';
import 'package:pu_frontend/screens/signup.dart';
import 'package:pu_frontend/services/auth_service.dart';
import 'package:pu_frontend/services/db_service.dart';
import 'package:pu_frontend/widgets/auth_wrapper.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(const MyApp());
}

/// This is the router that will be used by the MaterialApp.router to navigate between pages.

/// defaults to the authwrapper page, which will redirect to the login page if the user is not logged in.
GoRouter router() {
  return GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const AuthWrapper(),
      ),
      GoRoute(
        path: '/demo',
        builder: (context, state) => const LoginPage(),
      ),
      GoRoute(
        path: '/demo2',
        builder: (context, state) => const DemoHome(),
      ),
      GoRoute(
        path: '/signupdemo',
        builder: (context, state) => const signUp(),
      ),
      GoRoute(
        path: '/ExcerciseProgression',
        builder: (context, state) => const ExcerciseProgression(),
      ),
    ],
  );
}

// root level widget main purpose is to provide lower widgets with app state
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      // All providers are created here, and can provide data to all child widgets.

      providers: [
        Provider<AuthService>(create: (_) => AuthService()),
        Provider<DatabaseService>(create: (_) => DatabaseService())
      ],
      child: MaterialApp.router(
        debugShowCheckedModeBanner: false,
        title: 'Trening App',
        routerConfig: router(),
        theme: appTheme,
      ),
    );
  }
}
