import 'package:drift/drift.dart';
import 'package:drift_example/drift/manager/base_table.dart';

@DataClassName("Vehicle")
class VehicleTable extends Table with BaseTable{

  @override
  TextColumn get id => text()();

  IntColumn get serialName => integer().nullable()();

  TextColumn get name => text().nullable()();

  @JsonKey("user_id")
  TextColumn get userId => text().nullable()();

  IntColumn get status => integer().nullable()();

  @JsonKey("operation_at")
  TextColumn get operationAt => text().nullable()();

  @JsonKey("updated_at")
  TextColumn get updatedAt => text().nullable()();

  @JsonKey("card_number")
  TextColumn get cardNumber => text().nullable()();

  IntColumn get amount => integer().nullable()();

  @override
  Set<Column> get primaryKey => {id};

}
