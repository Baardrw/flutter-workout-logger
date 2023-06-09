import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:intl/intl.dart';

import '../../models/excercise.dart';

class WeightTile extends StatelessWidget {
  const WeightTile({super.key, required this.log, required this.onDelete});
  final Log? log;
  final Function(Log log) onDelete;

  @override
  Widget build(BuildContext context) {
    if (log == null)
      return Container();
    else {
      return Card(
        elevation: 8,
        child: ListTile(
          title: Text('${log?.weight} kgs'),
          subtitle: Text('x ${log?.reps}'),
          leading: Text(DateFormat.yMd().format(log!.date)),
          trailing: IconButton(
            icon: Icon(Icons.delete),
            onPressed: () async {
              await onDelete(log!);
            },
          ),
        ),
      );
    }
  }
}
