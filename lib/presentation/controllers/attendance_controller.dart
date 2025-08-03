import 'package:facial_attendance/data/models/student_model.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:file_picker/file_picker.dart';

import '../../../data/database/general_db/db_helper.dart';
import '../../core/widgets/custom_snackbar.dart';
import 'package:permission_handler/permission_handler.dart';

class AttendanceController extends ChangeNotifier {
  bool _isLoading = false;
  List<Map<String, dynamic>> _students = [];

  AttendanceController() {
    _initialize();
  }

  // Public Getters
  bool get isLoading => _isLoading;
  List<Map<String, dynamic>> get students => _students;

  void _initialize() {
    loadStudents();
  }

  Future<void> loadStudents() async {
    final box = await Hive.openBox<Student>('students');

    _students = box.values
        .map((student) => {
              'surname': student.surname,
              'firstname': student.firstname,
              'presentLevel': student.presentLevel,
              'department': student.department,
              'status': student.status,
            })
        .toList();

    notifyListeners();
  }

  void refreshPage() async {
    await loadStudents();
    _isLoading = true;
    notifyListeners();
    Future.delayed(Duration(seconds: 1), () {
      _isLoading = false;
      notifyListeners();
    });
  }

  Future<void> generatePDF(BuildContext context) async {
    try {
      final pdf = pw.Document();

      final List<Map<String, dynamic>> filteredStudents =
          _students.where((student) => student['status'] == 1).toList();

      pdf.addPage(
        pw.Page(
          pageFormat: PdfPageFormat.a4,
          build: (pw.Context context) {
            return pw.TableHelper.fromTextArray(
              context: context,
              data: [
                ['Name', 'Level', 'Department'],
                ...filteredStudents.map((student) => [
                      '${student['surname']?.toString().trim() ?? ''} ${student['firstname']}',
                      student['presentLevel'],
                      student['department'],
                    ]),
              ],
            );
          },
        ),
      );

      // ✅ Share PDF across all platforms (including web)
      await Printing.sharePdf(
        bytes: await pdf.save(),
        filename: 'attendance.pdf',
      );
    } catch (e) {
      print('Error generating PDF: $e');
      CustomSnackbar.show(context, 'Error generating PDF', isError: true);
    }
  }

  void notifyListenersCall() {
    notifyListeners();
  }
}
