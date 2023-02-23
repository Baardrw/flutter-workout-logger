import 'package:flutter/material.dart';
import 'package:pu_frontend/screens/bottom_bar.dart';

class SearchPage extends StatelessWidget {
  const SearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    BottomBar bottomBar = BottomBar(3);
    
    return Scaffold(
      body: const Center(
        child: Text("Søk", textAlign: TextAlign.center,),
      ),
      bottomNavigationBar: bottomBar.getBar(context),
    );
  }
}