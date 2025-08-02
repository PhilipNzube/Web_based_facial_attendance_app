import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../controllers/manage_students_controller.dart';
import '../view_student_data_bottom_sheet.dart';
import 'collect_attendance_data.dart';

void confirmViewData(BuildContext context, int studentIndex) {
  final student = Provider.of<ManageStudentController>(context, listen: false)
      .students[studentIndex]; // Get the student object from the list

  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Student Actions'),
      content: Text(
        'What would you like to do with ${student.surname.toString().trim()} ${student.firstname.toString().trim()}\'s data?',
      ),
      actions: [
        // Option 1: View Student Data
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(); // Close the dialog
            viewStudentData(
                studentIndex, context); // Method to view student data
          },
          child: const Text('View Student Data'),
        ),

        // Option 2: Verify Student using Facial Matching
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(); // Close the dialog
            //collectAttendanceData(context, studentIndex);
            Provider.of<ManageStudentController>(context, listen: false)
                .verifyStudent(studentIndex,
                    context); // Method to verify the student via facial matching
          },
          child: const Text('Take Student Attendance'),
        ),
      ],
    ),
  );
}
