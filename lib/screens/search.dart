import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pu_frontend/models/excercise.dart';

import '../common/bottom_bar.dart';
import '../models/user.dart';
import '../services/db_service.dart';
import '../widgets/search_widgets/search_bar.dart';

//Search page where users can search for other users and groups. Contains a TabBarView with
//options for user search and group search. Each view contains a SearchBar widget, which
//takes care of the search
class SearchPage extends StatefulWidget {
  const SearchPage({
    super.key,
    this.tile,
    this.gestureDetectorOnTap,
  });
  final String? tile;
  final Function(Excercise)? gestureDetectorOnTap;


  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  
  @override
  Widget build(BuildContext context) {
    final DatabaseService dbservice = Provider.of<DatabaseService>(context);
    final TextEditingController _userController = TextEditingController();
    final TextEditingController _groupController = TextEditingController();
    BottomBar bottomBar = BottomBar(3);
    
    return Scaffold(
      body: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            bottom: const TabBar(
              tabs: [Tab(icon: Icon(Icons.person)), Tab(icon: Icon(IconData(0xe9e9, fontFamily: 'MaterialIcons')))]
            ),
            title: const Text("Søk"),
            backgroundColor: const Color.fromARGB(255, 51, 100, 140),
          ),
          body: TabBarView(
            children: [
              Column(
                children: [
                  SearchBar(
                    hintText: "Søk blant brukere",
                    controller: _userController,
                    dbservice: dbservice,
                    icon: const Icon(Icons.person, color: Colors.white),
                    type: "user"
                  ),
                ],
              ),
              Column(
                children: [
                  SearchBar(
                    hintText: "Søk blant grupper",
                    controller: _groupController,
                    dbservice: dbservice,
                    icon: const Icon(IconData(0xe9e9, fontFamily: 'MaterialIcons'), color: Colors.white,),
                    type: "group"
                  ),
                ],
              )
            ]
          ),
        )
      ),
      bottomNavigationBar: bottomBar.getBar(context)
    );
  }
}