import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/widgets/custom_gap.dart';
import '../../controllers/manage_students_controller.dart';
import 'widgets/dialogs/confirm_upload_data_dialog.dart';
import 'widgets/dialogs/confirm_view_data_dialog.dart';
import 'widgets/dialogs/delete_student_dialog.dart';
import 'widgets/dialogs/edit_dialog.dart';

class ManageStudents extends StatefulWidget {
  const ManageStudents({super.key});

  @override
  State<ManageStudents> createState() => _ManageStudentsState();
}

class _ManageStudentsState extends State<ManageStudents> {
  @override
  Widget build(BuildContext context) {
    final manageStudentController =
        Provider.of<ManageStudentController>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Students'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: manageStudentController.loadStudents,
          ),
          // Padding(
          //   padding: const EdgeInsets.only(right: 10),
          //   child: TextButton(
          //     onPressed: () {
          //       manageStudentController.syncDataFromMongoDBPaginated(context);
          //     },
          //     style: TextButton.styleFrom(
          //       foregroundColor: Colors.white,
          //       backgroundColor: const Color(
          //           0xFF637725), // You can change this to any color you want
          //       shape: RoundedRectangleBorder(
          //         borderRadius: BorderRadius.circular(10),
          //       ),
          //     ),
          //     child: const Row(
          //       children: [
          //         Icon(Icons.download_rounded, color: Colors.white, size: 24),
          //       ],
          //     ),
          //   ),
          // ),
        ],
      ),
      body: manageStudentController.isLoading
          ? const Center(child: CircularProgressIndicator(color: Colors.white))
          : Container(
              decoration: BoxDecoration(
                image: const DecorationImage(
                  image: AssetImage("images/landing-agile.jpg"),
                  fit: BoxFit.cover,
                ),
                gradient: LinearGradient(
                  colors: [
                    Colors.white.withOpacity(0.5),
                    Colors.white.withOpacity(0.2),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              child: Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  Column(
                    children: [
                      Expanded(
                        child: manageStudentController.students.isEmpty
                            ? const Center(
                                child: Text(
                                  'No students found.',
                                  style: TextStyle(
                                      fontSize: 24, color: Colors.white),
                                ),
                              )
                            : ListView.builder(
                                controller:
                                    manageStudentController.scrollController,
                                itemCount:
                                    manageStudentController.students.length,
                                itemBuilder: (context, index) {
                                  final base64 = manageStudentController
                                      .students[index].passport;

                                  final imageBytes = base64Decode(base64);
                                  return Card(
                                    elevation: 5,
                                    child: ListTile(
                                      leading: manageStudentController
                                                  .students[index].passport !=
                                              ''
                                          ? manageStudentController
                                                  .students[index].passport
                                                  .toString()
                                                  .startsWith('http')
                                              ? ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(35),
                                                  child: Container(
                                                    width: (50 /
                                                            MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width) *
                                                        MediaQuery.of(context)
                                                            .size
                                                            .width,
                                                    height: (50 /
                                                            MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .height) *
                                                        MediaQuery.of(context)
                                                            .size
                                                            .height,
                                                    decoration: BoxDecoration(
                                                      shape: BoxShape.circle,
                                                      border: Border.all(
                                                        color: const Color(
                                                            0xFF500450),
                                                        width: 1.0,
                                                      ),
                                                    ),
                                                    child: Image.network(
                                                      manageStudentController
                                                          .students[index]
                                                          .passport,
                                                      fit: BoxFit.cover,
                                                      errorBuilder: (context,
                                                          error, stackTrace) {
                                                        return const Icon(
                                                            Icons.broken_image);
                                                      },
                                                    ),
                                                  ),
                                                )
                                              : ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(35),
                                                  child: Container(
                                                    width: (50 /
                                                            MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width) *
                                                        MediaQuery.of(context)
                                                            .size
                                                            .width,
                                                    height: (50 /
                                                            MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .height) *
                                                        MediaQuery.of(context)
                                                            .size
                                                            .height,
                                                    decoration: BoxDecoration(
                                                      shape: BoxShape.circle,
                                                      border: Border.all(
                                                        color: const Color(
                                                            0xFF500450),
                                                        width: 1.0,
                                                      ),
                                                    ),
                                                    child: Image.memory(
                                                      imageBytes,
                                                      fit: BoxFit.cover,
                                                      errorBuilder: (context,
                                                          error, stackTrace) {
                                                        return const Icon(
                                                            Icons.broken_image);
                                                      },
                                                    ),
                                                  ),
                                                )
                                          : ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(35),
                                              child: Container(
                                                width: (50 /
                                                        MediaQuery.of(context)
                                                            .size
                                                            .width) *
                                                    MediaQuery.of(context)
                                                        .size
                                                        .width,
                                                height: (50 /
                                                        MediaQuery.of(context)
                                                            .size
                                                            .height) *
                                                    MediaQuery.of(context)
                                                        .size
                                                        .height,
                                                decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  border: Border.all(
                                                    color:
                                                        const Color(0xFF500450),
                                                    width: 1.0,
                                                  ),
                                                ),
                                                child: const Icon(Icons.person),
                                              ),
                                            ),
                                      title: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Expanded(
                                            child: Text(
                                              '${manageStudentController.students[index].surname.toString().trim()} ${manageStudentController.students[index].firstname}',
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.bold),
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 1,
                                            ),
                                          ),
                                        ],
                                      ),
                                      subtitle: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Level: ${manageStudentController.students[index].presentLevel}',
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 1,
                                          ),
                                          manageStudentController
                                                      .students[index].status ==
                                                  0
                                              ? const Text(
                                                  'Unverified',
                                                  style: TextStyle(
                                                      color: Colors.red,
                                                      fontSize: 12),
                                                )
                                              : const Text(
                                                  'Verified',
                                                  style: TextStyle(
                                                      color: Colors.green,
                                                      fontSize: 12),
                                                ),
                                        ],
                                      ),
                                      onTap: () =>
                                          confirmViewData(context, index),
                                      //_viewStudentData(index),
                                      trailing: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          // manageStudentController
                                          //                 .students[index]
                                          //             ['status'] ==
                                          //         0
                                          //     ? const Icon(Icons.error,
                                          //         color: Colors.red)
                                          //     : const Icon(Icons.check_circle,
                                          //         color: Colors.green),
                                          IconButton(
                                            icon: const Icon(Icons.edit),
                                            onPressed: () => editStudentDialog(
                                                index, context),
                                          ),
                                          // if (manageStudentController
                                          //         .students[index]['status'] ==
                                          //     0)
                                          IconButton(
                                            icon: const Icon(Icons.delete,
                                                color: Colors.red),
                                            onPressed: () =>
                                                deleteStudent(index, context),
                                          ),
                                          // const IconButton(
                                          //   icon: const Icon(Icons.verified,
                                          //       color: Colors.green),
                                          //   onPressed: null,
                                          // ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
      // floatingActionButton: Column(
      //   mainAxisSize: MainAxisSize.min,
      //   children: [
      //     FloatingActionButton(
      //       onPressed: () {
      //         confirmUploadData(context);
      //       },
      //       backgroundColor: Colors.white,
      //       child: const Icon(Icons.cloud_upload, color: Color(0xFF637725)),
      //     ),
      //     Gap(MediaQuery.of(context).size.height * 0.005, useMediaQuery: false),
      //     const Text(
      //       'Upload',
      //       textAlign: TextAlign.center,
      //       style: TextStyle(
      //         fontFamily: 'Inter',
      //         fontWeight: FontWeight.bold,
      //         fontSize: 12.0,
      //         color: Colors.black,
      //       ),
      //     ),
      //   ],
      // ),
      // floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
    );
  }
}
