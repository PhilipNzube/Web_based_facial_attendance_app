import 'dart:convert';
import 'dart:math';
import 'dart:io';
import 'package:facial_attendance/data/models/student_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:image/image.dart' as img;
import 'package:image_picker/image_picker.dart';
import '../../core/widgets/custom_snackbar.dart';
import '../../data/database/general_db/db_helper.dart';
import '../../data/repositories/lga_repository.dart';
import '../../data/models/school_model.dart';
import 'package:mongo_dart/mongo_dart.dart' as mongo;
import 'package:flutter/foundation.dart';

import '../../data/repositories/nigeria_data_repository.dart';
import '../../data/repositories/nigeria_data_repository2.dart';
import '../../data/repositories/nigerian_states_repository.dart';

class RegisterStudentController extends ChangeNotifier {
  final BuildContext context;
  final Function(bool) syncingSchools;

  final _formKey = GlobalKey<FormState>();
  final _schoolIdController = TextEditingController();
  final _surnameController = TextEditingController();
  final _studentNinController = TextEditingController();
  final _wardController = TextEditingController();
  final _firstNameController = TextEditingController();
  final _middleNameController = TextEditingController();
  final _genderController = TextEditingController();
  final _dobController = TextEditingController();
  final _nationalityController = TextEditingController();
  final _stateOfOriginController = TextEditingController();
  final _lgaController = TextEditingController();
  final _lgaOfEnrollmentController = TextEditingController();
  final _communityNameController = TextEditingController();
  final _residentialAddressController = TextEditingController();
  final _presentClassController = TextEditingController();
  final _yearOfEnrollmentController = TextEditingController();
  final _parentContactController = TextEditingController();
  final _parentOccupationController = TextEditingController();
  final _parentPhoneController = TextEditingController();
  final _parentNameController = TextEditingController();
  final _parentNinController = TextEditingController();
  final _bankNameController = TextEditingController();
  final _accountNumberController = TextEditingController();
  final _passportController = TextEditingController();
  final _parentBvnController = TextEditingController();
  File _passportImage = File('');
  final List<String> _nationality = ['Nigeria', 'Others'];
  final List<String> _gender = ['Female'];
  String? _selectedNationality;
  String _selectedGender = 'Female';
  String? _selectedState;
  String? _selectedLga;
  List<String> _states = [];
  List<String> _lgas = [];
  late Future<NigeriaData> _nigeriaDataFuture;
  String? _selectedPresentLevel;
  String? _selectedDepartment;
  int? _selectedYearOfEnrollment;
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
  final List<String> _banks = [
    'FCMB',
    'Polaris Bank',
    'Zenith Bank',
    'UBA',
    'Union Bank'
  ];

  String? _selectedBank;
  String? _selectedSchool;
  List<School> _schools = [];
  bool _isSchoolSelected = false;
  bool _isLoading = false;
  Future<List<School>>? _loadSchoolsFuture;
  final storage = FlutterSecureStorage();
  String? _selectedLgaOfEnrollment; // New field for LGA of Enrollment
  List<String> _lgasOfEnrollment = []; // List of LGAs for Kogi state
  List<String> _wardsOfEnrollment = [];
  bool _isSyncing = false;
  double _progress = 0.0;
  bool _resync = false;

  final List<String> _disabilityStatusOptions = ['Yes', 'No'];
  String? _selectedDisabilityStatus;

  bool _isLGASelected = false;
  bool _isSchoolCategorySelected = false;
  bool _isSchoolTypeSelected = false;
  String? _selectedLGA;
  String? _selectedSchoolCategory;
  String? _selectedSchoolType;
  String? _selectedSchoolName;

  Uint8List? _passportImageBytes; // Replace File with Uint8List
  String? _passportImageName;

  RegisterStudentController(this.context, {required this.syncingSchools}) {
    _initialize(context);
  }

  // Public Getters
  bool get isSchoolSelected => _isSchoolSelected;
  bool get isSyncing => _isSyncing;
  Future<List<School>>? get loadSchoolsFuture => _loadSchoolsFuture;
  List<School> get schools => _schools;
  bool get resync => _resync;
  String? get selectedSchool => _selectedSchool;
  GlobalKey<FormState> get formKey => _formKey;
  String? get selectedGender => _selectedGender;
  List<String> get gender => _gender;
  String? get selectedNationality => _selectedNationality;
  List<String> get nationality => _nationality;
  String? get selectedState => _selectedState;
  String? get selectedLga => _selectedLga;
  String? get selectedLgaOfEnrollment => _selectedLgaOfEnrollment;
  List<String> get states => _states;
  List<String> get lgas => _lgas;
  List<String> get lgasOfEnrollment => _lgasOfEnrollment;
  List<String> get wardsOfEnrollment => _wardsOfEnrollment;
  String? get selectedPresentLevel => _selectedPresentLevel;
  String? get selectedDepartment => _selectedDepartment;
  int? get selectedYearOfEnrollment => _selectedYearOfEnrollment;
  String? get selectedParentOccupation => _selectedParentOccupation;
  List<String> get parentOccupations => _parentOccupations;
  String? get selectedBank => _selectedBank;
  List<String> get banks => _banks;
  String? get selectedDisabilityStatus => _selectedDisabilityStatus;
  List<String> get disabilityStatusOptions => _disabilityStatusOptions;
  File get passportImage => _passportImage;
  bool get isLoading => _isLoading;
  double get progress => _progress;
  bool get isLGASelected => _isLGASelected;
  bool get isSchoolCategorySelected => _isSchoolCategorySelected;
  bool get isSchoolTypeSelected => _isSchoolTypeSelected;
  String? get selectedLGA => _selectedLGA;
  String? get selectedSchoolCategory => _selectedSchoolCategory;
  String? get selectedSchoolType => _selectedSchoolType;
  String? get selectedSchoolName => _selectedSchoolName;
  Uint8List? get passportImageBytes => _passportImageBytes;

  TextEditingController get surnameController => _surnameController;
  TextEditingController get firstNameController => _firstNameController;
  TextEditingController get middleNameController => _middleNameController;
  TextEditingController get studentNinController => _studentNinController;
  TextEditingController get dobController => _dobController;
  TextEditingController get wardController => _wardController;
  TextEditingController get communityNameController => _communityNameController;
  TextEditingController get residentialAddressController =>
      _residentialAddressController;
  TextEditingController get parentNameController => _parentNameController;
  TextEditingController get parentPhoneController => _parentPhoneController;
  TextEditingController get parentNinController => _parentNinController;
  TextEditingController get parentBvnController => _parentBvnController;
  TextEditingController get accountNumberController => _accountNumberController;

  //Public setters
  void setSchoolSelected(bool value) {
    _isSchoolSelected = value;
    notifyListeners();
  }

  void setSelectedSchool(String value) {
    _selectedSchool = value;
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

  void setIsSchoolTypeSelected(bool value) {
    _isSchoolTypeSelected = value;
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

  void setSelectedSchoolType(String value) {
    _selectedSchoolType = value;
    notifyListeners();
  }

  void setSelectedSchoolName(String value) {
    _selectedSchoolName = value;
    notifyListeners();
  }

  void setSchools(List<School> newSchools) {
    _schools = newSchools;
    //notifyListeners();
  }

  void setSchoolsFuture(Future<List<School>> value) {
    _loadSchoolsFuture = value;
    notifyListeners();
  }

  void setResync(bool value) {
    _resync = value;
    notifyListeners();
  }

  void setSelectedGender(String value) {
    _selectedGender = value;
    notifyListeners();
  }

  void setSelectedNationality(String value) {
    _selectedNationality = value;
    notifyListeners();
  }

  void setSelectedState(String? value) {
    _selectedState = value;
    notifyListeners();
  }

  void setSelectedLga(String? value) {
    _selectedLga = value;
    notifyListeners();
  }

  void setSelectedLgaOfEnrollment(String? value) {
    _selectedLgaOfEnrollment = value;
    notifyListeners();
  }

  void setWardControllerValue(String? value) {
    _wardController.text = value!;
    notifyListeners();
  }

  void setSelectedPresentLevel(String? value) {
    _selectedPresentLevel = value!;
    notifyListeners();
  }

  void setSelectedDepartment(String? value) {
    _selectedDepartment = value!;
    notifyListeners();
  }

  void setSelectedYearOfEnrollment(int? value) {
    _selectedYearOfEnrollment = value!;
    notifyListeners();
  }

  void setSelectedParentOccupation(String? value) {
    _selectedParentOccupation = value!;
    notifyListeners();
  }

  void setSelectedBank(String? value) {
    _selectedBank = value!;
    notifyListeners();
  }

  void setSelectedDisabilityStatus(String? value) {
    _selectedDisabilityStatus = value!;
    notifyListeners();
  }

  void setPassportImageBytes(Uint8List? bytes) {
    _passportImageBytes = bytes;
    notifyListeners();
  }

  void _initialize(BuildContext context) {
    //_loadSchoolsFuture = syncAndLoadSchools(context);
    // _loadSchoolsFuture = loadSchools();
    _selectedState = null; // Initialize as null for validation
    _selectedLga = null; // Initialize as null for validation
    _selectedLgaOfEnrollment = null;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _selectedNationality = 'Nigeria';
      getStates(); // Load states for Nigeria
      getLgasOfEnrollment();
      notifyListeners();
    });
  }

  String _formatDate(DateTime date) {
    return DateFormat('yyyy-MM-dd').format(date);
  }

  void pickDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      _dobController.text = _formatDate(picked);
      notifyListeners();
    }
  }

  String generateRandomId() {
    const chars =
        'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789';
    final random = Random();
    return String.fromCharCodes(Iterable.generate(
        9, (_) => chars.codeUnitAt(random.nextInt(chars.length))));
  }

  Future<String> getEmail() async {
    final storage = FlutterSecureStorage();
    return await storage.read(key: 'email') ?? '';
  }

  Future<String> getCreatedBy() async {
    final storage = FlutterSecureStorage();
    return await storage.read(key: 'id') ?? '';
  }

//strip the bject id from the mongodb file
  String extractObjectId(String objectIdString) {
    final regex = RegExp(
        r'ObjectId\("(.+)"\)'); // Matches ObjectId("...") and captures the ID
    final match = regex.firstMatch(objectIdString);

    if (match != null && match.groupCount > 0) {
      return match.group(1)!; // Return the captured group (actual ObjectId)
    } else {
      throw FormatException('Invalid ObjectId format: $objectIdString');
    }
  }

  void insertData(BuildContext context) async {
    _isLoading = true;
    notifyListeners();

    final randomId = generateRandomId();
    final createdBy = await storage.read(key: 'id');

    try {
      // ✅ Use the already-opened typed box
      final studentsBox = Hive.box<Student>('students');

      final base64Passport = base64Encode(_passportImageBytes!);

      // ✅ Create a Student instance (not a Map)
      final studentData = Student(
        randomId: randomId,
        surname: _surnameController.text,
        firstname: _firstNameController.text,
        middlename: _middleNameController.text,
        presentLevel: _selectedPresentLevel!,
        department: _selectedDepartment!,
        originalPassport: base64Passport,
        passport: base64Passport,
        createdBy: createdBy,
        cloudinaryUrl: '',
        status: 0,
      );

      await studentsBox.add(studentData); // ✅ Add typed object

      print("Inserted");
      CustomSnackbar.show(
        context,
        'Registration successful!',
      );

      _clearFields();
    } catch (e) {
      print('Error inserting data: $e');
      CustomSnackbar.show(
        context,
        'Failed to register student.',
        isError: true,
      );
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void _clearFields() {
    _surnameController.clear();
    _firstNameController.clear();
    _middleNameController.clear();
    _studentNinController.clear();
    _dobController.clear();
    _communityNameController.clear();
    _residentialAddressController.clear();
    _parentNameController.clear();
    _parentPhoneController.clear();
    _parentNinController.clear();
    _parentBvnController.clear();
    _accountNumberController.clear();
    _passportImage = File('');
    _selectedNationality = 'Nigeria';
    _selectedGender = 'Female';
    _selectedState = null;
    _selectedLga = null;
    _selectedLgaOfEnrollment = null;
    _wardController.clear();
    _wardsOfEnrollment.clear();
    _selectedPresentLevel = null;
    _selectedDepartment = null;
    _selectedYearOfEnrollment = null;
    _selectedParentOccupation = null;
    _selectedBank = null;
    _selectedDisabilityStatus = null;
    notifyListeners();
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

  void getLgasOfEnrollment() async {
    final nigeriaData = await NigeriaDataRepository().loadNigeriaData();
    final kogiState = nigeriaData.states.firstWhere(
      (state) => state.name == 'KOGI',
      orElse: () => NigerianStates(name: '', lgas: []),
    );

    _lgasOfEnrollment = kogiState.lgas.map((lga) => lga.name).toList();
    _wardsOfEnrollment.clear(); // Clear wards when LGA changes
    notifyListeners();
  }

  void getWardsOfEnrollment(String lga) async {
    final nigeriaData = await NigeriaDataRepository().loadNigeriaData();
    final kogiState = nigeriaData.states.firstWhere(
      (state) => state.name == 'KOGI',
      orElse: () => NigerianStates(name: '', lgas: []),
    );
    final selectedLga = kogiState.lgas.firstWhere(
      (l) => l.name == lga,
      orElse: () => LGA(name: '', wards: []),
    );

    _wardsOfEnrollment = selectedLga.wards;
    _wardController.text = selectedLga.wards.first;
    notifyListeners();
  }

  void pickImgFromGallery(
      BuildContext dialogContext, BuildContext rootContext) async {
    Navigator.of(dialogContext).pop();

    try {
      final pickedFile =
          await ImagePicker().pickImage(source: ImageSource.gallery);
      rootContext.loaderOverlay.show();

      if (pickedFile == null) {
        rootContext.loaderOverlay.hide();
        return;
      }

      final originalBytes = await pickedFile.readAsBytes();
      final image = img.decodeImage(originalBytes);

      if (image != null) {
        final thumbnail = img.copyResize(image, width: 200, height: 200);
        final thumbnailBytes = Uint8List.fromList(img.encodeJpg(thumbnail));

        _passportImageBytes = thumbnailBytes;
        _passportImageName =
            'passport_${DateTime.now().millisecondsSinceEpoch}_${Random().nextInt(1000)}.jpg';

        if (!kIsWeb) {
          final directory = await getApplicationDocumentsDirectory();
          final file = File('${directory.path}/$_passportImageName');
          await file.writeAsBytes(thumbnailBytes);
        }

        notifyListeners();
      }
    } catch (e) {
      print('Image error: $e');
    } finally {
      if (rootContext.loaderOverlay.visible) {
        rootContext.loaderOverlay.hide();
      }
    }
  }

  void takeNewPhoto(
      BuildContext dialogContext, BuildContext rootContext) async {
    Navigator.of(dialogContext).pop();

    try {
      final pickedFile =
          await ImagePicker().pickImage(source: ImageSource.camera);
      rootContext.loaderOverlay.show();

      if (pickedFile == null) {
        rootContext.loaderOverlay.hide();
        return;
      }

      final originalBytes = await pickedFile.readAsBytes();
      final image = img.decodeImage(originalBytes);

      if (image != null) {
        rootContext.loaderOverlay.show();
        final thumbnail = img.copyResize(image, width: 200, height: 200);
        final thumbnailBytes = Uint8List.fromList(img.encodeJpg(thumbnail));

        _passportImageBytes = thumbnailBytes;
        _passportImageName =
            'passport_${DateTime.now().millisecondsSinceEpoch}_${Random().nextInt(1000)}.jpg';

        if (!kIsWeb) {
          final directory = await getApplicationDocumentsDirectory();
          final file = File('${directory.path}/$_passportImageName');
          await file.writeAsBytes(thumbnailBytes);
        }

        notifyListeners();
      }
    } catch (e) {
      print('Image error: $e');
    } finally {
      if (rootContext.loaderOverlay.visible) {
        rootContext.loaderOverlay.hide();
      }
    }
  }

  void notifyListenersCall() {
    notifyListeners();
  }
}
