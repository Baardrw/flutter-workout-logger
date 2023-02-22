import 'package:flutter/material.dart';

import 'package:pu_frontend/widgets/workout_widgets/popup_card_widget.dart';

class AddProgramButton extends StatelessWidget {
  const AddProgramButton({
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
        // paddingOuter: EdgeInsets.all(62),
        padding: EdgeInsets.all(8), // Padding inside of the card
        color: Colors.white, // Color of the card
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(32)), // Shape of the card
        elevation: 2, // Elevation of the card
        tag: 'test', // MUST BE THE SAME AS IN `PopupItemLauncher`
        child: Container(
          width: 350,
          height: 550,
          child: Text('Opprette et helt nytt program'),
        ), // Your custom child widget.
      ),
    );
  }
}
