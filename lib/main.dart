import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:pu_frontend/screens/demohome.dart';
import 'package:pu_frontend/common/theme.dart';
import 'package:pu_frontend/screens/login.dart';

import 'db.dart';
import 'models/counter.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Firebase.initializeApp();

  runApp(MyApp());
}

// This is the router that will be used by the MaterialApp.router to navigate between pages.
GoRouter router() {
  return GoRouter(
    initialLocation: '/demo',
    routes: [
      GoRoute(
        path: '/demo',
        builder: (context, state) => const DemoPage(),
      ),
      GoRoute(
        path: '/demo2',
        builder: (context, state) => const DemoHome(),
      ),
    ],
  );
}

// root level widget main purpose is to provide lower widgets with app state
class MyApp extends StatelessWidget {
  MyApp({super.key});
  final db = DataBaseService();

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      // All providers are created here, and can provide data to all child widgets.

      providers: [
        ChangeNotifierProvider(create: (_) => Counter()),
      ],
      child: MaterialApp.router(
        title: 'Demo',
        routerConfig: router(),
        theme: appTheme,
      ),
    );
  }
}
