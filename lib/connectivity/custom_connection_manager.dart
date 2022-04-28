import 'dart:async';
import 'dart:developer';

import 'package:drift_example/connectivity/connection_manager.dart';
import 'package:drift_example/connectivity/service/connection_service.dart';

const listenDuration = Duration(milliseconds: 1500);

class CustomConnectionManager {
  CustomConnectionManager._init();

  static CustomConnectionManager? _instance;

  static CustomConnectionManager get instance {
    _instance ??= CustomConnectionManager._init();
    return _instance!;
  }

  ConnectionService get _service => ConnectionService();

  ConnectionManager get manager => ConnectionManager.instance;
  late Timer _timer;
  late Stream<bool> connection;

  Future<void> listen() async {
    await manager.isNetworkAvaible();
    manager.connectionListener();
    _timer = Timer.periodic(listenDuration, (timer) {
      if (ConnectionManager.instance.isConnect) {
        _service.isReachableNetwork().then((value) {
          connection = Stream.value(value);
        });
      } else {
        connection = Stream.value(false);
      }
    });
  }

  void closeListener() {
    ConnectionManager.instance.connectionListenerClose();
    _timer.cancel();
  }
}
