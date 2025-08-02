import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../../../../../data/database/general_db/db_helper.dart';
import '../../../../controllers/manage_students_controller.dart';

void editPassport(int index, BuildContext context) async {
  final student = Provider.of<ManageStudentController>(context, listen: false)
      .students[index];
  String? originalPassport = student.passport as String?;
  File _passportImage = File('');

  showDialog(
    context: context,
    builder: (context) => StatefulBuilder(
      builder: (context, setState) {
        return AlertDialog(
            title: Text('Edit Passport for ${student.surname}'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: double.infinity,
                  height: 200,
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (_passportImage.path.isNotEmpty)
                        Image.file(_passportImage)
                      else if (student.passport != '')
                        Image.file(File(student.passport))
                      else
                        Icon(Icons.person),
                      if (_passportImage.path.isNotEmpty)
                        TextButton(
                          onPressed: () {
                            setState(() {
                              _passportImage = File('');
                            });
                          },
                          child: Text('Delete Passport'),
                        ),
                      TextButton(
                        onPressed: () async {
                          final pickedFile = await ImagePicker().getImage(
                            source: ImageSource.gallery,
                          );
                          if (pickedFile != null) {
                            setState(() {
                              _passportImage = File(pickedFile.path);
                            });
                          }
                        },
                        child: Text('Select from Gallery'),
                      ),
                      TextButton(
                        onPressed: () async {
                          final pickedFile = await ImagePicker().getImage(
                            source: ImageSource.camera,
                          );
                          if (pickedFile != null) {
                            setState(() {
                              _passportImage = File(pickedFile.path);
                            });
                          }
                        },
                        child: Text('Take a New Photo'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () async {
                  String? newPassportUrl;

                  if (student.passport != originalPassport) {
                    final controller = Provider.of<ManageStudentController>(
                        context,
                        listen: false);

                    if (await controller.hasInternet()) {
                      newPassportUrl = await controller.uploadImage(
                          _passportImage, student.randomId);

                      student.cloudinaryUrl =
                          newPassportUrl; // Update Cloudinary URL
                    } else {
                      print(
                          'No internet connection. Image will be uploaded later.');
                    }

                    // Update passport path
                    student.passport = _passportImage.path;

                    // Save changes to Hive
                    await student.save();

                    // Refresh list
                    await controller.loadStudents();
                    Navigator.of(context).pop();
                  } else {
                    // No changes made, just close the dialog
                    Navigator.of(context).pop();
                  }
                },
                child: const Text('Save'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('Cancel'),
              ),
            ]);
      },
    ),
  );
}
