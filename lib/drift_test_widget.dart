import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:drift_db_viewer/drift_db_viewer.dart';
import 'package:drift_example/drift/database.dart';
import 'package:drift_example/drift/manager/db_manager.dart';
import 'package:flutter/material.dart';
import 'package:drift/drift.dart' as drift;
import "package:collection/collection.dart" show IterableExtension;

enum UPDATE_TYPE { localToNetwork, networkToLocal }

class DriftTestWidget extends StatefulWidget {
  const DriftTestWidget({Key? key}) : super(key: key);

  @override
  State<DriftTestWidget> createState() => _DriftTestWidgetState();
}

class _DriftTestWidgetState extends State<DriftTestWidget> {
  late Db _db;
  List<String> willChangeList = <String>[];

  @override
  void initState() {
    super.initState();
    _db = Db();
    addQueque();
    _testOnNetworkData();
  }

  void addQueque() {
    final list = List.generate(5000000, (index) => "user $index");
    setState(() {
      willChangeList = list;
    });
  }

  void resetQueque() {
    setState(() {
      willChangeList = [];
    });
  }

  List<T> updateQueque<T>({required List<T> list, required List<T> completedList}) {
    List<T> item = list.toSet().difference(completedList.toSet()).toList();
    setState(() {
      willChangeList = item as List<String>;
    });
    return item;
  }

  Future<List<Vehicle>> dummyNewList() async {
    final list1 = List.generate(
        480000,
        (index) => Vehicle(
              id: "$index",
              status: 0,
              serialName: index,
              operationAt: "2022-04-19T14:07:18.795536+03:00",
              updatedAt: "2022-04-19T14:07:18.795536+03:00",
              cardNumber: "4455",
              amount: 135,
              userId: "$index user",
              name: "user name $index",
            ));
    final list2 = List.generate(
        10000,
        (index) => Vehicle(
              id: "${index + 480001}",
              status: 0,
              serialName: index,
              operationAt: "2022-04-22T09:15:40.928394+03:00",
              updatedAt: "2022-04-22T09:15:40.928394+03:00",
              cardNumber: "4455",
              amount: 135,
              userId: "$index user",
              name: "user name $index",
            ));

    final list3 = List.generate(
        10000,
        (index) => Vehicle(
              id: "${index + 490002}",
              status: 0,
              serialName: index,
              operationAt: "2022-04-22T08:53:37.342673+03:00",
              updatedAt: "2022-04-22T08:53:37.342673+03:00",
              cardNumber: "4455",
              amount: 135,
              userId: "$index user",
              name: "user name $index",
            ));
    return Future.value([...list1, ...list2, ...list3]);
  }

  Future<List<VehicleTableCompanion>> dummyLocalList() async {
    final list1 = List.generate(
        480000,
        (index) => VehicleTableCompanion(
              id: drift.Value("$index"),
              status: const drift.Value(0),
              serialName: drift.Value(index),
              operationAt: const drift.Value("2022-04-19T14:07:18.795536+03:00"),
              updatedAt: const drift.Value("2022-04-19T14:07:18.795536+03:00"),
              cardNumber: const drift.Value("4455"),
              amount: const drift.Value(135),
              userId: drift.Value("$index user"),
              name: drift.Value("user name $index"),
            ));
    final list2 = List.generate(
        10000,
        (index) => VehicleTableCompanion(
              id: drift.Value("${index + 480001}"),
              status: const drift.Value(0),
              serialName: drift.Value(index),
              operationAt: const drift.Value("2022-04-22T09:12:40.928394+03:00"),
              updatedAt: const drift.Value("2022-04-22T09:12:40.928394+03:00"),
              cardNumber: const drift.Value("4455"),
              amount: const drift.Value(135),
              userId: drift.Value("$index user"),
              name: drift.Value("user name $index"),
            ));
    final list3 = List.generate(
        10000,
        (index) => VehicleTableCompanion(
              id: drift.Value("${index + 490002}"),
              status: const drift.Value(0),
              serialName: drift.Value(index),
              operationAt: const drift.Value("2022-04-22T08:55:37.342673+03:00"),
              updatedAt: const drift.Value("2022-04-22T08:55:37.342673+03:00"),
              cardNumber: const drift.Value("4455"),
              amount: const drift.Value(135),
              userId: drift.Value("$index user"),
              name: drift.Value("user name $index"),
            ));
    final res = [...list1, ...list2, ...list3];
    return Future.value(res);
  }

  Future<void> _testOnNetworkData() async {
    if (Platform.isLinux) {
      var result = await Process.run('ls', ['-l']);
      log(result.stdout);
    }
    final _dbManager = DataBaseManager<VehicleTableCompanion, Vehicle, $VehicleTableTable>(_db);

    ///await _db.deleteAll();
    await _dbManager.deleteAll();

    final newList = await dummyNewList();
    final res = await dummyLocalList();

    final date = DateTime.now();

    /// await _db.insetVehicleList(res);
    await _dbManager.insertItemList(res);
    log("ADD :: http data add performance ${date.difference(DateTime.now()).inMilliseconds}");

    /// get local db list
    ///List<Vehicle>? list = await _db.getVehicles();
    List<Vehicle>? list = await _dbManager.getItems();
    final searchDate = DateTime.now();
    final map = searchUpdatableList(list, newList);
    log("SEARCH  :: local length -> ${list!.length} ||| network length -> ${newList.length}, time : ${searchDate.difference(DateTime.now()).inMilliseconds} mls");

    if (map[UPDATE_TYPE.networkToLocal] != null) {
      final updateList = map[UPDATE_TYPE.networkToLocal]!;
      log("available network to local length : ${updateList.length}");

      final date2 = DateTime.now();
      ///await _db.updateVehicleItemsByVehicles(updateList as List<VehicleTableCompanion>);
      await _dbManager.updateItemsByItems(updateList as List<VehicleTableCompanion>);
      log("UPDATE :: update newData performance ${date2.difference(DateTime.now()).inMilliseconds}");
    }

    if (map[UPDATE_TYPE.localToNetwork] != null) {
      final updateListNetwork = map[UPDATE_TYPE.localToNetwork]!;
      log("available local to network length : ${updateListNetwork.length}");

    }
  }

  Map<UPDATE_TYPE, List> searchUpdatableList(List<Vehicle>? list, List<Vehicle> newList) {
    log("searching...");
    Map<UPDATE_TYPE, List> returnMap = {};
    List<VehicleTableCompanion> updateList = [];
    List<Vehicle> updateNetworkList = [];
    if (list != null) {
      final listDifference = list.toSet().difference(newList.toSet()).toList();
      final newListDiffrence = newList.toSet().difference(list.toSet()).toList();

      for (var e in listDifference) {
        final item = newListDiffrence.firstWhereOrNull((element) => element.id == e.id);
        if (item != null) {
          final compareTime = DateTime.parse(item.updatedAt!).difference(DateTime.parse(e.updatedAt!));
          if (compareTime.inMilliseconds > 0) {
            /// network to local items
            updateList.add(item.toCompanion(false));
            returnMap.addAll({UPDATE_TYPE.networkToLocal: updateList});
          }

          /// local to network items
          else if (compareTime.inMilliseconds < 0) {
            updateNetworkList.add(e);
            returnMap.addAll({UPDATE_TYPE.localToNetwork: updateNetworkList});
          }
        }
      }
    } else {
      return returnMap;
    }

    log("finished...");
    return returnMap;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: TextButton(
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) {
                  return DriftDbViewer(_db);
                },
              ));
            },
            child: const Text("Go viewer")),
      ),
    );
  }
}
