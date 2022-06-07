import 'dart:developer';

import 'package:drift/drift.dart';
import 'package:drift_example/drift/database.dart';
import 'package:drift_example/drift/manager/base_table.dart';
import 'package:drift_example/drift/manager/i_db_manager.dart';

class DataBaseManager<T, K, R extends BaseTable> extends IDBManager<T, K, R> {
  final Db database;
  late TableInfo<R, K> table;
  DataBaseManager(this.database) {
    table = database.allTables.firstWhere((element) => element.runtimeType == R) as TableInfo<R, K>;
  }

  @override
  Future<List<K>?> getItems() async {
    try {
      return await database.select(table).get();
    } catch (e) {
      log("an error get item list $e");
      return null;
    }
  }

  @override
  Future<K?> getItemsById({required String id}) async {
    try {
      return await (database.select(table)
            ..where((tbl) {
              final _table = tbl;
              return _table.id!.equals(id);
            }))
          .getSingleOrNull();
    } catch (e) {
      log("an error get item by id $e");
    }
  }

  @override
  Future<bool> updateItem(T vehicleTableCompanion) async {
    try {
      return await database.update(table).replace(vehicleTableCompanion as Insertable<K>);
    } catch (e) {
      log("an error update $e");
      return false;
    }
  }

  /// TODO : oldItemId remove and then oldItem.id ????
  @override
  Future<int> updateItemByItem(K oldItem, T newItem, String? oldItemId) async {
    try {
      return await (database.update(table)
            ..where((tbl) {
              final _table = tbl;
              return _table.id!.equals(oldItemId);
            }))
          .write(newItem as Insertable<K>);
    } catch (e) {
      log("an error update item where $e");
      return 0;
    }
  }

  @override
  Future<bool> updateItemsByItems(List<T> newList) async {
    try {
      await database.batch((e) {
        e.replaceAll(table, newList as Iterable<Insertable<dynamic>>);
      });
      return true;
    } catch (e) {
      log("an error update list $e");
      return false;
    }
  }

  @override
  Future<int> insertItem(T insert) async {
    return await database.into(table).insert(insert as Insertable<K>);
  }

  @override
  Future<bool> insertItemList(List<T> list) async {
    try {
      await database.batch((b) {
        b.insertAll(table, list as Iterable<Insertable<dynamic>>);
      });
      return true;
    } catch (e) {
      log("an error add list $e");
      return false;
    }
  }

  @override
  Future<int> deleteItems(String id) async {
    try {
      return await (database.delete(table)
            ..where((tbl) {
              final _table = tbl;
              return _table.id!.equals(id);
            }))
          .go();
    } catch (e) {
      return 0;
    }
  }

  @override
  Future<void> deleteAll() async {
    try {
      await database.delete(table).go();
    } catch (e) {
      log("an error delete all $e");
    }
  }
}
