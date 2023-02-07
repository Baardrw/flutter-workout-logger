import 'package:flutter/material.dart';
import 'package:pu_frontend/widgets/test/test_homepage.dart';

class DemoHome extends StatelessWidget {
  const DemoHome({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
            padding: const EdgeInsets.all(80.0), child: const TestHome()),
      ),
    );
  }
}
