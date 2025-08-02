import 'dart:io';
import 'package:facial_attendance/data/models/student_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mongo_dart/mongo_dart.dart' as mongo;
import 'package:cloudinary/cloudinary.dart';
import 'package:http/http.dart' as http;
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:intl/intl.dart';
import 'dart:async';
import 'package:image/image.dart' as img;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../../aws_credentials.dart';
import '../../../data/database/general_db/db_helper.dart';
import '../../core/constants/api_keys.dart';
import '../../core/widgets/custom_snackbar.dart';
import '../../data/models/school_model.dart';
import '../../data/repositories/face_recognition_repository.dart';
import '../../data/repositories/lga_repository.dart';
import '../../data/repositories/nigeria_data_repository.dart';
import '../../data/repositories/nigerian_states_repository.dart';
import '../../main.dart';
import '../screens/manage_students/widgets/dialogs/upload_progress_dialog.dart';

class ManageStudentController extends ChangeNotifier {
  List<Student> _students = [];
  List<bool> _isSentToMongoDB = [];
  List<bool> _isNotSentToMongoDB = [];
  bool _isLoading = false;
  late Cloudinary cloudinary;
  List<School> _schools = []; // List of schools
  String? _selectedSchool; // Selected school ID
  bool _isSchoolSelected = false;
  Future<List<School>>? _loadSchoolsFuture;
  // Dropdown values
  final List<String> _nationality = ['Nigeria', 'Others'];
  final List<String> _gender = ['Female'];
  List<String> _states = [];
  List<String> _lgas = [];
  final List<String> _parentOccupations = [
    'Farmer',
    'Teacher',
    'Trader',
    'Mechanic',
    'Tailor',
    'Bricklayer',
    'Carpenter',
    'Doctor',
    'Lawyer',
    'Butcher',
    'Electrician',
    'Clergyman',
    'Barber',
    'Hair Dresser',
    'Business Person',
    'Civil Servant',
    'Others'
  ];
  String? _selectedParentOccupation;
  final List<String> banks = [
    'FCMB',
    'Polaris Bank',
    'Zenith Bank',
    'UBA',
    'Union Bank'
  ];
  String? _selectedBank;
  String? _selectedLgaOfEnrollment; // New field for LGA of Enrollment
  List<String> _lgasOfEnrollment = []; // List of LGAs for Kogi state
  List<String> _wardsOfEnrollment = [];
  File _passportImage = File('');
  String? _tempSelectedSchool;
  ValueNotifier<double> _uploadProgressNotifier = ValueNotifier(0.0);
  ValueNotifier<String> _uploadTextNotifier = ValueNotifier('');
  final _formKey = GlobalKey<FormState>();
  ScrollController _scrollController = ScrollController();
  bool _isScrolledToTop = true;
  final storage = FlutterSecureStorage();
  bool _isSyncing = false;
  double _progress = 0.0;
  bool resync = false;
  final List<Map<String, dynamic>> _months = [
    {"name": "January", "value": 1},
    {"name": "February", "value": 2},
    {"name": "March", "value": 3},
    {"name": "April", "value": 4},
    {"name": "May", "value": 5},
    {"name": "June", "value": 6},
    {"name": "July", "value": 7},
    {"name": "August", "value": 8},
    {"name": "September", "value": 9},
    {"name": "October", "value": 10},
    {"name": "November", "value": 11},
    {"name": "December", "value": 12},
  ];

  final List<Map<String, dynamic>> _weeks = [
    {"name": "Week 1", "value": 1},
    {"name": "Week 2", "value": 2},
    {"name": "Week 3", "value": 3},
    {"name": "Week 4", "value": 4},
    {"name": "Week 5", "value": 5},
  ];

  int? _selectedMonth;
  int? _selectedWeek;
  int? _selectedYear;

  bool _isLGASelected = false;
  bool _isSchoolCategorySelected = false;
  bool _isSchoolTypeSelected = false;
  String? _selectedLGA;
  String? _selectedSchoolCategory;
  String? _selectedSchoolType;

  TextEditingController _attendanceScoreController = TextEditingController();

  final List<String> _disabilityStatusOptions = ['Yes', 'No'];

  ManageStudentController() {
    _initialize();
  }

  // Public Getters
  GlobalKey<FormState> get formKey => _formKey;
  bool get isLoading => _isLoading;
  List<Student> get students => _students;
  ValueNotifier<double> get uploadProgressNotifier => _uploadProgressNotifier;
  ValueNotifier<String> get uploadTextNotifier => _uploadTextNotifier;
  Future<List<School>>? get loadSchoolsFuture => _loadSchoolsFuture;
  List<School> get schools => _schools;
  String? get tempSelectedSchool => _tempSelectedSchool;
  File get passportImage => _passportImage;
  // void Function(Function(String? p1) onSchoolSelected, BuildContext context)
  //     get selectSchool => _selectSchool;
  List<String> get gender => _gender;
  List<String> get nationality => _nationality;
  List<String> get states => _states;
  List<String> get lgas => _lgas;
  List<String> get lgasOfEnrollment => _lgasOfEnrollment;
  List<String> get wardsOfEnrollment => _wardsOfEnrollment;
  List<String> get parentOccupations => _parentOccupations;
  List<String> get disabilityStatusOptions => _disabilityStatusOptions;
  int? get selectedMonth => _selectedMonth;
  int? get selectedWeek => _selectedWeek;
  int? get selectedYear => _selectedYear;
  List<Map<String, dynamic>> get months => _months;
  List<Map<String, dynamic>> get weeks => _weeks;
  bool get isSchoolSelected => _isSchoolSelected;
  bool get isLGASelected => _isLGASelected;
  bool get isSchoolCategorySelected => _isSchoolCategorySelected;
  bool get isSchoolTypeSelected => _isSchoolTypeSelected;
  String? get selectedSchool => _selectedSchool;
  String? get selectedLGA => _selectedLGA;
  String? get selectedSchoolCategory => _selectedSchoolCategory;
  String? get selectedSchoolType => _selectedSchoolType;

  ScrollController get scrollController => _scrollController;
  TextEditingController get attendanceScoreController =>
      _attendanceScoreController;

//Public setters
  void setLoadSchoolsFuture(Future<List<School>> value) {
    _loadSchoolsFuture = value;
    notifyListeners();
  }

  void setSchools(List<School> value) {
    _schools = value;
    notifyListeners();
  }

  void setSchoolSelected(bool value) {
    _isSchoolSelected = value;
    notifyListeners();
  }

  void setSelectedSchool(String? value) {
    _selectedSchool = value;
    notifyListeners();
  }

  void setSelectedLGA(String value) {
    _selectedLGA = value;
    notifyListeners();
  }

  void setSelectedSchoolCategory(String value) {
    _selectedSchoolCategory = value;
    notifyListeners();
  }

  void setIsLGASelected(bool value) {
    _isLGASelected = value;
    notifyListeners();
  }

  void setIsSchoolCategorySelected(bool value) {
    _isSchoolCategorySelected = value;
    notifyListeners();
  }

  void setPassportImage(File value) {
    _passportImage = value;
    notifyListeners();
  }

  void setSelectedMonth(int? value) {
    _selectedMonth = value;
    notifyListeners();
  }

  void setSelectedWeek(int? value) {
    _selectedWeek = value;
    notifyListeners();
  }

  void setSelectedYear(int? value) {
    _selectedYear = value;
    notifyListeners();
  }

  void _initialize() {
    loadStudents();
    cloudinary = Cloudinary.signedConfig(
      cloudName: ApiKeys.cloudinaryCloudName, // ✅ Use from constants
      apiKey: ApiKeys.cloudinaryApiKey,
      apiSecret: ApiKeys.cloudinaryApiSecret,
    );
    _scrollController.addListener(() {
      if (_scrollController.offset == 0) {
        _isScrolledToTop = true;
        notifyListeners();
      } else {
        _isScrolledToTop = false;
        notifyListeners();
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  String formatDate(DateTime date) {
    return DateFormat('yyyy-MM-dd').format(date);
  }

  void getStates() async {
    final nigeriaData = await NigeriaDataRepository().loadNigeriaData();

    _states = nigeriaData.states.map((state) => state.name).toList();
    notifyListeners();
  }

  void getLgas(String state) async {
    final nigeriaData = await NigeriaDataRepository().loadNigeriaData();
    final selectedState = nigeriaData.states.firstWhere((s) => s.name == state);

    _lgas = selectedState.lgas.map((lga) => lga.name).toList();
    _wardsOfEnrollment.clear(); // Clear wards when state changes
    notifyListeners();
  }

  void getLgasOfEnrollment(String state) async {
    final nigeriaData = await NigeriaDataRepository().loadNigeriaData();
    final selectedState = nigeriaData.states.firstWhere(
      (state) => state.name == 'KOGI',
      orElse: () => NigerianStates(name: '', lgas: []),
    );

    _lgasOfEnrollment = selectedState.lgas.map((lga) => lga.name).toList();

    _wardsOfEnrollment.clear(); // Clear wards when LGA changes
    notifyListeners();
  }

  void getWardsOfEnrollment(String lga, String state) async {
    final nigeriaData = await NigeriaDataRepository().loadNigeriaData();
    final selectedState = nigeriaData.states.firstWhere(
      (s) => s.name == 'KOGI',
      orElse: () => NigerianStates(name: '', lgas: []),
    );
    final selectedLga = selectedState.lgas.firstWhere(
      (l) => l.name == lga,
      orElse: () => LGA(name: '', wards: []),
    );

    _wardsOfEnrollment = selectedLga.wards.toSet().toList();
    notifyListeners();
  }

  Future<List<School>> loadSchoolsFromHive() async {
    final box = await Hive.openBox<School>('allschools');
    return box.values.toList();
  }

  Future<bool> _isAllSchoolsBoxEmpty() async {
    final box = await Hive.openBox<School>('allschools');
    return box.isEmpty;
  }

  Future<List<School>> syncAndLoadSchools() async {
    try {
      final isEmpty = await _isAllSchoolsBoxEmpty();
      return await loadSchoolsFromHive();
    } catch (e) {
      print('Error syncing and loading schools: $e');
      return [];
    }
  }

  Future<bool> hasInternet() async {
    final connectivityResult = await (Connectivity().checkConnectivity());
    return connectivityResult != ConnectivityResult.none;
  }

  Future<void> loadStudents() async {
    final box = await Hive.openBox<Student>('students');
    _students = box.values.toList().reversed.toList();
    notifyListeners();
  }

  Future<String> uploadImage(File file, String randomId) async {
    final totalBytes = file.lengthSync();

    final response = await cloudinary.upload(
      file: file.path,
      fileBytes: file.readAsBytesSync(),
      resourceType: CloudinaryResourceType.image,
      folder: 'flutter_uploads',
      fileName: 'passport-$randomId',
      progressCallback: (count, total) {
        final progress = (count / total) * 100;
        print('Uploading image: ${progress.toStringAsFixed(2)}%');
        _updateUploadProgress(progress, "uploaded");
      },
    );

    if (response.isSuccessful) {
      print('Image uploaded successfully: ${response.secureUrl}');
      return response.secureUrl ?? '';
    } else {
      print('Error uploading image: ${response.error}');
      return ''; // Return empty if failed
    }
  }

  void _updateUploadProgress(double progress, String progressText) {
    _uploadProgressNotifier.value = progress;
    _uploadTextNotifier.value = '${progress.toStringAsFixed(2)}% $progressText';
  }

  void _resetUploadProgress(String progressText) {
    _uploadProgressNotifier.value = 0.0;
    _uploadTextNotifier.value = '0.00% $progressText';
  }

  String capitalize(String? text) {
    if (text == null || text.isEmpty) return '';
    return '${text[0].toUpperCase()}${text.substring(1).toLowerCase()}';
  }

  Future<void> resetAllData(BuildContext context) async {
    Navigator.of(navigatorKey.currentContext!).pop();

    try {
      final box = await Hive.openBox<Student>('students');

      // Update all students' status to 0
      for (var i = 0; i < box.length; i++) {
        final key = box.keyAt(i);
        final student = box.get(key);
        if (student != null) {
          final updatedStudent = student.copyWith(status: 0);
          await box.put(key, updatedStudent);
        }
      }

      await loadStudents();
      print('All students have been reset to status 0.');
      CustomSnackbar.show(context, 'All data has been reset successfully!');
    } catch (e) {
      print('Error resetting all data: $e');
      CustomSnackbar.show(
        context,
        'An error occurred while resetting data: $e',
        isError: true,
      );
    }
  }

  void sendDataToMongoDB(BuildContext context) async {}

  void sendSingleStudentAttendance(int index, BuildContext context) async {}

  // Future<bool> checkIfRecordExists({
  //   required String studentNin,
  //   required String accountNumber,
  // }) async {
  //   final db = await DBHelper().database;

  //   // Query to check if any of the fields already exist
  //   final existingRecords = await db.query(
  //     'students',
  //     where:
  //         '(studentNin = ? AND studentNin != "") OR (accountNumber = ? AND accountNumber != "")',
  //     whereArgs: [
  //       studentNin,
  //       accountNumber,
  //     ],
  //   );

  //   // If any records are found, return true
  //   return existingRecords.isNotEmpty;
  // }

  Future<String?> uploadImageToS3(
      String imagePath, String fileName, BuildContext context) async {
    final File imageFile = File(imagePath);
    final Uri uploadUrl = Uri.parse(
        "https://student-face-match-storage.s3.us-east-1.amazonaws.com/$fileName");

    try {
      var connectivityResult = await Connectivity().checkConnectivity();
      print("Checking network connectivity...");
      if (connectivityResult == ConnectivityResult.none) {
        print("No internet connection detected!");

        CustomSnackbar.show(
            context, 'No internet connection. Please check your network.',
            isError: true);
        return null;
      }
      // Fetch AWS credentials (either from secure storage or Secrets Manager)
      // final credentials = await MyAWSCredentials.fetchCredentials();
      // final accessKey = credentials['AWSAccessKeyId'];
      // final secretKey = credentials['AWSSecretKey'];

      // final response = await http.put(
      //   uploadUrl,
      //   body: imageFile.readAsBytesSync(),
      //   headers: {
      //     "Content-Type": "image/jpeg",
      //     "AWSAccessKeyId": accessKey!,
      //     "AWSSecretKey": secretKey!,
      //   },
      // );

      final response = await http.put(
        uploadUrl,
        body: imageFile.readAsBytesSync(),
        headers: {
          //"x-amz-acl": "public-read",
          "Content-Type": "image/jpeg",
          "AWSAccessKeyId": MyAWSCredentials.accessKey,
          "AWSSecretKey": MyAWSCredentials.secretKey,
        },
      );

      if (response.statusCode == 200) {
        print("Upload successful: ${uploadUrl.toString()}");

        return uploadUrl.toString(); // Return S3 URL
      } else {
        print("Upload failed: ${response.body}");
        throw Exception(
            "Failed to upload image to S3: ${response.statusCode} ${response.body}");
      }
    } catch (e) {
      print("Error: $e");
      throw Exception("Error uploading image: $e");
    }
  }

  Future<File> resizeImage(File imageFile,
      {int width = 600, int height = 800}) async {
    img.Image? image = img.decodeImage(imageFile.readAsBytesSync());

    // Resize image
    if (image == null) return imageFile;

    final totalPixels = image.width * image.height;
    int resizedPixels = 0;
    final resizedImage = img.copyResize(image, width: width, height: height);

    // Write the resized image back to file
    final resizedImageFile =
        await File(imageFile.path).writeAsBytes(img.encodeJpg(resizedImage));
    return resizedImageFile;
  }

  String getAmzDate() {
    return '${DateTime.now().toUtc().toIso8601String().replaceAll(RegExp(r'[:-]'), '').split('.').first}Z';
  }

  void verifyStudent(int index, BuildContext context) async {
    _resetUploadProgress("uploaded");
    showUploadProgressDialog(context);

    _isLoading = true;
    notifyListeners();

    try {
      final student = _students[index]; // assume _students is List<Student>
      final randomId = student.randomId;

      // Get passport image from Hive DB
      final studentsBox = Hive.box<Student>('students');
      final studentData = studentsBox.values.firstWhere(
        (s) => s.randomId == randomId,
        orElse: () => throw Exception("Student not found"),
      );

      final passportImagePath = studentData.passport;
      if (passportImagePath.isEmpty) {
        CustomSnackbar.show(context, 'Passport image not found!',
            isError: true);
        return;
      }

      // Take a new photo
      final pickedFile =
          await ImagePicker().pickImage(source: ImageSource.camera);
      if (pickedFile == null) {
        CustomSnackbar.show(context, 'No image captured!', isError: true);
        return;
      }
      final newImagePath = pickedFile.path;

      File resizedPassportImage = await resizeImage(File(passportImagePath));
      File resizedNewImage = await resizeImage(File(newImagePath));

      // Upload images
      final passportUrl = await uploadImageToS3(
          resizedPassportImage.path, "passport.jpg", context);
      final newImageUrl =
          await uploadImageToS3(resizedNewImage.path, "new_photo.jpg", context);

      _updateUploadProgress(50.0, "uploaded");
      if (passportUrl == null || newImageUrl == null) {
        CustomSnackbar.show(context, 'Image upload failed!', isError: true);
        return;
      }

      // Compare faces using AWS Rekognition
      bool isMatch =
          await compareFacesAWS(context, "passport.jpg", "new_photo.jpg");

      _updateUploadProgress(100.0, "uploaded");
      if (isMatch) {
        studentData.status = 1;
        await studentData.save();

        await loadStudents(); // Make sure this loads from Hive now
        //sendSingleStudentAttendance(index, context);
      } else {
        // Faces do not match
      }
    } catch (e) {
      print("Error: $e");
      //CustomSnackbar.show(context, "Error: $e", isError: true);
    } finally {
      Navigator.of(navigatorKey.currentContext!).pop();
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> compareFacesAWS(
      BuildContext context, String sourceImage, String targetImage) async {
    try {
      final repository =
          FaceRecognitionRepository(); // ✅ Instantiate Repository
      bool isMatch = await repository.compareFacesAWS(
          sourceImage, targetImage); // ✅ Call instance method

      CustomSnackbar.show(
        context,
        isMatch ? "Faces Match!" : "Faces Do Not Match",
        isError: !isMatch,
      );

      return isMatch; // ✅ Ensure function returns a bool
    } catch (e) {
      CustomSnackbar.show(context, e.toString(), isError: true);
      return false; // ✅ Return a default value to avoid the error
    }
  }

  String? transformClass(String? classValue) {
    if (classValue == null) return null;

    switch (classValue.toLowerCase()) {
      case 'sss 1':
        return 'SSS 1';
      case 'jss 1':
        return 'JSS 1';
      case 'jss 3':
        return 'JSS 3';
      case 'primary 6':
        return 'Primary 6';
    }
  }

  String toUpperCaseText(String? input) {
    return input?.toUpperCase() ??
        ''; // Converts the whole input string to uppercase, or returns an empty string if input is null
  }

  // String capitalizeFirstLetter(String? input) {
  //   if (input == null || input.isEmpty) return input ?? '';
  //   return input[0].toUpperCase() + input.substring(1).toLowerCase();
  // }

  Future<void> syncDataFromMongoDBPaginated(BuildContext context) async {}

  Future<void> _downloadImageFromCloudinary(
      String cloudinaryUrl, String randomId) async {
    try {
      // Validate the Cloudinary URL
      if (cloudinaryUrl.isEmpty) {
        print('Cloudinary URL is empty. Skipping download.');
        return;
      }

      // Prepare file path for saving the image
      final directory = await getApplicationDocumentsDirectory();
      final filePath = '${directory.path}/passport_$randomId.jpg';
      final file = File(filePath);

      // Skip download if the file already exists
      // if (await file.exists()) {
      //   print('Image already exists locally at $filePath');
      //   return;
      // }

      // Download the image
      final response = await http.get(Uri.parse(cloudinaryUrl), headers: {
        'Accept': 'image/jpeg'
      }).timeout(const Duration(seconds: 30)); // Add a timeout

      if (response.statusCode == 200) {
        // Save the image locally
        await file.writeAsBytes(response.bodyBytes);
        print('Image downloaded successfully to $filePath');
      } else {
        print('Failed to download image. Status code: ${response.statusCode}');
        // Remove the file if it was created but the download failed
        if (await file.exists()) {
          await file.delete();
        }
      }
    } catch (e) {
      print('Error downloading image from Cloudinary: $e');
      // Remove the file if it was created but the download failed
      final directory = await getApplicationDocumentsDirectory();
      final filePath = '${directory.path}/passport_$randomId.jpg';
      final file = File(filePath);
      if (await file.exists()) {
        await file.delete();
      }
    }
  }

  void notifyListenersCall() {
    notifyListeners();
  }
}
