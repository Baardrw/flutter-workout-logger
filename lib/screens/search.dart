import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../common/bottom_bar.dart';
import '../widgets/search_widgets/search_bar.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  @override
  Widget build(BuildContext context) {
    final TextEditingController _searchController = TextEditingController();
    BottomBar bottomBar = BottomBar(3);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Søk'),
        backgroundColor: const Color.fromARGB(255, 51, 100, 140),
      ),
      body: Column(
        children: [
          SearchBar(
          hintText: "Søk i Logify",
          controller: _searchController,
          ),
        ],
      ),
      bottomNavigationBar: bottomBar.getBar(context),
    );
  }
}