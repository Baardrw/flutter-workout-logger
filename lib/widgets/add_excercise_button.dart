import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pu_frontend/services/db_service.dart';

import '../models/excercise.dart';

class AddExcerciseButton extends StatelessWidget {
  const AddExcerciseButton({
    Key? key,
  }) : super(key: key);

  Future<void> _addExcercise(BuildContext context) {
    return showDialog(
      context: context,
      builder: ((context) => StatefulBuilder(
            builder: (context, setState) {
              final TextEditingController _nameController =
                  TextEditingController();
              final TextEditingController _descriptionController =
                  TextEditingController();
              ExcerciseType _type = ExcerciseType.none;
              BodyPart _bodyPart = BodyPart.none;

              return AlertDialog(
                title: const Text('Add Excercise'),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: _nameController,
                      decoration: const InputDecoration(
                        labelText: 'Excercise Name',
                      ),
                    ),
                    TextField(
                      controller: _descriptionController,
                      decoration: const InputDecoration(
                        labelText: 'Excercise Description (Optional)',
                      ),
                    ),
                    const SizedBox(height: 10),
                    DropdownButtonFormField(
                      decoration: const InputDecoration(
                        labelText: 'Excercise Type',
                      ),
                      items: const [
                        DropdownMenuItem(
                          value: ExcerciseType.strength,
                          child: Text('Strength'),
                        ),
                        DropdownMenuItem(
                          value: ExcerciseType.cardio,
                          child: Text('Cardio'),
                        ),
                      ],
                      onChanged: (ExcerciseType? value) {
                        _type = value!;
                      },
                    ),
                    const SizedBox(height: 10),
                    DropdownButtonFormField(
                      decoration: const InputDecoration(
                        labelText: 'Excercise Body Part',
                      ),
                      items: const [
                        DropdownMenuItem(
                          value: BodyPart.chest,
                          child: Text('Chest'),
                        ),
                        DropdownMenuItem(
                          value: BodyPart.back,
                          child: Text('Back'),
                        ),
                        DropdownMenuItem(
                          value: BodyPart.shoulders,
                          child: Text('Shoulders'),
                        ),
                        DropdownMenuItem(
                          value: BodyPart.biceps,
                          child: Text('Biceps'),
                        ),
                        DropdownMenuItem(
                          value: BodyPart.triceps,
                          child: Text('Triceps'),
                        ),
                        DropdownMenuItem(
                          value: BodyPart.legs,
                          child: Text('Legs'),
                        ),
                        DropdownMenuItem(
                          value: BodyPart.abs,
                          child: Text('Abs'),
                        ),
                      ],
                      onChanged: (value) => {_bodyPart = value!},
                    ),
                  ],
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Cancel'),
                  ),
                  TextButton(
                    onPressed: () async {
                      bool status = await _pushExcercise(
                        _nameController.text,
                        _descriptionController.text,
                        _type,
                        _bodyPart,
                        context,
                      );

                      if (status) {
                        Navigator.pop(context);
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                                'Excercise already exists, or missing required fields'),
                          ),
                        );
                      }
                    },
                    child: const Text('Add'),
                  ),
                ],
              );
            },
          )),
    );
  }

  Future<bool> _pushExcercise(String name, String? description,
      ExcerciseType type, BodyPart bodyPart, BuildContext context) async {
    DatabaseService db = Provider.of<DatabaseService>(context, listen: false);

    if (name == '' || type == ExcerciseType.none || bodyPart == BodyPart.none) {
      return false;
    }
    if (await db.excerciseExists(name)) {
      return false;
    }

    description ??= '';

    Excercise excercise = Excercise(
      name: name,
      description: description,
      type: type,
      bodyPart: bodyPart,
    );

    await db.addExcercise(excercise);
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () => _addExcercise(context),
      child: const Icon(Icons.add),
    );
  }
}
