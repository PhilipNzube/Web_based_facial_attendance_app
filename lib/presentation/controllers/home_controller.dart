import 'package:facial_attendance/data/models/student_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hive_flutter/hive_flutter.dart';

class HomeController extends ChangeNotifier {
  final storage = const FlutterSecureStorage();
  bool isRefreshing = false;
  String userFullName = "User";
  String greeting = "";
  Map<String, Future<int>> studentStats = {};

  HomeController() {
    _initialize();
  }

  void _initialize() {
    _loadUserInfo();
    _fetchStats();
  }

  Future<void> _loadUserInfo() async {
    String? fullName = await storage.read(key: 'fullName');
    userFullName = fullName ?? "User";
    greeting = _getGreeting();
    notifyListeners();
  }

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good Morning';
    if (hour < 17) return 'Good Afternoon';
    return 'Good Evening';
  }

  Future<void> _fetchStats() async {
    studentStats = {
      'Total Students': _getTotalStudents(),
      'Total 100 Level': _getTotalByLevel("100 Level"),
      'Total 200 Level': _getTotalByLevel("200 Level"),
      'Total 300 Level': _getTotalByLevel("300 Level"),
      'Total 400 Level': _getTotalByLevel("400 Level"),
    };
    notifyListeners();
  }

  Future<int> _getTotalStudents() async {
    final box = Hive.box<Student>('students');
    print('Total students in box: ${box.length}');
    return box.length;
  }

  Future<int> _getTotalByLevel(String level) async {
    final box = Hive.box<Student>('students');
    for (var student in box.values) {
      print('Student: ${student.firstname}, Level: ${student.presentLevel}');
    }
    final matchingStudents = box.values.where((student) {
      print('Student level: ${student.presentLevel} | Target level: $level');
      return student.presentLevel.trim().toLowerCase() ==
          level.trim().toLowerCase();
    }).toList();

    print('Total matching students: ${matchingStudents.length}');
    return matchingStudents.length;
  }

  Future<void> refreshData() async {
    isRefreshing = true;
    notifyListeners();

    await _fetchStats();

    isRefreshing = false;
    notifyListeners();
  }

  Future<void> logout(BuildContext context) async {
    try {
      if (context.mounted) {
        Navigator.pushReplacementNamed(context, "/login");
      }
    } catch (e) {
      print("Logout error: $e");
    }
  }
}
