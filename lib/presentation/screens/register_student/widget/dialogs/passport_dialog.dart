import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../controllers/register_student_controller.dart';

void showPassportDialog(BuildContext rootContext) {
  showModalBottomSheet(
    context: rootContext,
    builder: (BuildContext dialogContext) {
      final controller =
          Provider.of<RegisterStudentController>(dialogContext, listen: false);
      return Wrap(
        children: [
          ListTile(
            leading: const Icon(Icons.photo),
            title: const Text('Select from Gallery'),
            onTap: () =>
                controller.pickImgFromGallery(dialogContext, rootContext),
          ),
          ListTile(
            leading: const Icon(Icons.camera_alt),
            title: const Text('Take Photo'),
            onTap: () => controller.takeNewPhoto(dialogContext, rootContext),
          ),
        ],
      );
    },
  );
}
