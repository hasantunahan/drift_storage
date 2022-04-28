import 'dart:async';
import 'dart:developer';

import 'package:drift_example/connectivity/connectivity_manager.dart';
import 'package:drift_example/connectivity/service/connection_service.dart';

const listenDuration = Duration(milliseconds: 1000);

class ConnectionManager {
  ConnectionManager._init();

  static ConnectionManager? _instance;

  static ConnectionManager get instance {
    _instance ??= ConnectionManager._init();
    return _instance!;
  }

  ConnectionService get _service => ConnectionService();

  ConnectivityManager get manager => ConnectivityManager.instance;
  late Timer _timer;
  final StreamController<bool> connectionController = StreamController<bool>();

  Future<void> listen() async {
    await manager.isNetworkAvaible();
    manager.connectionListener();
    _timer = Timer.periodic(listenDuration, (timer) {
      if (ConnectivityManager.instance.isConnect) {
        _service.isReachableNetwork().then((value) {
          connectionController.add(value);
        });
      } else {
        connectionController.add(false);
      }
    });
  }

  void closeListener() {
    ConnectivityManager.instance.connectionListenerClose();
    _timer.cancel();
    connectionController.close();
  }
}
