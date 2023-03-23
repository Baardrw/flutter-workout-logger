import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:pu_frontend/screens/profile.dart';
import 'package:pu_frontend/services/auth_service.dart';

import '../../models/group.dart';
import '../../models/user.dart';

//The SearchScroller contains each result listed from a search
class SearchScroller extends StatelessWidget {
  List<dynamic> searchObjects;
  List<Widget> widgets = [];

  SearchScroller({
    super.key,
    required this.searchObjects,
  });

  @override
  Widget build(BuildContext context) {

    //Iterates through each user/group and makes a ListTile-widget representing the search result
    for (var searchObject in searchObjects) {
      String id = "";
      String name = "";
      MaterialPageRoute materialPageRoute = MaterialPageRoute(
                    builder: (context) =>
                        ProfilePage(userUid: searchObject.uid));

      if (searchObject is User) {
        id = searchObject.uid;
        name = searchObject.name ?? "";
      } else if (searchObject is Group){
        id = searchObject.id;
        name = id;
        materialPageRoute = MaterialPageRoute(
                    builder: (context) =>
                        ProfilePage(userUid: searchObject.name));
      }
      print(name + id);


      if (id != Provider.of<AuthService>(context).uid) {

        widgets.add(
          GestureDetector(
            child: Padding(
              padding: const EdgeInsets.only(top: 10),
              child: ListTile(
                title: Text(name, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
                leading: CircleAvatar(backgroundImage: NetworkImage(searchObject.profilePicture)),
                tileColor: const Color.fromARGB(255, 51, 100, 140),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),

            ),
          onTap: () {
            Navigator.push(
                context,
                materialPageRoute);
          },
        ));
      }
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