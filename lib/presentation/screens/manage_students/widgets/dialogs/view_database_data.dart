import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as path;

void viewDatabaseData(BuildContext context) async {
  final database = await openDatabase(
    path.join(await getDatabasesPath(), 'students.db'),
    version: 1,
  );
  final students = await database.rawQuery('SELECT * FROM students');
  String data = '';
  for (var student in students) {
    data += 'Surname: ${student['surname']}\n';
    data += 'Student NIN: ${student['studentNin']}\n';
    data += 'Ward: ${student['ward']}\n';
    data += 'Other Names: ${student['otherNames']}\n';
    data += 'Gender: ${student['gender']}\n';
    data += 'Date of Birth: ${student['dob']}\n';
    data += 'Nationality: ${student['nationality']}\n';
    data += 'State of Origin: ${student['stateOfOrigin']}\n';
    data += 'LGA: ${student['lga']}\n';
    data += 'LGA of Enrollment: ${student['lgaOfEnrollment']}\n';
    data += 'Community Name: ${student['communityName']}\n';
    data += 'Residential Address: ${student['residentialAddress']}\n';
    data += 'Present Class: ${student['presentClass']}\n';
    data += 'Year of Enrollment: ${student['yearOfEnrollment']}\n';
    data += 'Parent Contact: ${student['parentContact']}\n';
    data += 'Parent Occupation: ${student['parentOccupation']}\n';
    data += 'Parent Phone: ${student['parentPhone']}\n';
    data += 'Parent Name: ${student['parentName']}\n';
    data += 'Parent NIN: ${student['parentNin']}\n';
    data += 'Parent BVN: ${student['parentBvn']}\n'; // Added Parent BVN
    data += 'Bank Name: ${student['bankName']}\n';
    data += 'Account Number: ${student['accountNumber']}\n';
    data += 'Passport: ${student['passport']}\n';
    data += 'Cloudinary URL: ${student['cloudinaryUrl']}\n';
    data += 'Created By: ${student['createdBy']}\n\n'; // Added Created By
  }
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text('Database Data'),
      content: Text(data),
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
