import 'dart:async';

import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../../data/repositories/webview_repository.dart';
import '../screens/online_webview/widgets/dialogs/error_dialog.dart';
import '../screens/online_webview/widgets/dialogs/no_internet_dialog.dart';
import '../screens/online_webview/widgets/dialogs/timeout_dialog.dart';

class OnlineWebViewController extends ChangeNotifier {
  final WebViewRepository _repository = WebViewRepository();
  late Future<WebViewController>
      _controllerFuture; // Use Future for WebViewController
  bool _isRefreshing = false;
  bool _isError = false;
  bool _isNoInternet = false;

  OnlineWebViewController() {
    _initialize();
  }

  //public getters
  Future<WebViewController> get controllerFuture => _controllerFuture;
  bool get isRefreshing => _isRefreshing;
  bool get isNoInternet => _isNoInternet;
  bool get isError => _isError;

  void _initialize() {
    checkInternetConnection();
    _controllerFuture = initializeWebView();
    notifyListeners();
  }

  void checkInternetConnection() async {
    bool hasInternet = await _repository.checkInternetConnection();
    if (!hasInternet) {
      _isNoInternet = true;
      notifyListeners();
    } else {
      _isNoInternet = false;
      notifyListeners();
      _controllerFuture = initializeWebView();
    }
  }

  Future<WebViewController> initializeWebView() async {
    String url = await _repository.constructWebViewUrl();
    final controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..loadRequest(Uri.parse(url));
    return controller;
  }

  Future<void> refreshData(BuildContext context) async {
    _isRefreshing = true;
    _isError = false;
    notifyListeners();

    try {
      bool hasInternet = await _repository.checkInternetConnection();
      if (!hasInternet) {
        showNoInternetDialog(context);

        _isRefreshing = false;
        notifyListeners();
        return;
      }

      await Future.any([
        Future.delayed(const Duration(seconds: 15), () {
          throw TimeoutException('The operation took too long.');
        }),
        _performDataFetch(),
      ]);
    } catch (e) {
      _isError = true;
      notifyListeners();
      if (e is TimeoutException) {
        showTimeoutDialog(context);
      } else {
        showErrorDialog(context, e.toString());
      }
    } finally {
      _isRefreshing = false;
      notifyListeners();
    }
  }

  Future<void> _performDataFetch() async {
    String url = await _repository.constructWebViewUrl();

    // Reload the WebView with the new URL
    final controller = await _controllerFuture;
    await controller.loadRequest(Uri.parse(url));
  }
}
