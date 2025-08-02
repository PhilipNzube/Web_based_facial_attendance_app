import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../controllers/register_student_controller.dart';

void selectLGA(BuildContext context) async {
  List<String> uniqueLGAs =
      Provider.of<RegisterStudentController>(context, listen: false)
          .schools
          .map((school) => school.lga!)
          .fold<Map<String, String>>({}, (map, lga) {
            map[lga.toLowerCase()] = lga;
            return map;
          })
          .values
          .toList();

  List<String> displayedLGAs = List.from(uniqueLGAs);

  await showDialog(
    context: context,
    builder: (context) => StatefulBuilder(
      builder: (context, setState) {
        return AlertDialog(
          title: const Text(
            'Select LGA',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          content: SizedBox(
            height: 200,
            child: Column(
              children: [
                TextField(
                  decoration: const InputDecoration(
                    labelText: 'Search LGAs',
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (value) {
                    setState(() {
                      displayedLGAs = uniqueLGAs
                          .where((lga) =>
                              lga.toLowerCase().contains(value.toLowerCase()))
                          .toList();
                    });
                  },
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: displayedLGAs.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(
                          displayedLGAs[index],
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        onTap: () {
                          Provider.of<RegisterStudentController>(context,
                                  listen: false)
                              .setSelectedLGA(displayedLGAs[index]);
                          Provider.of<RegisterStudentController>(context,
                                  listen: false)
                              .setIsLGASelected(true);

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
