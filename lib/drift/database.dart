import 'dart:developer';
import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:drift_example/drift_model/vehicle_table.dart';
import 'package:encrypt/encrypt.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;

part 'database.g.dart';

LazyDatabase _openConnection() {
  final key = Key.fromUtf8('cRfUjXn2r5u8x/A?D(G+KbPeSgVkYp3s');
  final iv = IV.fromLength(16);
  final encrypter = Encrypter(AES(key));
  const driftname = "drift.db";

  return LazyDatabase(() async {
    final dir = await getApplicationDocumentsDirectory();
    log("dir path ${dir.path}");
    //runSh(dir.path);
    final file =
        File(path.join(dir.path, encrypter.encrypt(driftname, iv: iv).base64));
    return NativeDatabase(file);
  });
}

Future<void> runSh(String path) async {
  final goPath = await Process.run("mkdir",["hasan"],workingDirectory: path);
}

@DriftDatabase(tables: [VehicleTable])
class Db extends _$Db {
  Db() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  Future<List<Vehicle>?> getVehicles() async {
    try {
      return await select(vehicleTable).get();
    } catch (e) {
      log("an error get vehicle list $e");
      return null;
    }
  }

  Future<Vehicle?> getVehicleById({required String id}) async {
    try {
      return await (select(vehicleTable)..where((tbl) => tbl.id.equals(id)))
          .getSingleOrNull();
    } catch (e) {
      log("an error get vehicle by id $e");
    }
  }

  Future<bool> updateVehicle(
      VehicleTableCompanion vehicleTableCompanion) async {
    try {
      return await update(vehicleTable).replace(vehicleTableCompanion);
    } catch (e) {
      log("an error update $e");
      return false;
    }
  }

  Future<int> updateVehicleByVehicle(
      Vehicle oldItem, VehicleTableCompanion newItem) async {
    try {
      return await (update(vehicleTable)
            ..where((tbl) => tbl.id.equals(oldItem.id)))
          .write(newItem);
    } catch (e) {
      log("an error update vehicle where $e");
      return 0;
    }
  }

  Future<bool> updateVehicleItemsByVehicles(
      List<VehicleTableCompanion> newList) async {
    try {
      await batch((e) {
        e.replaceAll(vehicleTable, newList);
      });
      return true;
    } catch (e) {
      log("an error update list $e");
      return false;
    }
  }

  Future<int> insertVehicle(VehicleTableCompanion insert) async {
    return await into(vehicleTable).insert(insert);
  }

  /// [insertAll] , [VehicleTableCompanion.insert(),....]
  Future<bool> insetVehicleList(List<VehicleTableCompanion> list) async {
    try {
      await batch((b) {
        b.insertAll(vehicleTable, list);
      });
      return true;
    } catch (e) {
      log("an error add list $e");
      return false;
    }
  }

  Future<int> deleteVehicles(String id) async {
    try {
      return await (delete(vehicleTable)..where((tbl) => tbl.id.equals(id)))
          .go();
    } catch (e) {
      return 0;
    }
  }

  Future<void> deleteAll() async {
    try {
      await delete(vehicleTable).go();
    } catch (e) {
      log("an error delete all $e");
    }
  }
}
