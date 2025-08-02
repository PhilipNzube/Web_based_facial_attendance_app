import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../controllers/manage_students_controller.dart';
import 'tables/student_data_source.dart';

void viewStudentData(int index, BuildContext context) {
  final student = Provider.of<ManageStudentController>(context, listen: false)
      .students[index];
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    useRootNavigator: true,
    builder: (context) {
      return SafeArea(
        child: Scaffold(
          appBar: AppBar(
            title: Text('Details for ${student.surname}'),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ),
          body: SingleChildScrollView(
            child: PaginatedDataTable(
              header: const Text('Student Details'),
              columns: const [
                DataColumn(label: Text('Field')),
                DataColumn(label: Text('Value')),
              ],
              source: StudentDataSource(student as Map<String, Object?>),
              rowsPerPage: 10,
            ),
          ),
        ),
      );
    },
  );
}
