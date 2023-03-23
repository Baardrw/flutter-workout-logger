import 'package:flutter/material.dart';
import '../../../models/program.dart';

class ProgramCard extends StatelessWidget {
  final Program program;

  const ProgramCard(
    this.program, {
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Card(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
        child: Container(
          padding: const EdgeInsets.all(22.0),
          child: Column(
            children: <Widget>[
              SizedBox(height: 8),
              WorkoutCardHeader(program),
              SizedBox(height: 25),
              WeekBar(
                  program.days!['monday']!.isNotEmpty,
                  program.days!['tuesday']!.isNotEmpty,
                  program.days!['wednesday']!.isNotEmpty,
                  program.days!['thursday']!.isNotEmpty,
                  program.days!['friday']!.isNotEmpty,
                  program.days!['saturday']!.isNotEmpty,
                  program.days!['sunday']!.isNotEmpty),
              SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }
}

class WorkoutCardHeader extends StatelessWidget {
  // List<bool> days;
  // WeekBar(this.days);
  const WorkoutCardHeader(this.program, {super.key});

  final Program program;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          program.name,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 25,
          ),
        ),
        Expanded(
            child: Center(
          child: Icon(
            Icons.fitness_center,
            size: 30,
          ),
        )),
        Icon(Icons.account_circle_outlined),
      ],
    );
  }
}

class WeekBar extends StatelessWidget {
  // List<bool> days;
  // WeekBar(this.days);
  bool mon;
  bool tue;
  bool wed;
  bool thu;
  bool fri;
  bool sat;
  bool sun;

  Color active = Colors.blue;
  Color inActive = Color.fromARGB(255, 221, 221, 221);

  WeekBar(this.mon, this.tue, this.wed, this.thu, this.fri, this.sat, this.sun);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CircleAvatar(
          backgroundColor: mon ? active : inActive,
          radius: 15,
          child: Text(
            'M',
            style: TextStyle(color: !mon ? active : inActive),
          ),
        ),
        Spacer(),
        CircleAvatar(
          backgroundColor: tue ? active : inActive,
          radius: 15,
          child: Text('T', style: TextStyle(color: !tue ? active : inActive)),
        ),
        Spacer(),
        CircleAvatar(
          backgroundColor: wed ? active : inActive,
          radius: 15,
          child: Text('O', style: TextStyle(color: !wed ? active : inActive)),
        ),
        Spacer(),
        CircleAvatar(
          backgroundColor: thu ? active : inActive,
          radius: 15,
          child: Text('T', style: TextStyle(color: !thu ? active : inActive)),
        ),
        Spacer(),
        CircleAvatar(
          backgroundColor: fri ? active : inActive,
          radius: 15,
          child: Text('F', style: TextStyle(color: !fri ? active : inActive)),
        ),
        Spacer(),
        CircleAvatar(
          backgroundColor: sat ? active : inActive,
          radius: 15,
          child: Text('L', style: TextStyle(color: !sat ? active : inActive)),
        ),
        Spacer(),
        CircleAvatar(
          backgroundColor: sun ? active : inActive,
          radius: 15,
          child: Text('S', style: TextStyle(color: !sun ? active : inActive)),
        ),
      ],
    );
  }
}
