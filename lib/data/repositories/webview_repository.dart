import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class WebViewRepository {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  Future<String> constructWebViewUrl() async {
    String? email = await _storage.read(key: 'email');
    String? passcode = await _storage.read(key: 'passcode');
    return 'https://www.enrollment.kogiagile.org/webview?email=$email&randomId=$passcode';
  }

  Future<bool> checkInternetConnection() async {
    var connectivityResult = await Connectivity().checkConnectivity();
    return connectivityResult != ConnectivityResult.none;
  }
}
