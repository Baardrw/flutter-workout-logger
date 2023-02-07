import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:pu_frontend/services/auth_service.dart';

class TestHome extends StatelessWidget {
  const TestHome({super.key});

  @override
  Widget build(BuildContext context) {
    final AuthService _authService = Provider.of<AuthService>(context);

    return Container(
        padding: const EdgeInsets.all(80.0),
        child: Column(children: [
          ElevatedButton(
              onPressed: () {
                _authService.signOut();
              },
              child: const Text('Sign Out'))
        ]));
  }
}
