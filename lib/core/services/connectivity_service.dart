import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';

class ConnectivityService {
  final _connectivity = Connectivity();
  StreamSubscription<ConnectivityResult>? _subscription;

  void startMonitoring(Function(ConnectivityResult) onChange) {
    _subscription = _connectivity.onConnectivityChanged.listen(onChange);
  }

  void dispose() {
    _subscription?.cancel();
  }
}
