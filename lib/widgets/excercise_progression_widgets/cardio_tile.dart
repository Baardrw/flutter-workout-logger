import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:intl/intl.dart';

import '../../models/excercise.dart';

class CardioTile extends StatelessWidget {
  const CardioTile({super.key, required this.log, required this.onDelete});
  final Log? log;
  final Function(Log log) onDelete;

  @override
  Widget build(BuildContext context) {
    if (log == null)
      return Container();
    else {
      double speed = (log!.distance! / log!.duration!) * 3600 / 60;

      return Card(
        elevation: 8,
        child: ListTile(
            title: Text('${speed.toStringAsFixed(2)} km/h'),
            subtitle: Text('${log?.distance} km, ${log?.duration} mins'),
            leading: Text(DateFormat.yMd().format(log!.date)),
            trailing: IconButton(
              icon: Icon(Icons.delete),
              onPressed: () {
                onDelete(log!);
              },
            )),
      );
    }
  }
}
