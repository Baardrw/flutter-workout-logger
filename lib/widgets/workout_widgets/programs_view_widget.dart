import 'package:flutter/material.dart';
import 'package:pu_frontend/widgets/workout_widgets/add_program_button.dart';

import 'package:pu_frontend/widgets/workout_widgets/program_card_widget.dart';
import 'package:pu_frontend/widgets/workout_widgets/show_program_button.dart';

class ProgramsView extends StatelessWidget {
  const ProgramsView({super.key});

  @override
  Widget build(BuildContext context) {
    const ProgramCard pc1 =
        ProgramCard(true, false, false, true, true, true, false);
    const ProgramCard pc2 =
        ProgramCard(true, false, false, false, false, false, false);
    const ProgramCard pc3 =
        ProgramCard(true, false, false, true, false, true, false);
    const ProgramCard pc4 =
        ProgramCard(true, false, false, false, false, false, true);
    const ProgramCard pc5 =
        ProgramCard(true, false, true, true, true, true, false);
    const ProgramCard pc6 =
        ProgramCard(true, false, false, true, true, true, false);
    const String ID1 = '1';
    const String ID2 = '2';
    const String ID3 = '3';
    const String ID4 = '4';
    const String ID5 = '5';
    const String ID6 = '6';
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 225, 225, 225),
      body: Center(
        child: ListView(
          padding: const EdgeInsets.all(12.0),
          children: <Widget>[
            ShowProgramButton(test: pc1, string: ID1),
            SizedBox(height: 10),
            ShowProgramButton(test: pc2, string: ID2),
            SizedBox(height: 10),
            ShowProgramButton(test: pc3, string: ID3),
            SizedBox(height: 10),
            ShowProgramButton(test: pc4, string: ID4),
            SizedBox(height: 10),
            ShowProgramButton(test: pc5, string: ID5),
            SizedBox(height: 10),
            ShowProgramButton(test: pc6, string: ID6),
            SizedBox(height: 10),
            AddProgramButton(),
          ],
        ),
      ),
    );
  }
}
