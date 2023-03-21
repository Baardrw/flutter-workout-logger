import 'package:flutter/material.dart';
import 'package:pu_frontend/widgets/search_widgets/search_scroller.dart';
import '../../services/db_service.dart';

//Search widget which includes a search field, a search button and a SearchScroller-widget
class SearchBar extends StatefulWidget {
  String type;
  final String hintText;
  final TextEditingController controller;
  List<Widget> widgets = [];
  List<Column> searchView = [];
  DatabaseService dbservice;
  
  SearchBar({
    super.key,
    required this.hintText,
    required this.controller,
    required this.type,
    required this.dbservice
  });
  
  @override
  State<SearchBar> createState() => _SearchBarState();
}

//Updates the SearchScroller whenever the search button is pressed
void updateSearchScroller(BuildContext context, Future<List<dynamic>> query, SearchBar widget) {
  widget.searchView = [];
  widget.searchView.add (
  Column(
    children: [
      FutureBuilder(
        builder: ((context, snapshot) {
          if (snapshot.hasData) {
            List<dynamic> searchObjects = snapshot.data as List<dynamic>;
            if (searchObjects.isEmpty) {
              return const Text("No result");
            } else {
              return SearchScroller(searchObjects: searchObjects);
            }
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        }),
        future: query,
      ),
    ],
  ));
}


class _SearchBarState extends State<SearchBar> {

  @override
  Widget build(BuildContext context) {
    
    return Padding(
      padding: const EdgeInsets.only(
        top: 15,
        left: 10.0,
        right: 10.0,
      ),
      child: SingleChildScrollView(
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  flex: 3,
                  child: TextField(
                    controller: widget.controller,
                    decoration: InputDecoration(
                      suffixIcon: IconButton(
                        onPressed: widget.controller.clear,
                        icon: const Icon(Icons.clear),
                      ),
                      prefixIcon: const Icon(Icons.search),
                      enabledBorder: const OutlineInputBorder(
                        borderSide: BorderSide(),
                      ),
                      focusedBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey)),
                      hintText: widget.hintText,
                    ),
                  ),
                ),
                const SizedBox(width: 5),
                Expanded(
                  flex: 1,
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        Future<List<dynamic>> query = widget.dbservice.getUsersByUsername(widget.controller.text.toLowerCase());
                        if (widget.type == "user") {
                          query = widget.dbservice.getUsersByUsername(widget.controller.text.toLowerCase());
                        } else if (widget.type == "group") {
                          // TODO: declare group query in dbservice
                        }
                        updateSearchScroller(context, query, widget);
                      });
                    },
                    style: ElevatedButton.styleFrom(
                        maximumSize: const Size(64, 60),
                        backgroundColor: const Color.fromARGB(255, 51, 100, 140),
                        padding: const EdgeInsets.all(20.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.0)
                        )),
                    child: const Text("Search", style: TextStyle(fontSize: 17),),
                    ),
                ),
              ],
            ),
            //ListView dynamically updates whenever the SearchScroller-widget is updated
            Center(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: widget.searchView.length,
                itemBuilder: (BuildContext context, int index) {
                  return widget.searchView[index];
                }
              ),
            )
          ],
        ),
      ),
    );
  }
}
