import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pu_frontend/widgets/workout_widgets/popup_card_widget.dart';

import '../../models/excercise.dart';
import '../../services/db_service.dart';

class ShowUserButton extends StatelessWidget {
  final String string;
  final UserAdminTile card;

  const ShowUserButton({
    required this.string,
    required this.card,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PopupItemLauncher(
      tag: string,
      popUp: PopUpItem(
        // paddingOuter: EdgeInsets.all(0), // Padding outside of the card
        padding: const EdgeInsets.all(8), // Padding inside of the card
        color: const Color.fromARGB(255, 232, 232, 232), // Color of the card
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(32)), // Shape of the card
        elevation: 2, // Elevation of the card
        tag: string, // MUST BE THE SAME AS IN `PopupItemLauncher`
        child: UserContent(),
      ),
      child: card, // Your custom child widget.
    );
  }
}

class UserContent extends StatelessWidget {
  const UserContent({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.5,
      width: MediaQuery.of(context).size.width * 0.9,
    );
  }
}

class UserAdminTile extends StatelessWidget {
  const UserAdminTile({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.fromLTRB(1, 1, 1, 1),
      color: Color.fromARGB(255, 220, 220, 220),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 0, 12, 0),
              child: Text('Name'),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
              child: IconButton(onPressed: () {}, icon: Icon(Icons.delete)),
            )
          ],
        ),
      ),
    );
  }
}
