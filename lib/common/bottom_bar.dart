import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';

class BottomBar {
  int _selectedIndex = 0;
  final _paths = [
    "Home",
    "ExcerciseProgression",
    "workouts",
    "Search",
    "Profile"
  ];

  final _navBarItems = [
    SalomonBottomBarItem(
      icon: const Icon(Icons.home),
      title: const Text("Home"),
      selectedColor: Colors.blue,
    ),
    SalomonBottomBarItem(
      icon: const ImageIcon(AssetImage("assets/icons8-workout-64.png")),
      title: const Text("Excercises"),
      selectedColor: Colors.blue,
    ),
    SalomonBottomBarItem(
      icon: const Icon(Icons.calendar_today),
      title: const Text("Training"),
      selectedColor: Colors.blue,
    ),
    SalomonBottomBarItem(
      icon: const Icon(Icons.search),
      title: const Text("Search"),
      selectedColor: Colors.blue,
    ),
    SalomonBottomBarItem(
      icon: const Icon(Icons.person),
      title: const Text("Profile"),
      selectedColor: Colors.blue,
    ),
  ];

  BottomBar(int _selectedIndex) {
    this._selectedIndex = _selectedIndex;
  }

  SalomonBottomBar getBar(BuildContext context) {
    return SalomonBottomBar(
        currentIndex: _selectedIndex,
        selectedItemColor: const Color(0xff6200ee),
        unselectedItemColor: const Color(0xff757575),
        duration: Duration(microseconds: 1),
        onTap: (index) {
          setState(index);
          context.go("/${_paths[_selectedIndex]}");
        },
        items: _navBarItems);
  }

  void setState(int index) {
    _selectedIndex = index;
  }
}
