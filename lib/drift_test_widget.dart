import 'dart:async';
import 'dart:collection';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:drift_db_viewer/drift_db_viewer.dart';
import 'package:drift_example/drift/database.dart';
import 'package:flutter/material.dart';
import 'package:drift/drift.dart' as drift;
import 'package:http/http.dart' as _http;
import "package:collection/collection.dart" show IterableExtension;

enum UPDATE_TYPE { LOCAL_TO_NETWORK, NETWORK_TO_LOCAL }

class DriftTestWidget extends StatefulWidget {
  const DriftTestWidget({Key? key}) : super(key: key);

  @override
  State<DriftTestWidget> createState() => _DriftTestWidgetState();
}

class _DriftTestWidgetState extends State<DriftTestWidget> {
  late Db _db;
  List<String> willChangeList = <String>[];
  late StreamSubscription<bool> _subscription;
  bool connection = false;

  @override
  void initState() {
    super.initState();
    _db = Db();
    addQueque();

    //testVehicles();
    //updateTest();
    /// test 500.000 data {local to network} or {network to local} sync data
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

  Future<void> looseConnectionTest() async {
    for (var e in willChangeList) {
      log(connection.toString());
    }
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
      print(result.stdout);
    }

    await _db.deleteAll();
    //final res = await getVehicleListHttp();
    //final newList = await getNewList();
    final newList = await dummyNewList();
    final res = await dummyLocalList();

    final date = DateTime.now();
    await _db.insetVehicleList(res);
    log("ADD :: http data add performance ${date.difference(DateTime.now()).inMilliseconds}");

    /// get local db list
    List<Vehicle>? list = await _db.getVehicles();

    final searchDate = DateTime.now();
    final map = searchUpdatableList(list, newList);
    log("SEARCH  :: local length -> ${list!.length} ||| network length -> ${newList.length}, time : ${searchDate.difference(DateTime.now()).inMilliseconds} mls");

    if (map[UPDATE_TYPE.NETWORK_TO_LOCAL] != null) {
      final updateList = map[UPDATE_TYPE.NETWORK_TO_LOCAL]!;
      log("available network to local length : ${updateList.length}");
      /*for (var element in updateList) {
       // log("update list network to local: ${element.updatedAt.value}");

      }*/
      final date2 = DateTime.now();
      await _db.updateVehicleItemsByVehicles(updateList as List<VehicleTableCompanion>);
      log("UPDATE :: update newData performance ${date2.difference(DateTime.now()).inMilliseconds}");
    }

    if (map[UPDATE_TYPE.LOCAL_TO_NETWORK] != null) {
      final updateListNetwork = map[UPDATE_TYPE.LOCAL_TO_NETWORK]!;
      log("available local to network length : ${updateListNetwork.length}");
      /* for (var element in updateListNetwork) {
        log("update list local to network : ${element.updatedAt}");
      }*/
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
            returnMap.addAll({UPDATE_TYPE.NETWORK_TO_LOCAL: updateList});
          }

          /// local to network items
          else if (compareTime.inMilliseconds < 0) {
            updateNetworkList.add(e);
            returnMap.addAll({UPDATE_TYPE.LOCAL_TO_NETWORK: updateNetworkList});
          }
        }
      }
    } else {
      return returnMap;
    }

    log("finished...");
    return returnMap;
  }

  Future<List<VehicleTableCompanion>> getVehicleListHttp() async {
    List<VehicleTableCompanion> companionList = [];
    final res = await _http.get(Uri.parse("http://localhost:8080/macaron.json"));
    if (res.statusCode == 200) {
      var decodedResponse = jsonDecode(utf8.decode(res.bodyBytes)) as List;
      for (var element in decodedResponse) {
        companionList.add(Vehicle.fromJson(element).toCompanion(false));
      }
      return companionList;
    } else {
      return [];
    }
  }

  Future<List<Vehicle>> getNewList() async {
    List<Vehicle> companionList = [];
    final res = await _http.get(Uri.parse("http://localhost:8080/newList.json"));
    if (res.statusCode == 200) {
      var decodedResponse = jsonDecode(utf8.decode(res.bodyBytes)) as List;
      for (var element in decodedResponse) {
        companionList.add(Vehicle.fromJson(element));
      }
      return companionList;
    } else {
      return [];
    }
  }

  Future<void> updateTest() async {
    await _db.deleteAll();
    /*final allList = List.generate(
        5000,
        (index) => VehicleTableCompanion.insert(
            name: "user $index", serialName: index, updateAt: DateTime.now().add(Duration(milliseconds: index))));

    await _db.insetVehicleList(allList);*/
    List<Vehicle>? list = await _db.getVehicles();
    List<Vehicle> sliceList = list!
        .where((element) => DateTime.parse(element.updatedAt!).difference(DateTime.now()) > const Duration(seconds: 0))
        .toList();
    List<VehicleTableCompanion> companionList = [];
    for (var element in sliceList) {
      companionList.add(VehicleTableCompanion(
          name: const drift.Value("hasantunahan"),
          serialName: drift.Value(element.serialName),
          updatedAt: drift.Value(element.updatedAt)));
    }

    //await _db.updateVehicleByVehicle(list.first, const VehicleTableCompanion(name: drift.Value("tunahan")));
    await _db.updateVehicleItemsByVehicles(companionList);
    readVehicles();
  }

  Future<void> readVehicles() async {
    List<Vehicle>? _list = await _db.getVehicles();
    /*if (_list != null) {
      for (var element in _list) {
        log("read item :  ${element.name}");
      }
    }*/
  }

  Future<void> testVehicles() async {
    const vehicles = VehicleTableCompanion(
      name: drift.Value("hasan tunahan"),
    );
    await Future.delayed(const Duration(seconds: 1));

    final date = DateTime.now();
    await _db.insertVehicle(vehicles);
    log("ADD :: vehicle performance ${date.difference(DateTime.now()).inMilliseconds}");

    /* final date1 = DateTime.now();
    List<VehicleTableCompanion> vehicleCompanionList = List.generate(1100000,
        (index) => VehicleTableCompanion.insert(name: "$index hasan", serialName: index, updateAt: DateTime.now()));
    log("LIST GENERATE :: vehicle list generate performance ${date1.difference(DateTime.now()).inMilliseconds}");
*/
    /* final date2 = DateTime.now();
    await _db.insetVehicleList(vehicleCompanionList);
    log("ADD :: vehicle list performance ${date2.difference(DateTime.now()).inMilliseconds}");
*/
    final date3 = DateTime.now();
    await readVehicles();
    log("READ :: vehicle list read performance ${date3.difference(DateTime.now()).inMilliseconds}");

    final date4 = DateTime.now();
    await _db.getVehicleById(id: "100001");
    log("READ :: vehicle by id read performance ${date4.difference(DateTime.now()).inMilliseconds}");

    final date5 = DateTime.now();
    await _db.deleteAll();
    log("DELETE :: vehicle list delete performance ${date5.difference(DateTime.now()).inMilliseconds}");
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
