import 'package:flutter/material.dart';
import 'package:pu_frontend/screens/bottom_bar.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    BottomBar bottomBar = BottomBar(4);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profil'),
        backgroundColor: const Color.fromARGB(255, 51, 100, 140),
      ),
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
