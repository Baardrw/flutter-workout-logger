import 'package:flutter/material.dart';

class SearchBar extends StatelessWidget {
  final String hintText;
  final TextEditingController controller;
  
  const SearchBar({
    super.key,
    required this.hintText,
    required this.controller
  });

@override
Widget build(BuildContext context) {
  return Padding(
    padding: const EdgeInsets.only(
      top: 15,
      left: 10.0,
      right: 10.0,
    ),
    child: Row(
      children: [
        Expanded(
          flex: 3,
          child: TextField(
            controller: controller,
            decoration: InputDecoration(
              suffixIcon: IconButton(
                onPressed: controller.clear,
                icon: Icon(Icons.clear),
              ),
              prefixIcon: const Icon(Icons.search),
              enabledBorder: const OutlineInputBorder(
                borderSide: BorderSide(),
              ),
              focusedBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey)),
              hintText: hintText,
            ),
          ),
        ),
        const SizedBox(width: 5),
        Expanded(
          flex: 1,
          child: ElevatedButton.icon(
            onPressed: () => print("object"),
            style: ElevatedButton.styleFrom(
                maximumSize: const Size(64, 60),
                backgroundColor: const Color.fromARGB(255, 51, 100, 140),
                padding: const EdgeInsets.all(20.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0)
                )),
            icon: const Icon(IconData(0xf0072, fontFamily: 'MaterialIcons')),
            label: const Text("Søk"),
            ),
        ),
      ],
    ),
  );
}
}