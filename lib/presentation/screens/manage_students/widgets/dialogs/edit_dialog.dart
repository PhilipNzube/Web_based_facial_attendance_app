import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:facial_attendance/data/models/student_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import 'package:image_picker/image_picker.dart';
import 'package:facial_attendance/presentation/screens/manage_students/widgets/dialogs/select_school_dialog.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

import '../../../../../core/widgets/custom_gap.dart';
import '../../../../../core/widgets/custom_snackbar.dart';
import '../../../../../data/database/general_db/db_helper.dart';
import '../../../../../data/models/school_model.dart';
import '../../../../controllers/manage_students_controller.dart';
import 'package:image/image.dart' as img;

import '../../../register_student/widget/custom_dropdown.dart';
import '../../../register_student/widget/custom_text_field.dart';

void editStudentDialog(int index, BuildContext context) async {
  Provider.of<ManageStudentController>(context, listen: false)
      .setLoadSchoolsFuture(
          Provider.of<ManageStudentController>(context, listen: false)
              .syncAndLoadSchools()
              .then((schools) {
    Provider.of<ManageStudentController>(context, listen: false)
        .setSchools(schools); // Populate _schools
    return schools; // Explicitly return the schools list
  }));
  final student = Provider.of<ManageStudentController>(context, listen: false)
      .students[index];
  String? passportImg = student.passport as String?;
  Provider.of<ManageStudentController>(context, listen: false)
      .setSelectedSchool(student.schoolId);

  if (passportImg != null && passportImg.isNotEmpty) {
    Provider.of<ManageStudentController>(context, listen: false)
        .setPassportImage(File(passportImg));
  }

  // Extract individual fields
  String? currentState = student.stateOfOrigin;
  String? currentLga = student.lga;
  String? currentLgaOfEnrollment = student.lgaOfEnrollment;
  String? currentWard = student.ward;

// Fetch LGAs and wards for the student's state
  if (currentState != null) {
    final controller =
        Provider.of<ManageStudentController>(context, listen: false);
    controller.getStates();
    controller.getLgas(currentState);
    controller.getLgasOfEnrollment(currentState);

    if (currentLgaOfEnrollment != null) {
      controller.getWardsOfEnrollment(currentLgaOfEnrollment, currentState);
    }
  }

// Create controllers for each field and initialize them with student data
  final TextEditingController surnameController =
      TextEditingController(text: student.surname ?? '');
  final TextEditingController studentNinController =
      TextEditingController(text: student.studentNin ?? '');
  final TextEditingController _wardController =
      TextEditingController(text: currentWard ?? '');
  final TextEditingController _firstNameController =
      TextEditingController(text: student.firstname ?? '');
  final TextEditingController _middleNameController =
      TextEditingController(text: student.middlename ?? '');
  final TextEditingController genderController =
      TextEditingController(text: student.gender ?? '');
  final TextEditingController dobController =
      TextEditingController(text: student.dob ?? '');
  final TextEditingController nationalityController =
      TextEditingController(text: student.nationality ?? '');
  final TextEditingController stateOfOriginController =
      TextEditingController(text: student.stateOfOrigin ?? '');
  final TextEditingController lgaController =
      TextEditingController(text: currentLga ?? '');
  final TextEditingController lgaOfEnrollmentController =
      TextEditingController(text: currentLgaOfEnrollment ?? '');
  final TextEditingController communityNameController =
      TextEditingController(text: student.communityName ?? '');
  final TextEditingController residentialAddressController =
      TextEditingController(text: student.residentialAddress ?? '');
  final TextEditingController presentClassController =
      TextEditingController(text: student.presentLevel ?? '');
  final TextEditingController yearOfEnrollmentController =
      TextEditingController(text: student.yearOfEnrollment?.toString() ?? '');
  final TextEditingController parentContactController =
      TextEditingController(text: student.parentContact ?? '');
  final TextEditingController parentOccupationController =
      TextEditingController(text: student.parentOccupation ?? '');
  final TextEditingController parentPhoneController =
      TextEditingController(text: student.parentPhone ?? '');
  final TextEditingController parentNameController =
      TextEditingController(text: student.parentName ?? '');
  final TextEditingController parentNinController =
      TextEditingController(text: student.parentNin ?? '');
  final TextEditingController parentBvnController =
      TextEditingController(text: student.parentBvn ?? '');
  final TextEditingController bankNameController =
      TextEditingController(text: student.bankName ?? '');
  final TextEditingController accountNumberController =
      TextEditingController(text: student.accountNumber ?? '');
  final TextEditingController passportController =
      TextEditingController(text: student.passport ?? '');

// Dropdown values
  String? _selectedGender = student.gender ?? 'Female';
  String? _selectedNationality = student.nationality ?? 'Nigeria';
  String? _selectedState = student.stateOfOrigin;
  String? _selectedLga = student.lga;
  String? _selectedLgaOfEnrollment = student.lgaOfEnrollment;
  String? _selectedPresentLevel = student.presentLevel;
  String? _selectedDepartment = student.department;
  String? _selectedYearOfEnrollment = student.yearOfEnrollment;
  String? _selectedParentOccupation = student.parentOccupation;
  String? _selectedBank = student.bankName;
  String? _selectedDisabilityStatus = 'No';

  print(
      '${lgaOfEnrollmentController.text}, $currentState, $currentLga, $currentLgaOfEnrollment, $currentWard');

  showDialog(
    context: context,
    builder: (context) => FutureBuilder<List<School>>(
        future: Provider.of<ManageStudentController>(context, listen: false)
            .loadSchoolsFuture,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(
                child: CircularProgressIndicator(color: Colors.black));
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
                child: CircularProgressIndicator(color: Colors.black));
          } else if (snapshot.hasError) {
            return AlertDialog(
              title: Text('Error'),
              content: Text('Failed to load schools. Please try again later.'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text('OK'),
                ),
              ],
            );
          } else {
            return StatefulBuilder(
              builder: (context, setState) {
                String currentSchoolName =
                    Provider.of<ManageStudentController>(context, listen: false)
                        .schools
                        .firstWhere(
                          (school) =>
                              school.id ==
                              Provider.of<ManageStudentController>(context,
                                      listen: false)
                                  .selectedSchool,
                          orElse: () =>
                              School(id: '', schoolName: 'Unknown School'),
                        )
                        .schoolName;

                return AlertDialog(
                  title: Text('Edit ${student.surname}'),
                  content: SingleChildScrollView(
                    child: Form(
                      key: Provider.of<ManageStudentController>(context,
                              listen: false)
                          .formKey, // Use the GlobalKey here
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Gap(10),
                          CustomTextField(
                            controller: surnameController,
                            label: 'Surname',
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter surname';
                              }
                              return null;
                            },
                          ),
                          const Gap(10),
                          CustomTextField(
                            controller: _firstNameController,
                            label: 'Firstname',
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter firstname';
                              }
                              return null;
                            },
                          ),
                          const Gap(10),
                          CustomTextField(
                            controller: _middleNameController,
                            label: 'Middlename',
                          ),
                          const Gap(10),
                          CustomDropdown<String>(
                            value: _selectedPresentLevel,
                            label: 'Present Level',
                            items: const [
                              '100 Level',
                              '200 Level',
                              '300 Level',
                              '400 Level'
                            ],
                            onChanged: (value) {
                              setState(() {
                                _selectedPresentLevel = value!;
                              });
                            },
                            validator: (value) {
                              if (value == null) {
                                return 'Please select a present class';
                              }
                              return null;
                            },
                          ),
                          const Gap(10),
                          CustomDropdown<String>(
                            value: _selectedDepartment,
                            label: 'Department',
                            items: const [
                              'Computer Science',
                              'Mathematics',
                              'Statistics',
                              'Physics'
                            ],
                            onChanged: (value) {
                              setState(() {
                                _selectedDepartment = value!;
                              });
                            },
                            validator: (value) {
                              if (value == null) {
                                return 'Please select a department';
                              }
                              return null;
                            },
                          ),
                          const Gap(10),
                          Consumer<ManageStudentController>(
                            builder: (context, controller, child) {
                              return GestureDetector(
                                onTap: () {
                                  showDialog(
                                    context: context,
                                    builder: (dialogContext) => AlertDialog(
                                      title:
                                          const Text('Upload Passport Photo'),
                                      content:
                                          const Text('Please select an option'),
                                      actions: [
                                        TextButton(
                                          onPressed: () {
                                            controller.pickImgFromGallery(
                                                dialogContext, context);
                                          },
                                          child:
                                              const Text('Select from Gallery'),
                                        ),
                                        TextButton(
                                          onPressed: () {
                                            controller.takeNewPhoto(
                                                dialogContext, context);
                                          },
                                          child: const Text('Take a New Photo'),
                                        ),
                                        TextButton(
                                          onPressed: () {
                                            Navigator.of(dialogContext).pop();
                                          },
                                          child: const Text('Cancel'),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                                child: Container(
                                  width: double.infinity,
                                  height: 180,
                                  margin:
                                      const EdgeInsets.symmetric(vertical: 10),
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Colors.grey),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      if (controller.passportImageBytes ==
                                          null) ...[
                                        const Icon(Icons.photo,
                                            size: 50, color: Colors.grey),
                                        const SizedBox(height: 10),
                                        const Text(
                                          'Upload Passport Photo',
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold),
                                          textAlign: TextAlign.center,
                                        ),
                                      ] else ...[
                                        SizedBox(
                                          height: 80,
                                          width: 80,
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(8),
                                            child: Image.memory(
                                              controller.passportImageBytes!,
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        const Text(
                                          'Passport photo uploaded',
                                          style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.green),
                                        ),
                                        TextButton(
                                          onPressed: () {
                                            controller
                                                .setPassportImageBytes(null);
                                            student.passport = '';
                                          },
                                          child: const Text(
                                            'Delete Passport',
                                            style: TextStyle(color: Colors.red),
                                          ),
                                        ),
                                      ],
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () async {
                        final formValid = Provider.of<ManageStudentController>(
                                context,
                                listen: false)
                            .formKey
                            .currentState!
                            .validate();

                        if (!formValid) return;

                        final controller = Provider.of<ManageStudentController>(
                            context,
                            listen: false);

                        if (controller.passportImageBytes == null) {
                          CustomSnackbar.show(
                            context,
                            'Please upload a passport photo',
                            isError: true,
                          );
                          return;
                        }

                        final studentBox =
                            await Hive.openBox<Student>('students');
                        final student = controller.students[index];
                        final base64Passport =
                            base64Encode(controller.passportImageBytes!);

                        // Update student object fields
                        student.surname = surnameController.text;
                        student.firstname = _firstNameController.text;
                        student.middlename = _middleNameController.text;
                        student.presentLevel = _selectedPresentLevel!;
                        student.department = _selectedDepartment!;
                        student.passport = base64Passport;
                        student.status = 0;
                        // You can also update passport/cloudinaryUrl if changed:
                        // student.passport = updatedPassport;
                        // student.cloudinaryUrl = updatedUrl;

                        await student.save(); // Save changes to Hive box

                        await controller.loadStudents(); // Refresh list
                        Navigator.of(context).pop();
                      },
                      child: const Text('Save'),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text('Cancel'),
                    ),
                  ],
                );
              },
            );
          }
        }),
  );
}
