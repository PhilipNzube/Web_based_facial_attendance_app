import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../data/models/school_model.dart';
import '../../../../controllers/manage_students_controller.dart';

void selectSchool(
    Function(String?) onSchoolSelected, BuildContext context) async {
  List<School> _filteredSchools =
      Provider.of<ManageStudentController>(context, listen: false).schools;
  print(
      'Total schools: ${Provider.of<ManageStudentController>(context, listen: false).schools.length}');
  await showDialog(
    context: context,
    builder: (context) => StatefulBuilder(
      builder: (context, setState) {
        return AlertDialog(
          title: const Text(
            'Select School',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          content: SizedBox(
            height: 200,
            child: Column(
              children: [
                TextField(
                  decoration: const InputDecoration(
                    labelText: 'Search Schools',
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (value) {
                    setState(() {
                      _filteredSchools = Provider.of<ManageStudentController>(
                              context,
                              listen: false)
                          .schools
                          .where((school) => school.schoolName
                              .toLowerCase()
                              .contains(value.toLowerCase()))
                          .toList();
                    });
                  },
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: _filteredSchools.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(
                          _filteredSchools[index].schoolName,
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        onTap: () {
                          // Call the callback function with the selected school ID
                          onSchoolSelected(_filteredSchools[index].id);
                          Navigator.of(context).pop(); // Close the dialog
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
          ],
        );
      },
    ),
  );
}
