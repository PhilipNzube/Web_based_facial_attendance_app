import 'package:facial_attendance/data/models/student_model.dart';
import 'package:flutter/material.dart';

class StudentDataSource extends DataTableSource {
  final Student student;

  StudentDataSource(this.student);

  final Map<String, String Function(Student)> fieldToValueMap = {
    'Surname': (s) => s.surname,
    'Firstname': (s) => s.firstname,
    'Middlename': (s) => s.middlename,
    'Present Level': (s) => s.presentLevel,
    'Department': (s) => s.department,
    // Add more fields here as needed
  };

  @override
  DataRow getRow(int index) {
    if (index >= fieldToValueMap.length) return DataRow(cells: []);

    final field = fieldToValueMap.keys.elementAt(index);
    final value = fieldToValueMap[field]!(student);

    return DataRow(cells: [
      DataCell(Text(field)),
      DataCell(Text(value)),
    ]);
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => fieldToValueMap.length;

  @override
  int get selectedRowCount => 0;
}
