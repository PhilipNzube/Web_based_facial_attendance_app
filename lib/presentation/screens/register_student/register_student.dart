import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart'
    show FilteringTextInputFormatter, Uint8List, rootBundle;
import 'package:provider/provider.dart';
import 'package:path/path.dart' as path;
import '../../../core/widgets/custom_background.dart';
import '../../../core/widgets/custom_gap.dart';
import '../../../core/widgets/custom_snackbar.dart';
import '../../../data/models/school_model.dart';
import '../../controllers/register_student_controller.dart';
import 'widget/custom_dropdown.dart';
import 'widget/custom_text_field.dart';
import 'widget/dialogs/passport_dialog.dart';
import 'widget/dialogs/select_lga_dialog.dart';
import 'widget/dialogs/select_school_dialog.dart';
import 'widget/dialogs/select_school_type_dialog.dart';

class RegisterStudent extends StatefulWidget {
  final Function syncingSchools;
  const RegisterStudent({super.key, required this.syncingSchools});

  @override
  State<RegisterStudent> createState() => _RegisterStudentState();
}

class _RegisterStudentState extends State<RegisterStudent> {
  @override
  Widget build(BuildContext context) {
    final registerStudentController =
        Provider.of<RegisterStudentController>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Registration Form'),
      ),
      body: Stack(
        children: [
          const Background(),
          Padding(
            padding: const EdgeInsets.only(top: 10, bottom: 10),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.9),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: SingleChildScrollView(
                  child: Form(
                    key: registerStudentController.formKey,
                    child: Column(
                      children: [
                        // Text(
                        //   'Registration form of students from ${_schools.firstWhere((school) => school.id == _selectedSchool).schoolName}',
                        // ),
                        const Gap(20),
                        CustomTextField(
                          controller:
                              registerStudentController.surnameController,
                          label: 'Surname',
                          validator: (value) =>
                              value!.isEmpty ? 'Please enter surname' : null,
                        ),
                        const Gap(20),
                        CustomTextField(
                          controller:
                              registerStudentController.firstNameController,
                          label: 'Firstname',
                          validator: (value) =>
                              value!.isEmpty ? 'Please enter firstname' : null,
                        ),

                        const Gap(20),
                        CustomTextField(
                          controller:
                              registerStudentController.middleNameController,
                          label: 'Middlename',
                        ),

                        const Gap(20),

                        CustomDropdown<String>(
                          value: registerStudentController.selectedPresentLevel,
                          label: 'Present Level',
                          items: const [
                            '100 Level',
                            '200 Level',
                            '300 Level',
                            '400 Level'
                          ],
                          onChanged: (value) {
                            registerStudentController
                                .setSelectedPresentLevel(value!);
                          },
                          validator: (value) {
                            if (value == null) {
                              return 'Please select a present level';
                            }
                            return null;
                          },
                        ),

                        const Gap(20),

                        CustomDropdown<String>(
                          value: registerStudentController.selectedDepartment,
                          label: 'Department',
                          items: const [
                            'Computer Science',
                            'Mathematics',
                            'Statistics',
                            'Physics'
                          ],
                          onChanged: (value) {
                            registerStudentController
                                .setSelectedDepartment(value!);
                          },
                          validator: (value) {
                            if (value == null) {
                              return 'Please select a department';
                            }
                            return null;
                          },
                        ),

                        const Gap(20),

                        GestureDetector(
                          onTap: () {
                            showPassportDialog(context);
                          },
                          child: Container(
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
                                const Text(
                                  'Upload Passport Photo',
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                ),
                                if (registerStudentController
                                        .passportImageBytes !=
                                    null) ...[
                                  const SizedBox(height: 10),

                                  // Image Preview
                                  SizedBox(
                                    height: 80,
                                    width: 80,
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(8),
                                      child: Image.memory(
                                        registerStudentController
                                            .passportImageBytes!,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),

                                  const SizedBox(height: 5),

                                  const Text(
                                    'Passport uploaded',
                                    style: TextStyle(
                                        fontSize: 14, color: Colors.grey),
                                  ),

                                  TextButton(
                                    onPressed: () {
                                      registerStudentController
                                          .setPassportImageBytes(null);
                                    },
                                    child: const Text(
                                      'Delete Passport',
                                      style: TextStyle(color: Colors.red),
                                    ),
                                  ),
                                ]
                              ],
                            ),
                          ),
                        ),
                        const Gap(20),
                        Container(
                          width: double.infinity,
                          height: 60,
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          child: ElevatedButton(
                            onPressed: registerStudentController.isLoading
                                ? null
                                : () {
                                    if (registerStudentController
                                            .passportImageBytes ==
                                        null) {
                                      CustomSnackbar.show(
                                        context,
                                        'Please upload a passport photo',
                                        isError: true,
                                      );

                                      return;
                                    }

                                    if (registerStudentController
                                        .formKey.currentState!
                                        .validate()) {
                                      registerStudentController
                                          .insertData(context);
                                    }
                                  },
                            style: ButtonStyle(
                              backgroundColor:
                                  WidgetStateProperty.resolveWith<Color>(
                                (Set<WidgetState> states) {
                                  if (states.contains(WidgetState.pressed)) {
                                    return Colors.white;
                                  }
                                  return const Color(0xFFF76800);
                                },
                              ),
                              foregroundColor:
                                  WidgetStateProperty.resolveWith<Color>(
                                (Set<WidgetState> states) {
                                  if (states.contains(WidgetState.pressed)) {
                                    return const Color(0xFFF76800);
                                  }
                                  return Colors.white;
                                },
                              ),
                              elevation: WidgetStateProperty.all<double>(4.0),
                              shape: WidgetStateProperty.all<
                                  RoundedRectangleBorder>(
                                const RoundedRectangleBorder(
                                  side: BorderSide(
                                    width: 3,
                                    color: Color(0xFFF76800),
                                  ),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(15)),
                                ),
                              ),
                            ),
                            child: registerStudentController.isLoading
                                ? const CircularProgressIndicator(
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                        Colors.white))
                                : const Text(
                                    'Register',
                                    style: TextStyle(
                                      fontFamily: 'Inter',
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
