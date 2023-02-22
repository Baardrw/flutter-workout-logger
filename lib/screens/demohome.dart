import 'package:flutter/material.dart';
import 'package:pu_frontend/widgets/test/test_homepage.dart';

import 'bottom_bar.dart';


class DemoHome extends StatelessWidget {
  const DemoHome({super.key});


  @override
  Widget build(BuildContext context) {
    BottomBar bottomBar = BottomBar(0);
    return Scaffold(
      body: const Center(
        child: TestHome(),
      ),
    bottomNavigationBar: bottomBar.getBar(context),
    );
  }
}
