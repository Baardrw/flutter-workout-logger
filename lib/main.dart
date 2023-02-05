import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:pu_frontend/screens/demohome.dart';
import 'package:pu_frontend/common/theme.dart';

import 'models/counter.dart';

void main() {
  runApp(const MyApp());
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
  const MyApp({super.key});

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

class DemoPage extends StatelessWidget {
  const DemoPage({super.key});

  @override
  Widget build(BuildContext context) {
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
                decoration: const InputDecoration(
                  hintText: 'Username',
                ),
              ),
              TextFormField(
                decoration: const InputDecoration(
                  hintText: 'Password',
                ),
                obscureText: true,
              ),
              const SizedBox(
                height: 24,
              ),
              ElevatedButton(
                onPressed: () {
                  context.pushReplacement('/demo2');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.yellow,
                ),
                child: const Text('ENTER'),
              ),
              const SizedBox(
                height: 24,
              ),
              Consumer<Counter>(builder: (context, counter, child) {
                return Text(
                  'Counter: ${counter.count}',
                  style: Theme.of(context).textTheme.displayLarge,
                );
              })
            ],
          ),
        ),
      ),
    );
  }
}
