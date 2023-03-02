import 'package:flutter/material.dart';

class ProgramCard extends StatelessWidget {
  final bool mon;
  final bool tue;
  final bool wed;
  final bool thu;
  final bool fri;
  final bool sat;
  final bool sun;

  const ProgramCard(
    this.mon,
    this.tue,
    this.wed,
    this.thu,
    this.fri,
    this.sat,
    this.sun, {
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
              WorkoutCardHeader(),
              SizedBox(height: 25),
              WeekBar(mon, tue, wed, thu, fri, sat, sun),
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
  const WorkoutCardHeader();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: const [
        Text(
          'Tittel',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 25,
          ),
        ),
        Expanded(
            child: Center(
          child: Icon(Icons.fitness_center),
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
        SizedBox(width: 11),
        CircleAvatar(
          backgroundColor: tue ? active : inActive,
          radius: 15,
          child: Text('T', style: TextStyle(color: !tue ? active : inActive)),
        ),
        SizedBox(width: 11),
        CircleAvatar(
          backgroundColor: wed ? active : inActive,
          radius: 15,
          child: Text('O', style: TextStyle(color: !wed ? active : inActive)),
        ),
        SizedBox(width: 11),
        CircleAvatar(
          backgroundColor: thu ? active : inActive,
          radius: 15,
          child: Text('T', style: TextStyle(color: !thu ? active : inActive)),
        ),
        SizedBox(width: 11),
        CircleAvatar(
          backgroundColor: fri ? active : inActive,
          radius: 15,
          child: Text('F', style: TextStyle(color: !fri ? active : inActive)),
        ),
        SizedBox(width: 11),
        CircleAvatar(
          backgroundColor: sat ? active : inActive,
          radius: 15,
          child: Text('L', style: TextStyle(color: !sat ? active : inActive)),
        ),
        SizedBox(width: 11),
        CircleAvatar(
          backgroundColor: sun ? active : inActive,
          radius: 15,
          child: Text('S', style: TextStyle(color: !sun ? active : inActive)),
        ),
      ],
    );
  }
}
