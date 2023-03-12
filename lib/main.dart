import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:pu_frontend/common/appstate.dart';
import 'package:pu_frontend/firebase_options.dart';
import 'package:pu_frontend/models/session.dart';
import 'package:pu_frontend/screens/log_workout.dart';
import 'package:pu_frontend/screens/demohome.dart';
import 'package:pu_frontend/common/theme.dart';
import 'package:pu_frontend/screens/excercise_progression.dart';
import 'package:pu_frontend/screens/logged_workout.dart';
import 'package:pu_frontend/screens/login.dart';
import 'package:pu_frontend/screens/profile.dart';
import 'package:pu_frontend/screens/search.dart';
import 'package:pu_frontend/screens/signup.dart';
import 'package:pu_frontend/screens/workouts.dart';
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
    initialLocation: '/Home',
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const AuthWrapper(),
      ),
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginPage(),
      ),
      GoRoute(
          path: '/Home',
          pageBuilder: (context, state) {
            return CustomTransitionPage(
              transitionDuration: Duration(milliseconds: 180),
              key: state.pageKey,
              child: const DemoHome(),
              transitionsBuilder:
                  (context, animation, secondaryAnimation, child) =>
                      FadeTransition(opacity: animation, child: child),
            );
          }),
      GoRoute(
        path: '/signup',
        builder: (context, state) => const signUp(),
      ),
      GoRoute(
          path: '/ExcerciseProgression',
          pageBuilder: (context, state) {
            return CustomTransitionPage(
              transitionDuration: Duration(milliseconds: 180),
              key: state.pageKey,
              child: const ExcerciseProgression(),
              transitionsBuilder:
                  (context, animation, secondaryAnimation, child) =>
                      FadeTransition(opacity: animation, child: child),
            );
          }),
      GoRoute(
          path: '/workouts',
          pageBuilder: (context, state) {
            return CustomTransitionPage(
              transitionDuration: Duration(milliseconds: 180),
              key: state.pageKey,
              child: const Workouts(),
              transitionsBuilder:
                  (context, animation, secondaryAnimation, child) =>
                      FadeTransition(opacity: animation, child: child),
            );
          }),
      GoRoute(
        path: '/logNew/:param1:',
        name: 'logNew',
        builder: (context, state) {
          if (state.extra == null) {
            return LogWorkoutScreen(
              sessionID: state.params['param1'],
              sessionInstance: null,
            );
          }
          SessionInstance sessionInstance = state.extra as SessionInstance;
          return LogWorkoutScreen(
            sessionID: state.params['param1'],
            sessionInstance: sessionInstance,
          );
        },
      ),
      GoRoute(
          path: '/Search',
          pageBuilder: (context, state) {
            return CustomTransitionPage(
              transitionDuration: Duration(milliseconds: 180),
              key: state.pageKey,
              child: const SearchPage(),
              transitionsBuilder:
                  (context, animation, secondaryAnimation, child) =>
                      FadeTransition(opacity: animation, child: child),
            );
          }),
      GoRoute(
          path: '/Profile',
          pageBuilder: (context, state) {
            return CustomTransitionPage(
              transitionDuration: Duration(milliseconds: 180),
              key: state.pageKey,
              child: const ProfilePage(),
              transitionsBuilder:
                  (context, animation, secondaryAnimation, child) =>
                      FadeTransition(opacity: animation, child: child),
            );
          }),
      GoRoute(
        path: '/loggedWorkout',
        builder: (context, state) => const LoggedWorkout(),
      ),
    ],
  );
}

// root level widget main purpose is to provide lower widgets with app state
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: MultiProvider(
        // All providers are created here, and can provide data to all child widgets.

        providers: [
          Provider<AuthService>(create: (_) => AuthService()),
          Provider<DatabaseService>(create: (_) => DatabaseService()),

          /// This provider is used to determine whether a workout is in process or not.
          /// If it is, the user wont be allowed to start a new workout without taking action
          Provider<AppState>(
            create: (_) => AppState(),
          )
        ],
        child: MaterialApp.router(
          debugShowCheckedModeBanner: false,
          title: 'Trening App',
          routerConfig: router(),
          theme: appTheme,
        ),
      ),
    );
  }
}
