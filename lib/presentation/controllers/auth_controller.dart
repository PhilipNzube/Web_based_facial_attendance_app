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
    String email,
    String passcode,
    BuildContext context,
  ) async {
    if (email.isEmpty) {
      CustomSnackbar.show(context, 'Email field is required.', isError: true);
      return;
    }

    if (passcode.isEmpty) {
      CustomSnackbar.show(
        context,
        'Password field is required.',
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

    if (passcode.length < 6) {
      CustomSnackbar.show(
        context,
        'Password must be at least 6 characters.',
        isError: true,
      );
      return;
    }
    isLoading = true;
    notifyListeners();

    CustomSnackbar.show(context, 'Welcome back!');
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => MainApp(
          key: UniqueKey(),
          //facesdkPlugin: widget.facesdkPlugin
        ),
      ),
    );
  }

  Future<void> biometricLogin(BuildContext context) async {
    bool isAuthenticated = await _authRepository.authenticateBiometric();
    if (isAuthenticated) {
      CustomSnackbar.show(context, 'Welcome back!');
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
        "Biometric authentication failed",
        isError: true,
      );
    }
  }
}
