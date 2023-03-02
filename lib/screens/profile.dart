import 'package:flutter/material.dart';
import 'package:pu_frontend/common/bottom_bar.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    BottomBar bottomBar = BottomBar(4);

    return Scaffold(
      body: const Center(
        child: Text(
          "Profil",
          textAlign: TextAlign.center,
        ),
      ),
      bottomNavigationBar: bottomBar.getBar(context),
    );
  }
}
