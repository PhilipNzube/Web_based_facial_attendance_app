import 'package:flutter/material.dart';
import '../../data/repositories/auth_repository.dart';
import '../../data/models/registrar_model.dart';
import '../../core/widgets/custom_snackbar.dart';
import '../screens/main_app/main_app.dart';
import 'package:mongo_dart/mongo_dart.dart' as mongo;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthController extends ChangeNotifier {
  final AuthRepository _authRepository = AuthRepository();
  bool isLoading = false;
  bool showFingerprint = false;
  Registrar? _user;

  Registrar? get user => _user;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passcodeController = TextEditingController();
  final FocusNode _emailFocusNode = FocusNode();
  final storage = const FlutterSecureStorage();

  AuthController() {
    _initializePrefs();
  }

  //public getters
  TextEditingController get emailController => _emailController;
  TextEditingController get passcodeController => _passcodeController;
  FocusNode get emailFocusNode => _emailFocusNode;

  Future<void> _initializePrefs() async {
    String? savedEmail = await _authRepository.storage.read(key: 'email');
    String? savedPasscode = await _authRepository.storage.read(key: 'passcode');

    if (savedEmail != null) {
      emailController.text = savedEmail;
    }

    if (savedEmail != null && savedPasscode != null) {
      showFingerprint = true;
      notifyListeners();
    }
  }

  Future<void> login(
      String email, String passcode, BuildContext context) async {
    String? savedEmail = await _authRepository.storage.read(key: 'email');
    String? savedPasscode = await _authRepository.storage.read(key: 'passcode');

    if (savedPasscode != null && passcode != savedPasscode) {
      CustomSnackbar.show(
        context,
        'Password does not match.',
        isError: true,
      );
      return;
    }

    if (savedEmail != null && email != savedEmail) {
      CustomSnackbar.show(
        context,
        'Email does not match.',
        isError: true,
      );
      return;
    }

    if (email.isEmpty) {
      CustomSnackbar.show(
        context,
        'Email field is required.',
        isError: true,
      );
      return;
    }

    if (passcode.isEmpty) {
      CustomSnackbar.show(
        context,
        'Passcode field is required.',
        isError: true,
      );
      return;
    }

    final RegExp emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+$');
    if (!emailRegex.hasMatch(email)) {
      CustomSnackbar.show(
        context,
        'Please enter a valid email address.',
        isError: true,
      );
      return;
    }
    isLoading = true;
    notifyListeners();

    // If email and passcode match the saved ones, welcome the user back
    if (savedEmail == email && savedPasscode == passcode) {
      String? savedFullName =
          await _authRepository.storage.read(key: 'fullName');
      if (savedFullName != null) {
        CustomSnackbar.show(
          context,
          'Welcome back, $savedFullName!',
        );
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => MainApp(
              key: UniqueKey(),
              //facesdkPlugin: widget.facesdkPlugin
            ),
          ),
        );
      } else {
        CustomSnackbar.show(
          context,
          'Error: Full name not found.',
          isError: true,
        );
      }
    } else {
      // Only fetch from MongoDB if there is no saved passcode or if the passcode doesn't match
      if (savedPasscode == null || savedPasscode != passcode) {
        try {
          // Connect to the database
          var db = await mongo.Db.create(
              'mongodb+srv://brainpalscodeacademy:%40Meprosper12@kogiagile.zjolb.mongodb.net/KOGI_AGILE_DB_TEST?retryWrites=true&w=majority');
          await db.open();
          print('Connected to the database.');

          // Access the 'registrars' collection
          var collection = db.collection('registrars');

          var passcodeInt = int.parse(passcode);

          var query = mongo.where
              .eq('email', email)
              .eq('randomId', passcodeInt)
              .fields(['fullName', '_id', 'isActive']);

          // Execute the query and find the document
          var result = await collection.findOne(query);

          // Print the result
          if (result != null) {
            print('Document found: $result');
            var fullName = result['fullName'];
            var id = result['_id'].toHexString();
            var isActive = result['isActive'];
            print('isActive: $isActive');
            print(fullName);
            print(id);
            if (isActive) {
              // Save the passcode only if it matches the one from the database
              await storage.write(key: 'email', value: email);
              await storage.write(key: 'passcode', value: passcode);
              await storage.write(key: 'fullName', value: fullName);
              await storage.write(key: 'id', value: id);

              CustomSnackbar.show(
                context,
                'Welcome back $fullName!',
              );
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => MainApp(
                    key: UniqueKey(),
                  ),
                ),
              );
            } else {
              CustomSnackbar.show(
                context,
                'Your account is not active. Please contact the administrator.',
                isError: true,
              );
            }
          } else {
            CustomSnackbar.show(
              context,
              'Email or passcode is incorrect.',
              isError: true,
            );
          }

          // Close the database connection
          await db.close();
          print('Database connection closed.');
        } catch (e, stacktrace) {
          // Print the error and the stack trace
          print('An error occurred: $e');
          print('Stack trace: $stacktrace');
          CustomSnackbar.show(
            context,
            'An error occurred',
            isError: true,
          );
        } finally {
          isLoading = false;
          notifyListeners();
        }
      } else {
        CustomSnackbar.show(
          context,
          'Passcode matches saved one. No need to fetch from database.',
          isError: false,
        );

        isLoading = false;
        notifyListeners();
      }
    }
  }

  Future<void> biometricLogin(BuildContext context) async {
    bool isAuthenticated = await _authRepository.authenticateBiometric();
    if (isAuthenticated) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => MainApp(
            key: UniqueKey(),
            //facesdkPlugin: widget.facesdkPlugin
          ),
        ),
      );
    } else {
      CustomSnackbar.show(context, "Biometric authentication failed",
          isError: true);
    }
  }
}
