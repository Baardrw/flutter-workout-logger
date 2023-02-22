import 'package:flutter/material.dart';

import 'package:popup_card/popup_card.dart';

class AddWorkoudButton extends StatelessWidget {
  const AddWorkoudButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PopupItemLauncher(
      tag: 'test',
      child: Material(
        color: Colors.white,
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(32)),
        child: const Icon(
          Icons.add_rounded,
          size: 45,
        ),
      ),
      popUp: PopUpItem(
        padding: EdgeInsets.all(0),
        // paddingOuter: EdgeInsets.all(62), // Padding inside of the card
        color: Colors.white, // Color of the card
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(32)), // Shape of the card
        elevation: 2, // Elevation of the card
        tag: 'test', // MUST BE THE SAME AS IN `PopupItemLauncher`
        child: Container(
          width: 350,
          height: 480,
          child: Text('Opprette en helt ny økt'),
        ), // Your custom child widget.
      ),
    );
  }
}
