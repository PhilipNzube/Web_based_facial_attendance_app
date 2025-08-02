import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../controllers/attendance_controller.dart';

class AttendancePage extends StatefulWidget {
  AttendancePage({super.key});

  @override
  _AttendancePageState createState() => _AttendancePageState();
}

class _AttendancePageState extends State<AttendancePage> {
  @override
  Widget build(BuildContext context) {
    final attendanceController = Provider.of<AttendanceController>(context);
    final List<Map<String, dynamic>> filteredStudents = attendanceController
        .students
        .where((student) => student['status'] == 1)
        .toList();
    return Scaffold(
      appBar: AppBar(
        title: Text('Attendance List'),
        actions: [
          IconButton(
            icon: Icon(Icons.picture_as_pdf),
            onPressed: () => attendanceController.generatePDF(context),
          ),
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: attendanceController.refreshPage,
          ),
        ],
      ),
      body: attendanceController.isLoading
          ? Center(child: CircularProgressIndicator(color: Color(0xFF637725)))
          : SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                columns: [
                  DataColumn(label: Text('Name')),
                  DataColumn(label: Text('Level')),
                  DataColumn(label: Text('Department')),
                ],
                rows: filteredStudents.map((student) {
                  return DataRow(cells: [
                    DataCell(Text(
                        '${student['surname']?.toString().trim() ?? ''} ${student['firstname']}')),
                    DataCell(Text(student['presentLevel'])),
                    DataCell(Text(student['department'])),
                  ]);
                }).toList(),
              ),
            ),
    );
  }
}
