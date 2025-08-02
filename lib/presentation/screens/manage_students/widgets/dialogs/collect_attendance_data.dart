import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../core/widgets/custom_gap.dart';
import '../../../../../core/widgets/custom_snackbar.dart';
import '../../../../controllers/manage_students_controller.dart';

void collectAttendanceData(BuildContext context, int studentIndex) {
  int currentYear = DateTime.now().year;
  List<Map<String, dynamic>> _years = List.generate(
      20,
      (index) => {
            "name": (currentYear - index).toString(),
            "value": currentYear - index
          });

  int? tempSelectedYear = currentYear;
  int? tempSelectedMonth =
      Provider.of<ManageStudentController>(context, listen: false)
          .selectedMonth;
  int? tempSelectedWeek =
      Provider.of<ManageStudentController>(context, listen: false).selectedWeek;

  showDialog(
    context: context,
    builder: (context) {
      return Dialog(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  "Select Year, Month & Week",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const Gap(15),
                // Year Dropdown
                DropdownButtonFormField<int>(
                  decoration: InputDecoration(
                    labelText: "Select Year",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8)),
                  ),
                  value: tempSelectedYear,
                  items: _years.map((year) {
                    return DropdownMenuItem<int>(
                      value: year["value"],
                      child: Text(year["name"]),
                    );
                  }).toList(),
                  onChanged: (value) {
                    tempSelectedYear = value;
                  },
                ),
                const Gap(15),

                // Month Dropdown
                DropdownButtonFormField<int>(
                  decoration: InputDecoration(
                    labelText: "Select Month",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8)),
                  ),
                  value: tempSelectedMonth,
                  items: Provider.of<ManageStudentController>(context,
                          listen: false)
                      .months
                      .map((month) {
                    return DropdownMenuItem<int>(
                      value: month["value"],
                      child: Text(month["name"]),
                    );
                  }).toList(),
                  onChanged: (value) {
                    tempSelectedMonth = value;
                  },
                ),
                const Gap(15),

                // Week Dropdown
                DropdownButtonFormField<int>(
                  decoration: InputDecoration(
                    labelText: "Select Week",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8)),
                  ),
                  value: tempSelectedWeek,
                  items: Provider.of<ManageStudentController>(context,
                          listen: false)
                      .weeks
                      .map((week) {
                    return DropdownMenuItem<int>(
                      value: week["value"],
                      child: Text(week["name"]),
                    );
                  }).toList(),
                  onChanged: (value) {
                    tempSelectedWeek = value;
                  },
                ),
                const Gap(15),

                // Attendance Score Input
                TextFormField(
                  controller: Provider.of<ManageStudentController>(context,
                          listen: false)
                      .attendanceScoreController,
                  decoration: InputDecoration(
                    labelText: "Enter Attendance Score",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8)),
                  ),
                  keyboardType: TextInputType.number,
                ),

                const Gap(20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text("Cancel",
                          style: TextStyle(color: Colors.red)),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        if (tempSelectedYear != null &&
                            tempSelectedMonth != null &&
                            tempSelectedWeek != null &&
                            Provider.of<ManageStudentController>(context,
                                    listen: false)
                                .attendanceScoreController
                                .text
                                .isNotEmpty) {
                          int? attendanceScore = int.tryParse(
                              Provider.of<ManageStudentController>(context,
                                      listen: false)
                                  .attendanceScoreController
                                  .text);
                          if (attendanceScore == null) {
                            CustomSnackbar.show(
                              context,
                              'Please enter a valid number for attendance score',
                              isError: true,
                            );
                            return;
                          }
                          Provider.of<ManageStudentController>(context,
                                  listen: false)
                              .setSelectedMonth(tempSelectedMonth);
                          Provider.of<ManageStudentController>(context,
                                  listen: false)
                              .setSelectedWeek(tempSelectedWeek);
                          Provider.of<ManageStudentController>(context,
                                  listen: false)
                              .setSelectedYear(tempSelectedYear);
                          Navigator.pop(context);
                          Provider.of<ManageStudentController>(context,
                                  listen: false)
                              .sendSingleStudentAttendance(
                                  studentIndex, context);
                          Provider.of<ManageStudentController>(context,
                                  listen: false)
                              .verifyStudent(studentIndex, context);
                        } else {
                          CustomSnackbar.show(
                            context,
                            'Please select all fields and enter a score',
                            isError: true,
                          );
                        }
                      },
                      child: const Text("Submit"),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
}
