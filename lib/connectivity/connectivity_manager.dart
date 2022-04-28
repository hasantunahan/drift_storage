import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';

class ConnectivityManager {
  ConnectivityManager._init();

  static ConnectivityManager? _instance;

  static ConnectivityManager get instance {
    _instance ??= ConnectivityManager._init();
    return _instance!;
  }

  bool isConnect = true;
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<ConnectivityResult> _streamSubscription;

  Future<bool> isNetworkAvaible() async {
    ConnectivityResult _result = await _connectivity.checkConnectivity();
    if (_result == ConnectivityResult.none) {
      return false;
    } else {
      return true;
    }
  }

  void connectionListener() {
    _streamSubscription = _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
  }

  void connectionListenerClose() {
    _streamSubscription.cancel();
  }

  void _updateConnectionStatus(ConnectivityResult result) {
    if (result == ConnectivityResult.none) {
      isConnect = false;
    } else {
      isConnect = true;
    }
  }
}
