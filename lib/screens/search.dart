import 'package:flutter/material.dart';
import 'package:pu_frontend/common/bottom_bar.dart';

class SearchPage extends StatelessWidget {
  const SearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    BottomBar bottomBar = BottomBar(3);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Søk'),
        backgroundColor: const Color.fromARGB(255, 51, 100, 140),
      ),
      body: const Center(
        child: Text(
          "Søk",
          textAlign: TextAlign.center,
        ),
      ),
      bottomNavigationBar: bottomBar.getBar(context),
    );
  }
}
