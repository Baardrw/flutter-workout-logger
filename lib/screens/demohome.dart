import 'package:flutter/material.dart';
import 'package:pu_frontend/widgets/test/test_homepage.dart';

import '../common/bottom_bar.dart';
import '../widgets/app_bar.dart';

class DemoHome extends StatelessWidget {
  const DemoHome({super.key});

  @override
  Widget build(BuildContext context) {
    BottomBar bottomBar = BottomBar(0);
    return Scaffold(
      appBar: GlobalAppBar(
        title: 'Hjem',
      ),
      body: const Center(
        child: TestHome(),
        // child: TestHome(),
      ),
      bottomNavigationBar: bottomBar.getBar(context),
    );
  }
}
