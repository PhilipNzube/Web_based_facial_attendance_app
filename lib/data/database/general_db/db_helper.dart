import 'package:facial_attendance/data/models/student_model.dart';
import 'package:hive/hive.dart';

class DBHelper {
  static final DBHelper _instance = DBHelper._internal();
  factory DBHelper() => _instance;
  DBHelper._internal();

  final Box<Student> _studentsBox = Hive.box<Student>('students');

  Future<void> addStudent(Student student) async {
    await _studentsBox.put(student.randomId, student);
  }

  List<Student> getAllStudents() {
    return _studentsBox.values.toList();
  }

  Future<void> updateStudent(Student student) async {
    await _studentsBox.put(student.randomId, student);
  }

  Future<void> deleteStudent(String id) async {
    await _studentsBox.delete(id);
  }
}
