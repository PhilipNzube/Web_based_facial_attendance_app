import 'package:flutter/material.dart';

class StudentDataSource extends DataTableSource {
  final Map<String, Object?> student;

  StudentDataSource(this.student);

  final Map<String, String> fieldToKeyMap = {
    'Surname': 'surname',
    'Firstname': 'firstname',
    'Middlename': 'middlename',
    'Present Level': 'presentLevel',
    'Department': 'department',
  };

  @override
  DataRow getRow(int index) {
    if (index >= fieldToKeyMap.length) return DataRow(cells: []);

    final field = fieldToKeyMap.keys.elementAt(index);
    final key = fieldToKeyMap[field]!;
    final value = student[key]?.toString() ?? '';

    return DataRow(cells: [
      DataCell(Text(field)),
      DataCell(Text(value)),
    ]);
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => fieldToKeyMap.length;

  @override
  int get selectedRowCount => 0;
}
