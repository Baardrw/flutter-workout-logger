import 'package:flutter/material.dart';
import 'package:pu_frontend/models/session.dart';

class WorkoutCard extends StatelessWidget {
  final Session session;

  const WorkoutCard(
    this.session, {
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Card(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
        child: Container(
          width: 200,
          height: 200,
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    height: 40,
                    width: MediaQuery.of(context).size.width * 0.2,
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      alignment: Alignment.centerLeft,
                      child: Text(
                        session.name,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 25,
                        ),
                      ),
                    ),
                  ),
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    child: const Icon(
                      Icons.bookmark_rounded,
                      color: Colors.blueAccent,
                      size: 35,
                    ),
                  )
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  const Icon(Icons.access_time_outlined),
                  const SizedBox(width: 6),
                  Text('${session.timeEstimate} min'),
                ],
              ),
              const SizedBox(height: 10),
              const Icon(
                Icons.fitness_center_rounded,
                size: 35,
              )
            ],
          ),
        ),
      ),
    );
  }
}
