import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../controllers/manage_students_controller.dart';

void selectSchoolCategory(BuildContext context) async {
  // Fetch the selected LGA
  String selectedLGA =
      Provider.of<ManageStudentController>(context, listen: false).selectedLGA!;

  // Get unique school types under the selected LGA
  List<String> uniqueSchoolCategory =
      Provider.of<ManageStudentController>(context, listen: false)
          .schools
          .where((school) => school.lga == selectedLGA)
          .map((school) => school.schoolCategory!.trim())
          .fold<Map<String, String>>({}, (map, category) {
            map[category.toLowerCase()] = category;
            return map;
          })
          .values
          .toList();

  List<String> displayedTypes = List.from(uniqueSchoolCategory);

  await showDialog(
    context: context,
    builder: (context) => StatefulBuilder(
      builder: (context, setState) {
        return AlertDialog(
          title: const Text(
            'Select School Category',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          content: SizedBox(
            height: 200,
            child: Column(
              children: [
                TextField(
                  decoration: const InputDecoration(
                    labelText: 'Search School Category',
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (value) {
                    setState(() {
                      displayedTypes = uniqueSchoolCategory
                          .where((type) =>
                              type.toLowerCase().contains(value.toLowerCase()))
                          .toList();
                    });
                  },
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: displayedTypes.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(
                          displayedTypes[index],
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        onTap: () {
                          // Set the selected school type
                          Provider.of<ManageStudentController>(context,
                                  listen: false)
                              .setSelectedSchoolCategory(displayedTypes[index]);
                          Provider.of<ManageStudentController>(context,
                                  listen: false)
                              .setIsSchoolCategorySelected(true);

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
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    ),
  ).then((_) {
    Provider.of<ManageStudentController>(context, listen: false)
        .notifyListenersCall();
  });
}
