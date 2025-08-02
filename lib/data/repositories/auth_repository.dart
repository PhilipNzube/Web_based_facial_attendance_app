import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mongo_dart/mongo_dart.dart' as mongo;
import 'package:local_auth/local_auth.dart';
import '../models/registrar_model.dart';

class AuthRepository {
  final storage = const FlutterSecureStorage();
  final LocalAuthentication _localAuth = LocalAuthentication();

  Future<bool> authenticateBiometric() async {
    bool canCheckBiometrics = await _localAuth.canCheckBiometrics;
    bool isDeviceSupported = await _localAuth.isDeviceSupported();

    if (!canCheckBiometrics || !isDeviceSupported) {
      return false;
    }

    try {
      return await _localAuth.authenticate(
        localizedReason: 'Please authenticate to access this app',
        options:
            const AuthenticationOptions(biometricOnly: true, stickyAuth: true),
      );
    } catch (e) {
      print("Biometric Authentication Error: $e");
      return false;
    }
  }

  Future<void> saveUserData(Registrar user) async {
    await storage.write(key: 'email', value: user.email);
    await storage.write(key: 'passcode', value: user.randomId.toString());
    await storage.write(key: 'fullName', value: user.fullName);
    await storage.write(key: 'id', value: user.randomId.toString());
  }
}
