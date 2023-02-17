import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:intl/intl.dart';

import '../../models/excercise.dart';

class CardioTile extends StatelessWidget {
  const CardioTile({super.key, required this.log});
  final Log? log;

  @override
  Widget build(BuildContext context) {
    if (log == null)
      return Container();
    else {
      double speed = (log!.distance! / log!.duration!) * 3.6 / 60;

      return Card(
        elevation: 8,
        child: ListTile(
          title: Text('${speed.toStringAsFixed(2)} km/h'),
          subtitle: Text('${log?.distance} m, ${log?.duration} mins'),
          leading: Text(DateFormat.yMd().format(log!.date)),
        ),
      );
    }
  }
}
