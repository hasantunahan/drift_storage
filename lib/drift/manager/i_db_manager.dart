import 'package:drift/drift.dart';

/// K type of model
/// T model companion type
abstract class IDBManager<T, K, R> {
  Future<List<K>?> getItems();
  Future<K?> getItemsById({required String id});
  Future<bool> updateItem(T vehicleTableCompanion);
  Future<int> updateItemByItem(K oldItem, T newItem,String? oldItemId);
  Future<bool> updateItemsByItems(List<T> newList);
  Future<int> insertItem(T insert);
  Future<bool> insertItemList(List<T> list);
  Future<int> deleteItems(String id);
  Future<void> deleteAll();
}
