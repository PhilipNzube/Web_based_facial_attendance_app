import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../controllers/register_student_controller.dart';

void selectSchool(BuildContext context) async {
  // Fetch the selected school category
  String selectedSchoolCategory =
      Provider.of<RegisterStudentController>(context, listen: false)
          .selectedSchoolCategory!;

  // Create a map of unique schools (ID -> Name) to prevent duplicates
  Map<String, String> uniqueSchools =
      Provider.of<RegisterStudentController>(context, listen: false)
          .schools
          .where((school) => school.schoolCategory == selectedSchoolCategory)
          .fold<Map<String, String>>({}, (map, school) {
    map[school.id] = school.schoolName; // Store ID -> Name mapping
    return map;
  });

  List<MapEntry<String, String>> displayedSchools =
      uniqueSchools.entries.toList();

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
                      displayedSchools = uniqueSchools.entries
                          .where((entry) => entry.value
                              .toLowerCase()
                              .contains(value.toLowerCase()))
                          .toList();
                    });
                  },
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: displayedSchools.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(
                          displayedSchools[index].value,
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        onTap: () {
                          String selectedId = displayedSchools[index].key;
                          String selectedName = displayedSchools[index].value;

                          Provider.of<RegisterStudentController>(context,
                                  listen: false)
                              .setSelectedSchool(selectedId);
                          Provider.of<RegisterStudentController>(context,
                                  listen: false)
                              .setSelectedSchoolName(selectedName);
                          Provider.of<RegisterStudentController>(context,
                                  listen: false)
                              .setSchoolSelected(true);

                          Navigator.of(context).pop(); // Close dialog
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
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    ),
  ).then((_) {
    Provider.of<RegisterStudentController>(context, listen: false)
        .notifyListenersCall();
  });
}
