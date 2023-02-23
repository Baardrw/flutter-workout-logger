import 'package:flutter/material.dart';

// class ExerciseCard extends StatelessWidget {
//   const ExerciseCard({
//     Key? key,
//   }) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: () {
//         const snackBar = SnackBar(content: Text('Tap'));
//         ScaffoldMessenger.of(context).showSnackBar(snackBar);
//       },
//       child: Card(
//         shape:
//             RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
//         child: Container(
//           width: 180,
//           height: 180,
//           padding: const EdgeInsets.all(24.0),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Text(
//                     'Tittel',
//                     style: TextStyle(
//                       fontWeight: FontWeight.bold,
//                       fontSize: 25,
//                     ),
//                   ),
//                   Icon(
//                     Icons.bookmark_rounded,
//                     color: Colors.blueAccent,
//                     size: 35,
//                   )
//                 ],
//               ),
//               SizedBox(height: 10),
//               Row(
//                 children: [
//                   Icon(Icons.access_time_outlined),
//                   SizedBox(width: 6),
//                   Text('60 min'),
//                 ],
//               ),
//               SizedBox(height: 10),
//               Icon(
//                 Icons.directions_run_rounded,
//                 size: 35,
//               )
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

class WorkoutCard extends StatelessWidget {
  const WorkoutCard({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Card(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
        child: Container(
          width: 180,
          height: 180,
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Tittel',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 25,
                    ),
                  ),
                  Icon(
                    Icons.bookmark_rounded,
                    color: Colors.blueAccent,
                    size: 35,
                  )
                ],
              ),
              SizedBox(height: 10),
              Row(
                children: [
                  Icon(Icons.access_time_outlined),
                  SizedBox(width: 6),
                  Text('60 min'),
                ],
              ),
              SizedBox(height: 10),
              Icon(
                Icons.directions_run_rounded,
                size: 35,
              )
            ],
          ),
        ),
      ),
    );
  }
}
