import 'package:flutter/material.dart';
import 'package:pu_frontend/widgets/test/test_homepage.dart';

import '../common/bottom_bar.dart';

class DemoHome extends StatelessWidget {
  const DemoHome({super.key});

  @override
  Widget build(BuildContext context) {
    BottomBar bottomBar = BottomBar(0);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hjem'),
        backgroundColor: const Color.fromARGB(255, 51, 100, 140),
      ),
      body: const Center(
        child: Text('Hjem'),
        // child: TestHome(),
      ),
      bottomNavigationBar: bottomBar.getBar(context),
    );
  }
}
