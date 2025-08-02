import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../core/widgets/custom_gap.dart';
import '../../../../../data/models/school_model.dart';
import '../../../../controllers/manage_students_controller.dart';

void viewPassport(int index, BuildContext context) {
  final student = Provider.of<ManageStudentController>(context, listen: false)
      .students[index];
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text('Passport for ${student.surname}'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.file(File(student.passport)),
          const Gap(20),
          const Text('Passport Details:'),
          Text('Name: ${student.surname} ${student.firstname}'),
          Text(
              'School: ${Provider.of<ManageStudentController>(context, listen: false).schools.firstWhere((school) => school.id == student.schoolId, orElse: () => School(id: '', schoolName: '')).schoolName}'),
          Text('Class: ${student.presentLevel}'),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text('Close'),
        ),
      ],
    ),
  );
}
