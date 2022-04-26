// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// **************************************************************************
// MoorGenerator
// **************************************************************************

// ignore_for_file: unnecessary_brace_in_string_interps, unnecessary_this
class Vehicle extends DataClass implements Insertable<Vehicle> {
  final String id;
  final int? serialName;
  final String? name;
  final String? userId;
  final int? status;
  final String? operationAt;
  final String? updatedAt;
  final String? cardNumber;
  final int? amount;
  Vehicle(
      {required this.id,
      this.serialName,
      this.name,
      this.userId,
      this.status,
      this.operationAt,
      this.updatedAt,
      this.cardNumber,
      this.amount});
  factory Vehicle.fromData(Map<String, dynamic> data, {String? prefix}) {
    final effectivePrefix = prefix ?? '';
    return Vehicle(
      id: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}id'])!,
      serialName: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}serial_name']),
      name: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}name']),
      userId: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}user_id']),
      status: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}status']),
      operationAt: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}operation_at']),
      updatedAt: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}updated_at']),
      cardNumber: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}card_number']),
      amount: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}amount']),
    );
  }
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    if (!nullToAbsent || serialName != null) {
      map['serial_name'] = Variable<int?>(serialName);
    }
    if (!nullToAbsent || name != null) {
      map['name'] = Variable<String?>(name);
    }
    if (!nullToAbsent || userId != null) {
      map['user_id'] = Variable<String?>(userId);
    }
    if (!nullToAbsent || status != null) {
      map['status'] = Variable<int?>(status);
    }
    if (!nullToAbsent || operationAt != null) {
      map['operation_at'] = Variable<String?>(operationAt);
    }
    if (!nullToAbsent || updatedAt != null) {
      map['updated_at'] = Variable<String?>(updatedAt);
    }
    if (!nullToAbsent || cardNumber != null) {
      map['card_number'] = Variable<String?>(cardNumber);
    }
    if (!nullToAbsent || amount != null) {
      map['amount'] = Variable<int?>(amount);
    }
    return map;
  }

  VehicleTableCompanion toCompanion(bool nullToAbsent) {
    return VehicleTableCompanion(
      id: Value(id),
      serialName: serialName == null && nullToAbsent
          ? const Value.absent()
          : Value(serialName),
      name: name == null && nullToAbsent ? const Value.absent() : Value(name),
      userId:
          userId == null && nullToAbsent ? const Value.absent() : Value(userId),
      status:
          status == null && nullToAbsent ? const Value.absent() : Value(status),
      operationAt: operationAt == null && nullToAbsent
          ? const Value.absent()
          : Value(operationAt),
      updatedAt: updatedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(updatedAt),
      cardNumber: cardNumber == null && nullToAbsent
          ? const Value.absent()
          : Value(cardNumber),
      amount:
          amount == null && nullToAbsent ? const Value.absent() : Value(amount),
    );
  }

  factory Vehicle.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Vehicle(
      id: serializer.fromJson<String>(json['id']),
      serialName: serializer.fromJson<int?>(json['serialName']),
      name: serializer.fromJson<String?>(json['name']),
      userId: serializer.fromJson<String?>(json['user_id']),
      status: serializer.fromJson<int?>(json['status']),
      operationAt: serializer.fromJson<String?>(json['operation_at']),
      updatedAt: serializer.fromJson<String?>(json['updated_at']),
      cardNumber: serializer.fromJson<String?>(json['card_number']),
      amount: serializer.fromJson<int?>(json['amount']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'serialName': serializer.toJson<int?>(serialName),
      'name': serializer.toJson<String?>(name),
      'user_id': serializer.toJson<String?>(userId),
      'status': serializer.toJson<int?>(status),
      'operation_at': serializer.toJson<String?>(operationAt),
      'updated_at': serializer.toJson<String?>(updatedAt),
      'card_number': serializer.toJson<String?>(cardNumber),
      'amount': serializer.toJson<int?>(amount),
    };
  }

  Vehicle copyWith(
          {String? id,
          int? serialName,
          String? name,
          String? userId,
          int? status,
          String? operationAt,
          String? updatedAt,
          String? cardNumber,
          int? amount}) =>
      Vehicle(
        id: id ?? this.id,
        serialName: serialName ?? this.serialName,
        name: name ?? this.name,
        userId: userId ?? this.userId,
        status: status ?? this.status,
        operationAt: operationAt ?? this.operationAt,
        updatedAt: updatedAt ?? this.updatedAt,
        cardNumber: cardNumber ?? this.cardNumber,
        amount: amount ?? this.amount,
      );
  @override
  String toString() {
    return (StringBuffer('Vehicle(')
          ..write('id: $id, ')
          ..write('serialName: $serialName, ')
          ..write('name: $name, ')
          ..write('userId: $userId, ')
          ..write('status: $status, ')
          ..write('operationAt: $operationAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('cardNumber: $cardNumber, ')
          ..write('amount: $amount')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, serialName, name, userId, status,
      operationAt, updatedAt, cardNumber, amount);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Vehicle &&
          other.id == this.id &&
          other.serialName == this.serialName &&
          other.name == this.name &&
          other.userId == this.userId &&
          other.status == this.status &&
          other.operationAt == this.operationAt &&
          other.updatedAt == this.updatedAt &&
          other.cardNumber == this.cardNumber &&
          other.amount == this.amount);
}

class VehicleTableCompanion extends UpdateCompanion<Vehicle> {
  final Value<String> id;
  final Value<int?> serialName;
  final Value<String?> name;
  final Value<String?> userId;
  final Value<int?> status;
  final Value<String?> operationAt;
  final Value<String?> updatedAt;
  final Value<String?> cardNumber;
  final Value<int?> amount;
  const VehicleTableCompanion({
    this.id = const Value.absent(),
    this.serialName = const Value.absent(),
    this.name = const Value.absent(),
    this.userId = const Value.absent(),
    this.status = const Value.absent(),
    this.operationAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.cardNumber = const Value.absent(),
    this.amount = const Value.absent(),
  });
  VehicleTableCompanion.insert({
    required String id,
    this.serialName = const Value.absent(),
    this.name = const Value.absent(),
    this.userId = const Value.absent(),
    this.status = const Value.absent(),
    this.operationAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.cardNumber = const Value.absent(),
    this.amount = const Value.absent(),
  }) : id = Value(id);
  static Insertable<Vehicle> custom({
    Expression<String>? id,
    Expression<int?>? serialName,
    Expression<String?>? name,
    Expression<String?>? userId,
    Expression<int?>? status,
    Expression<String?>? operationAt,
    Expression<String?>? updatedAt,
    Expression<String?>? cardNumber,
    Expression<int?>? amount,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (serialName != null) 'serial_name': serialName,
      if (name != null) 'name': name,
      if (userId != null) 'user_id': userId,
      if (status != null) 'status': status,
      if (operationAt != null) 'operation_at': operationAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (cardNumber != null) 'card_number': cardNumber,
      if (amount != null) 'amount': amount,
    });
  }

  VehicleTableCompanion copyWith(
      {Value<String>? id,
      Value<int?>? serialName,
      Value<String?>? name,
      Value<String?>? userId,
      Value<int?>? status,
      Value<String?>? operationAt,
      Value<String?>? updatedAt,
      Value<String?>? cardNumber,
      Value<int?>? amount}) {
    return VehicleTableCompanion(
      id: id ?? this.id,
      serialName: serialName ?? this.serialName,
      name: name ?? this.name,
      userId: userId ?? this.userId,
      status: status ?? this.status,
      operationAt: operationAt ?? this.operationAt,
      updatedAt: updatedAt ?? this.updatedAt,
      cardNumber: cardNumber ?? this.cardNumber,
      amount: amount ?? this.amount,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (serialName.present) {
      map['serial_name'] = Variable<int?>(serialName.value);
    }
    if (name.present) {
      map['name'] = Variable<String?>(name.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<String?>(userId.value);
    }
    if (status.present) {
      map['status'] = Variable<int?>(status.value);
    }
    if (operationAt.present) {
      map['operation_at'] = Variable<String?>(operationAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<String?>(updatedAt.value);
    }
    if (cardNumber.present) {
      map['card_number'] = Variable<String?>(cardNumber.value);
    }
    if (amount.present) {
      map['amount'] = Variable<int?>(amount.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('VehicleTableCompanion(')
          ..write('id: $id, ')
          ..write('serialName: $serialName, ')
          ..write('name: $name, ')
          ..write('userId: $userId, ')
          ..write('status: $status, ')
          ..write('operationAt: $operationAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('cardNumber: $cardNumber, ')
          ..write('amount: $amount')
          ..write(')'))
        .toString();
  }
}

class $VehicleTableTable extends VehicleTable
    with TableInfo<$VehicleTableTable, Vehicle> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $VehicleTableTable(this.attachedDatabase, [this._alias]);
  final VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String?> id = GeneratedColumn<String?>(
      'id', aliasedName, false,
      type: const StringType(), requiredDuringInsert: true);
  final VerificationMeta _serialNameMeta = const VerificationMeta('serialName');
  @override
  late final GeneratedColumn<int?> serialName = GeneratedColumn<int?>(
      'serial_name', aliasedName, true,
      type: const IntType(), requiredDuringInsert: false);
  final VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String?> name = GeneratedColumn<String?>(
      'name', aliasedName, true,
      type: const StringType(), requiredDuringInsert: false);
  final VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<String?> userId = GeneratedColumn<String?>(
      'user_id', aliasedName, true,
      type: const StringType(), requiredDuringInsert: false);
  final VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<int?> status = GeneratedColumn<int?>(
      'status', aliasedName, true,
      type: const IntType(), requiredDuringInsert: false);
  final VerificationMeta _operationAtMeta =
      const VerificationMeta('operationAt');
  @override
  late final GeneratedColumn<String?> operationAt = GeneratedColumn<String?>(
      'operation_at', aliasedName, true,
      type: const StringType(), requiredDuringInsert: false);
  final VerificationMeta _updatedAtMeta = const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<String?> updatedAt = GeneratedColumn<String?>(
      'updated_at', aliasedName, true,
      type: const StringType(), requiredDuringInsert: false);
  final VerificationMeta _cardNumberMeta = const VerificationMeta('cardNumber');
  @override
  late final GeneratedColumn<String?> cardNumber = GeneratedColumn<String?>(
      'card_number', aliasedName, true,
      type: const StringType(), requiredDuringInsert: false);
  final VerificationMeta _amountMeta = const VerificationMeta('amount');
  @override
  late final GeneratedColumn<int?> amount = GeneratedColumn<int?>(
      'amount', aliasedName, true,
      type: const IntType(), requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        serialName,
        name,
        userId,
        status,
        operationAt,
        updatedAt,
        cardNumber,
        amount
      ];
  @override
  String get aliasedName => _alias ?? 'vehicle_table';
  @override
  String get actualTableName => 'vehicle_table';
  @override
  VerificationContext validateIntegrity(Insertable<Vehicle> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('serial_name')) {
      context.handle(
          _serialNameMeta,
          serialName.isAcceptableOrUnknown(
              data['serial_name']!, _serialNameMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    }
    if (data.containsKey('user_id')) {
      context.handle(_userIdMeta,
          userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta));
    }
    if (data.containsKey('status')) {
      context.handle(_statusMeta,
          status.isAcceptableOrUnknown(data['status']!, _statusMeta));
    }
    if (data.containsKey('operation_at')) {
      context.handle(
          _operationAtMeta,
          operationAt.isAcceptableOrUnknown(
              data['operation_at']!, _operationAtMeta));
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    }
    if (data.containsKey('card_number')) {
      context.handle(
          _cardNumberMeta,
          cardNumber.isAcceptableOrUnknown(
              data['card_number']!, _cardNumberMeta));
    }
    if (data.containsKey('amount')) {
      context.handle(_amountMeta,
          amount.isAcceptableOrUnknown(data['amount']!, _amountMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Vehicle map(Map<String, dynamic> data, {String? tablePrefix}) {
    return Vehicle.fromData(data,
        prefix: tablePrefix != null ? '$tablePrefix.' : null);
  }

  @override
  $VehicleTableTable createAlias(String alias) {
    return $VehicleTableTable(attachedDatabase, alias);
  }
}

abstract class _$Db extends GeneratedDatabase {
  _$Db(QueryExecutor e) : super(SqlTypeSystem.defaultInstance, e);
  late final $VehicleTableTable vehicleTable = $VehicleTableTable(this);
  @override
  Iterable<TableInfo> get allTables => allSchemaEntities.whereType<TableInfo>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [vehicleTable];
}
