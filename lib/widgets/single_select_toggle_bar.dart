import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/widgets.dart';

class SingleSelectButtonBar extends StatefulWidget {
  const SingleSelectButtonBar(this.list, this.title, this.isSelected, this.sort,
      {super.key});
  final List<Text> list;
  final String title;
  final List<bool> isSelected;
  final VoidCallback sort;

  @override
  State<SingleSelectButtonBar> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<SingleSelectButtonBar> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(widget.title),
        SizedBox(height: 5),
        ToggleButtons(
          onPressed: ((index) {
            setState(() {
              for (int i = 0; i < widget.isSelected.length; i++) {
                widget.isSelected[i] = i == index;
              }
              widget.sort();
            });
          }),
          borderRadius: const BorderRadius.all(Radius.circular(8)),
          selectedBorderColor: Colors.blue[700],
          selectedColor: Colors.white,
          fillColor: Colors.lightBlue[200],
          color: Colors.lightBlue[400],
          constraints: const BoxConstraints(
            minHeight: 40.0,
            minWidth: 80.0,
          ),
          isSelected: widget.isSelected,
          children: widget.list,
        ),
      ],
    );
  }
}
