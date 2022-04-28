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

  @override
  void initState() {
    super.initState();
    _db = Db();
    //testVehicles();
    //updateTest();
    _testOnNetworkData();
  }

  Future<void> _testOnNetworkData() async {
    if (Platform.isLinux) {
      var result = await Process.run('ls', ['-l']);
      print(result.stdout);
    }

    await _db.deleteAll();
    final res = await getVehicleListHttp();
    final newList = await getNewList();

    log("its ok");
    for (var e in res) {
      log(e.id.value.toString());
    }

    final date = DateTime.now();
    await _db.insetVehicleList(res);
    log("ADD :: http data add performance ${date.difference(DateTime.now()).inMilliseconds}");

    /// get local db list
    List<Vehicle>? list = await _db.getVehicles();

    final map = searchUpdatableList(list, newList);
    final updateList = map[UPDATE_TYPE.NETWORK_TO_LOCAL]!;
    for (var element in updateList) {
      log("update list network to local: ${element.updatedAt.value}");
    }

    final updateListNetwork = map[UPDATE_TYPE.LOCAL_TO_NETWORK]!;
    for (var element in updateListNetwork) {
      log("update list local to network : ${element.updatedAt}");
    }

    final date2 = DateTime.now();
    await _db.updateVehicleItemsByVehicles(
        updateList as List<VehicleTableCompanion>);
    log("UPDATE :: update newData performance ${date2.difference(DateTime.now()).inMilliseconds}");
    //await _db.updateVehicleByVehicle(list.first, const VehicleTableCompanion(name: drift.Value("tunahan")));

    /*List<Vehicle> sliceList = list!
        .where((element) =>
            DateTime.parse(element.updatedAt!).difference(DateTime(2022, 4, 21)) > const Duration(seconds: 0))
        .toList();
    List<VehicleTableCompanion> companionList = [];
    for (var element in sliceList) {
      companionList.add(VehicleTableCompanion(
          id: drift.Value(element.id),
          amount: const drift.Value(555),
          serialName: drift.Value(element.serialName),
          updatedAt: drift.Value(element.updatedAt)));
    }

    final date2 = DateTime.now();
    await _db.updateVehicleItemsByVehicles(companionList);
    log("UPDATE :: http data add performance ${date2.difference(DateTime.now()).inMilliseconds}");*/
    //await _db.updateVehicleByVehicle(list.first, const VehicleTableCompanion(name: drift.Value("tunahan")));
  }

  Map<UPDATE_TYPE, List> searchUpdatableList(
      List<Vehicle>? list, List<Vehicle> newList) {
    Map<UPDATE_TYPE, List> returnMap = {};
    List<VehicleTableCompanion> updateList = [];
    List<Vehicle> updateNetworkList = [];
    for (var e in list!) {
      final item = newList.firstWhereOrNull((element) => element.id == e.id);
      if (item != null) {
        final compareTime = DateTime.parse(item.updatedAt!)
            .difference(DateTime.parse(e.updatedAt!));
        if (compareTime.inMilliseconds > 0) {
          /// network to local items
          updateList.add(VehicleTableCompanion(
            name: drift.Value(item.name),
            id: drift.Value(item.id),
            userId: drift.Value(item.userId),
            updatedAt: drift.Value(item.updatedAt),
            amount: drift.Value(item.amount),
            cardNumber: drift.Value(item.cardNumber),
            operationAt: drift.Value(item.operationAt),
            serialName: drift.Value(item.serialName),
            status: drift.Value(item.status),
          ));
          returnMap.addAll({UPDATE_TYPE.NETWORK_TO_LOCAL: updateList});
        }

        /// local to network items
        else if (compareTime.inMilliseconds < 0) {
          updateNetworkList.add(e);
          returnMap.addAll({UPDATE_TYPE.LOCAL_TO_NETWORK: updateNetworkList});
        }
      }
    }
    return returnMap;
  }

  Future<List<VehicleTableCompanion>> getVehicleListHttp() async {
    List<VehicleTableCompanion> companionList = [];
    final res =
        await _http.get(Uri.parse("http://localhost:8080/macaron.json"));
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
    final res =
        await _http.get(Uri.parse("http://localhost:8080/newList.json"));
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
        .where((element) =>
            DateTime.parse(element.updatedAt!).difference(DateTime.now()) >
            const Duration(seconds: 0))
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
