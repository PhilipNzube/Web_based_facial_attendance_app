import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../controllers/manage_students_controller.dart';

void confirmUploadData(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Upload Data'),
      content: const Text(
        'Would you like to upload data that hasn’t been changed, '
        'or reset the status and upload all data?',
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(); // Close the dialog
            Provider.of<ManageStudentController>(context, listen: false)
                .sendDataToMongoDB(context); // Upload unchanged data
          },
          child: const Text('Upload Data'),
        ),
        TextButton(
          onPressed: () {
            Provider.of<ManageStudentController>(context, listen: false)
                .resetAllData(context);
          },
          child: const Text('Reset All Data'),
        ),
      ],
    ),
  );
}
