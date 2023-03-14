import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

//The SearchScroller contains each result listed from a search
class SearchScroller extends StatelessWidget {
  List<dynamic> searchObjects;
  Icon icon;
  List<Widget> widgets = [];

  
  SearchScroller({
    super.key,
    required this.searchObjects,
    required this.icon
    });

  @override
  Widget build(BuildContext context) {
    
    //Iterates through each user/group and makes a ListTile-widget representing the search result
    for (var searchObject in searchObjects) {
      String name;
      if (searchObject.name == null) {
        name = "";
      } else {
        name = searchObject.name!;
      }
      widgets.add(
        Padding(
          padding: const EdgeInsets.only(top: 10),
          child: ListTile(
            title: Text(name, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
            leading: icon,
            tileColor: const Color.fromARGB(255, 51, 100, 140),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
        )
      );
    }
    
    //Representing all the ListTiles from the search result
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Column(
        children: widgets,
      ),
    );
  }
}