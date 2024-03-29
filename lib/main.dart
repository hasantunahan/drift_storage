import 'dart:developer';

import 'package:drift_example/connectivity/connection_manager.dart';
import 'package:drift_example/drift_test_widget.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
 // connectionListening();
}

Future<void> connectionListening() async {
  //await ConnectionManager.instance.listen();
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const DriftTestWidget(),
    );
  }
}
