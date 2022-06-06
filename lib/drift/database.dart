
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
}

