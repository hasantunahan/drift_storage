import 'dart:async';

import 'package:drift_example/connectivity/connectivity_manager.dart';
import 'package:drift_example/connectivity/service/connection_service.dart';

const listenDuration = Duration(milliseconds: 1500);

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
  late Stream<bool> connection;

  Future<void> listen() async {
    await manager.isNetworkAvaible();
    manager.connectionListener();
    _timer = Timer.periodic(listenDuration, (timer) {
      if (ConnectivityManager.instance.isConnect) {
        _service.isReachableNetwork().then((value) {
          connection = Stream.value(value);
        });
      } else {
        connection = Stream.value(false);
      }
    });
  }

  void closeListener() {
    ConnectivityManager.instance.connectionListenerClose();
    _timer.cancel();
  }
}
