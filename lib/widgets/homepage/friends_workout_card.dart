import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pu_frontend/models/session.dart';

class FriendsWorkoutCard extends StatelessWidget {
  const FriendsWorkoutCard(
    this.session,
    this.string,
    this.sessionInstance, {
    Key? key,
  }) : super(key: key);

  final Session session;
  final String string;
  final SessionInstance sessionInstance;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        child: Stack(
          children: [
            Container(
              width: double.infinity,
              height: 180,
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
                      Spacer(flex: 100),
                      SizedBox(
                        height: 40,
                        width: MediaQuery.of(context).size.width * 0.2,
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "${sessionInstance.FormattedDate}",
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 25,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      const Icon(Icons.access_time_outlined),
                      const SizedBox(width: 6),
                      Text(
                        "${session.timeEstimate.toString()} minutes",
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  const Icon(
                    Icons.directions_run_rounded,
                    size: 35,
                  )
                ],
              ),
            ),
            Positioned(
              bottom: 10,
              right: 10,
              child: Row(children: [
                Text(
                  string,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
              ]),
            ),
          ],
        ),
      ),
    );
  }
}
