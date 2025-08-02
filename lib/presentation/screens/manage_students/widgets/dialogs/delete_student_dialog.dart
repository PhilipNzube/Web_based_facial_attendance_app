import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';

import '../../../../controllers/manage_students_controller.dart';

void deleteStudent(int index, BuildContext context) async {
  final controller =
      Provider.of<ManageStudentController>(context, listen: false);
  final student = controller.students[index];

  //final studentsBox = Hive.box('students');
  print("$student");

  await showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text('Delete Student'),
      content: Text('Are you sure you want to delete ${student.surname}?'),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text('Cancel'),
        ),
        TextButton(
          onPressed: () async {
            await student.delete();

            // Reload list from Hive (assuming this updates the controller's `students`)
            await controller.loadStudents();

            Navigator.of(context).pop();
          },
          child: Text('Delete'),
        ),
      ],
    ),
  );
}
