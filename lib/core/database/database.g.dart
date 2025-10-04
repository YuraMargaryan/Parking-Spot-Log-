// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
class $TableJournalTable extends TableJournal
    with TableInfo<$TableJournalTable, TableJournalData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TableJournalTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _startDateMeta = const VerificationMeta(
    'startDate',
  );
  @override
  late final GeneratedColumn<DateTime> startDate = GeneratedColumn<DateTime>(
    'start_date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _endDateMeta = const VerificationMeta(
    'endDate',
  );
  @override
  late final GeneratedColumn<DateTime> endDate = GeneratedColumn<DateTime>(
    'end_date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _priceMeta = const VerificationMeta('price');
  @override
  late final GeneratedColumn<double> price = GeneratedColumn<double>(
    'price',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _conditionsMeta = const VerificationMeta(
    'conditions',
  );
  @override
  late final GeneratedColumn<String> conditions = GeneratedColumn<String>(
    'conditions',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    startDate,
    endDate,
    price,
    conditions,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'table_journal';
  @override
  VerificationContext validateIntegrity(
    Insertable<TableJournalData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('start_date')) {
      context.handle(
        _startDateMeta,
        startDate.isAcceptableOrUnknown(data['start_date']!, _startDateMeta),
      );
    } else if (isInserting) {
      context.missing(_startDateMeta);
    }
    if (data.containsKey('end_date')) {
      context.handle(
        _endDateMeta,
        endDate.isAcceptableOrUnknown(data['end_date']!, _endDateMeta),
      );
    } else if (isInserting) {
      context.missing(_endDateMeta);
    }
    if (data.containsKey('price')) {
      context.handle(
        _priceMeta,
        price.isAcceptableOrUnknown(data['price']!, _priceMeta),
      );
    } else if (isInserting) {
      context.missing(_priceMeta);
    }
    if (data.containsKey('conditions')) {
      context.handle(
        _conditionsMeta,
        conditions.isAcceptableOrUnknown(data['conditions']!, _conditionsMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  TableJournalData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TableJournalData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      startDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}start_date'],
      )!,
      endDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}end_date'],
      )!,
      price: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}price'],
      )!,
      conditions: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}conditions'],
      ),
    );
  }

  @override
  $TableJournalTable createAlias(String alias) {
    return $TableJournalTable(attachedDatabase, alias);
  }
}

class TableJournalData extends DataClass
    implements Insertable<TableJournalData> {
  final int id;
  final DateTime startDate;
  final DateTime endDate;
  final double price;
  final String? conditions;
  const TableJournalData({
    required this.id,
    required this.startDate,
    required this.endDate,
    required this.price,
    this.conditions,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['start_date'] = Variable<DateTime>(startDate);
    map['end_date'] = Variable<DateTime>(endDate);
    map['price'] = Variable<double>(price);
    if (!nullToAbsent || conditions != null) {
      map['conditions'] = Variable<String>(conditions);
    }
    return map;
  }

  TableJournalCompanion toCompanion(bool nullToAbsent) {
    return TableJournalCompanion(
      id: Value(id),
      startDate: Value(startDate),
      endDate: Value(endDate),
      price: Value(price),
      conditions: conditions == null && nullToAbsent
          ? const Value.absent()
          : Value(conditions),
    );
  }

  factory TableJournalData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TableJournalData(
      id: serializer.fromJson<int>(json['id']),
      startDate: serializer.fromJson<DateTime>(json['startDate']),
      endDate: serializer.fromJson<DateTime>(json['endDate']),
      price: serializer.fromJson<double>(json['price']),
      conditions: serializer.fromJson<String?>(json['conditions']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'startDate': serializer.toJson<DateTime>(startDate),
      'endDate': serializer.toJson<DateTime>(endDate),
      'price': serializer.toJson<double>(price),
      'conditions': serializer.toJson<String?>(conditions),
    };
  }

  TableJournalData copyWith({
    int? id,
    DateTime? startDate,
    DateTime? endDate,
    double? price,
    Value<String?> conditions = const Value.absent(),
  }) => TableJournalData(
    id: id ?? this.id,
    startDate: startDate ?? this.startDate,
    endDate: endDate ?? this.endDate,
    price: price ?? this.price,
    conditions: conditions.present ? conditions.value : this.conditions,
  );
  TableJournalData copyWithCompanion(TableJournalCompanion data) {
    return TableJournalData(
      id: data.id.present ? data.id.value : this.id,
      startDate: data.startDate.present ? data.startDate.value : this.startDate,
      endDate: data.endDate.present ? data.endDate.value : this.endDate,
      price: data.price.present ? data.price.value : this.price,
      conditions: data.conditions.present
          ? data.conditions.value
          : this.conditions,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TableJournalData(')
          ..write('id: $id, ')
          ..write('startDate: $startDate, ')
          ..write('endDate: $endDate, ')
          ..write('price: $price, ')
          ..write('conditions: $conditions')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, startDate, endDate, price, conditions);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TableJournalData &&
          other.id == this.id &&
          other.startDate == this.startDate &&
          other.endDate == this.endDate &&
          other.price == this.price &&
          other.conditions == this.conditions);
}

class TableJournalCompanion extends UpdateCompanion<TableJournalData> {
  final Value<int> id;
  final Value<DateTime> startDate;
  final Value<DateTime> endDate;
  final Value<double> price;
  final Value<String?> conditions;
  const TableJournalCompanion({
    this.id = const Value.absent(),
    this.startDate = const Value.absent(),
    this.endDate = const Value.absent(),
    this.price = const Value.absent(),
    this.conditions = const Value.absent(),
  });
  TableJournalCompanion.insert({
    this.id = const Value.absent(),
    required DateTime startDate,
    required DateTime endDate,
    required double price,
    this.conditions = const Value.absent(),
  }) : startDate = Value(startDate),
       endDate = Value(endDate),
       price = Value(price);
  static Insertable<TableJournalData> custom({
    Expression<int>? id,
    Expression<DateTime>? startDate,
    Expression<DateTime>? endDate,
    Expression<double>? price,
    Expression<String>? conditions,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (startDate != null) 'start_date': startDate,
      if (endDate != null) 'end_date': endDate,
      if (price != null) 'price': price,
      if (conditions != null) 'conditions': conditions,
    });
  }

  TableJournalCompanion copyWith({
    Value<int>? id,
    Value<DateTime>? startDate,
    Value<DateTime>? endDate,
    Value<double>? price,
    Value<String?>? conditions,
  }) {
    return TableJournalCompanion(
      id: id ?? this.id,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      price: price ?? this.price,
      conditions: conditions ?? this.conditions,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (startDate.present) {
      map['start_date'] = Variable<DateTime>(startDate.value);
    }
    if (endDate.present) {
      map['end_date'] = Variable<DateTime>(endDate.value);
    }
    if (price.present) {
      map['price'] = Variable<double>(price.value);
    }
    if (conditions.present) {
      map['conditions'] = Variable<String>(conditions.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TableJournalCompanion(')
          ..write('id: $id, ')
          ..write('startDate: $startDate, ')
          ..write('endDate: $endDate, ')
          ..write('price: $price, ')
          ..write('conditions: $conditions')
          ..write(')'))
        .toString();
  }
}

class $TablePushTable extends TablePush
    with TableInfo<$TablePushTable, TablePushData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TablePushTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _remindAtMeta = const VerificationMeta(
    'remindAt',
  );
  @override
  late final GeneratedColumn<DateTime> remindAt = GeneratedColumn<DateTime>(
    'remind_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _isActiveMeta = const VerificationMeta(
    'isActive',
  );
  @override
  late final GeneratedColumn<bool> isActive = GeneratedColumn<bool>(
    'is_active',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_active" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  @override
  List<GeneratedColumn> get $columns => [id, title, remindAt, isActive];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'table_push';
  @override
  VerificationContext validateIntegrity(
    Insertable<TablePushData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('remind_at')) {
      context.handle(
        _remindAtMeta,
        remindAt.isAcceptableOrUnknown(data['remind_at']!, _remindAtMeta),
      );
    } else if (isInserting) {
      context.missing(_remindAtMeta);
    }
    if (data.containsKey('is_active')) {
      context.handle(
        _isActiveMeta,
        isActive.isAcceptableOrUnknown(data['is_active']!, _isActiveMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  TablePushData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TablePushData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      remindAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}remind_at'],
      )!,
      isActive: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_active'],
      )!,
    );
  }

  @override
  $TablePushTable createAlias(String alias) {
    return $TablePushTable(attachedDatabase, alias);
  }
}

class TablePushData extends DataClass implements Insertable<TablePushData> {
  final int id;
  final String title;
  final DateTime remindAt;
  final bool isActive;
  const TablePushData({
    required this.id,
    required this.title,
    required this.remindAt,
    required this.isActive,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['title'] = Variable<String>(title);
    map['remind_at'] = Variable<DateTime>(remindAt);
    map['is_active'] = Variable<bool>(isActive);
    return map;
  }

  TablePushCompanion toCompanion(bool nullToAbsent) {
    return TablePushCompanion(
      id: Value(id),
      title: Value(title),
      remindAt: Value(remindAt),
      isActive: Value(isActive),
    );
  }

  factory TablePushData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TablePushData(
      id: serializer.fromJson<int>(json['id']),
      title: serializer.fromJson<String>(json['title']),
      remindAt: serializer.fromJson<DateTime>(json['remindAt']),
      isActive: serializer.fromJson<bool>(json['isActive']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'title': serializer.toJson<String>(title),
      'remindAt': serializer.toJson<DateTime>(remindAt),
      'isActive': serializer.toJson<bool>(isActive),
    };
  }

  TablePushData copyWith({
    int? id,
    String? title,
    DateTime? remindAt,
    bool? isActive,
  }) => TablePushData(
    id: id ?? this.id,
    title: title ?? this.title,
    remindAt: remindAt ?? this.remindAt,
    isActive: isActive ?? this.isActive,
  );
  TablePushData copyWithCompanion(TablePushCompanion data) {
    return TablePushData(
      id: data.id.present ? data.id.value : this.id,
      title: data.title.present ? data.title.value : this.title,
      remindAt: data.remindAt.present ? data.remindAt.value : this.remindAt,
      isActive: data.isActive.present ? data.isActive.value : this.isActive,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TablePushData(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('remindAt: $remindAt, ')
          ..write('isActive: $isActive')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, title, remindAt, isActive);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TablePushData &&
          other.id == this.id &&
          other.title == this.title &&
          other.remindAt == this.remindAt &&
          other.isActive == this.isActive);
}

class TablePushCompanion extends UpdateCompanion<TablePushData> {
  final Value<int> id;
  final Value<String> title;
  final Value<DateTime> remindAt;
  final Value<bool> isActive;
  const TablePushCompanion({
    this.id = const Value.absent(),
    this.title = const Value.absent(),
    this.remindAt = const Value.absent(),
    this.isActive = const Value.absent(),
  });
  TablePushCompanion.insert({
    this.id = const Value.absent(),
    required String title,
    required DateTime remindAt,
    this.isActive = const Value.absent(),
  }) : title = Value(title),
       remindAt = Value(remindAt);
  static Insertable<TablePushData> custom({
    Expression<int>? id,
    Expression<String>? title,
    Expression<DateTime>? remindAt,
    Expression<bool>? isActive,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (title != null) 'title': title,
      if (remindAt != null) 'remind_at': remindAt,
      if (isActive != null) 'is_active': isActive,
    });
  }

  TablePushCompanion copyWith({
    Value<int>? id,
    Value<String>? title,
    Value<DateTime>? remindAt,
    Value<bool>? isActive,
  }) {
    return TablePushCompanion(
      id: id ?? this.id,
      title: title ?? this.title,
      remindAt: remindAt ?? this.remindAt,
      isActive: isActive ?? this.isActive,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (remindAt.present) {
      map['remind_at'] = Variable<DateTime>(remindAt.value);
    }
    if (isActive.present) {
      map['is_active'] = Variable<bool>(isActive.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TablePushCompanion(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('remindAt: $remindAt, ')
          ..write('isActive: $isActive')
          ..write(')'))
        .toString();
  }
}

class $TableMapTable extends TableMap
    with TableInfo<$TableMapTable, TableMapData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TableMapTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _addressMeta = const VerificationMeta(
    'address',
  );
  @override
  late final GeneratedColumn<String> address = GeneratedColumn<String>(
    'address',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _latitudeMeta = const VerificationMeta(
    'latitude',
  );
  @override
  late final GeneratedColumn<double> latitude = GeneratedColumn<double>(
    'latitude',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _longitudeMeta = const VerificationMeta(
    'longitude',
  );
  @override
  late final GeneratedColumn<double> longitude = GeneratedColumn<double>(
    'longitude',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    address,
    latitude,
    longitude,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'table_map';
  @override
  VerificationContext validateIntegrity(
    Insertable<TableMapData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    }
    if (data.containsKey('address')) {
      context.handle(
        _addressMeta,
        address.isAcceptableOrUnknown(data['address']!, _addressMeta),
      );
    } else if (isInserting) {
      context.missing(_addressMeta);
    }
    if (data.containsKey('latitude')) {
      context.handle(
        _latitudeMeta,
        latitude.isAcceptableOrUnknown(data['latitude']!, _latitudeMeta),
      );
    } else if (isInserting) {
      context.missing(_latitudeMeta);
    }
    if (data.containsKey('longitude')) {
      context.handle(
        _longitudeMeta,
        longitude.isAcceptableOrUnknown(data['longitude']!, _longitudeMeta),
      );
    } else if (isInserting) {
      context.missing(_longitudeMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  TableMapData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TableMapData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      ),
      address: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}address'],
      )!,
      latitude: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}latitude'],
      )!,
      longitude: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}longitude'],
      )!,
    );
  }

  @override
  $TableMapTable createAlias(String alias) {
    return $TableMapTable(attachedDatabase, alias);
  }
}

class TableMapData extends DataClass implements Insertable<TableMapData> {
  final int id;
  final String? name;
  final String address;
  final double latitude;
  final double longitude;
  const TableMapData({
    required this.id,
    this.name,
    required this.address,
    required this.latitude,
    required this.longitude,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    if (!nullToAbsent || name != null) {
      map['name'] = Variable<String>(name);
    }
    map['address'] = Variable<String>(address);
    map['latitude'] = Variable<double>(latitude);
    map['longitude'] = Variable<double>(longitude);
    return map;
  }

  TableMapCompanion toCompanion(bool nullToAbsent) {
    return TableMapCompanion(
      id: Value(id),
      name: name == null && nullToAbsent ? const Value.absent() : Value(name),
      address: Value(address),
      latitude: Value(latitude),
      longitude: Value(longitude),
    );
  }

  factory TableMapData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TableMapData(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String?>(json['name']),
      address: serializer.fromJson<String>(json['address']),
      latitude: serializer.fromJson<double>(json['latitude']),
      longitude: serializer.fromJson<double>(json['longitude']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String?>(name),
      'address': serializer.toJson<String>(address),
      'latitude': serializer.toJson<double>(latitude),
      'longitude': serializer.toJson<double>(longitude),
    };
  }

  TableMapData copyWith({
    int? id,
    Value<String?> name = const Value.absent(),
    String? address,
    double? latitude,
    double? longitude,
  }) => TableMapData(
    id: id ?? this.id,
    name: name.present ? name.value : this.name,
    address: address ?? this.address,
    latitude: latitude ?? this.latitude,
    longitude: longitude ?? this.longitude,
  );
  TableMapData copyWithCompanion(TableMapCompanion data) {
    return TableMapData(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      address: data.address.present ? data.address.value : this.address,
      latitude: data.latitude.present ? data.latitude.value : this.latitude,
      longitude: data.longitude.present ? data.longitude.value : this.longitude,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TableMapData(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('address: $address, ')
          ..write('latitude: $latitude, ')
          ..write('longitude: $longitude')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, address, latitude, longitude);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TableMapData &&
          other.id == this.id &&
          other.name == this.name &&
          other.address == this.address &&
          other.latitude == this.latitude &&
          other.longitude == this.longitude);
}

class TableMapCompanion extends UpdateCompanion<TableMapData> {
  final Value<int> id;
  final Value<String?> name;
  final Value<String> address;
  final Value<double> latitude;
  final Value<double> longitude;
  const TableMapCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.address = const Value.absent(),
    this.latitude = const Value.absent(),
    this.longitude = const Value.absent(),
  });
  TableMapCompanion.insert({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    required String address,
    required double latitude,
    required double longitude,
  }) : address = Value(address),
       latitude = Value(latitude),
       longitude = Value(longitude);
  static Insertable<TableMapData> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? address,
    Expression<double>? latitude,
    Expression<double>? longitude,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (address != null) 'address': address,
      if (latitude != null) 'latitude': latitude,
      if (longitude != null) 'longitude': longitude,
    });
  }

  TableMapCompanion copyWith({
    Value<int>? id,
    Value<String?>? name,
    Value<String>? address,
    Value<double>? latitude,
    Value<double>? longitude,
  }) {
    return TableMapCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      address: address ?? this.address,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (address.present) {
      map['address'] = Variable<String>(address.value);
    }
    if (latitude.present) {
      map['latitude'] = Variable<double>(latitude.value);
    }
    if (longitude.present) {
      map['longitude'] = Variable<double>(longitude.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TableMapCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('address: $address, ')
          ..write('latitude: $latitude, ')
          ..write('longitude: $longitude')
          ..write(')'))
        .toString();
  }
}

class $TableNoteTable extends TableNote
    with TableInfo<$TableNoteTable, TableNoteData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TableNoteTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _descriptionMeta = const VerificationMeta(
    'description',
  );
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
    'description',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [id, name, description, createdAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'table_note';
  @override
  VerificationContext validateIntegrity(
    Insertable<TableNoteData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
        _descriptionMeta,
        description.isAcceptableOrUnknown(
          data['description']!,
          _descriptionMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_descriptionMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  TableNoteData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TableNoteData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $TableNoteTable createAlias(String alias) {
    return $TableNoteTable(attachedDatabase, alias);
  }
}

class TableNoteData extends DataClass implements Insertable<TableNoteData> {
  final int id;
  final String name;
  final String description;
  final DateTime createdAt;
  const TableNoteData({
    required this.id,
    required this.name,
    required this.description,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['description'] = Variable<String>(description);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  TableNoteCompanion toCompanion(bool nullToAbsent) {
    return TableNoteCompanion(
      id: Value(id),
      name: Value(name),
      description: Value(description),
      createdAt: Value(createdAt),
    );
  }

  factory TableNoteData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TableNoteData(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      description: serializer.fromJson<String>(json['description']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'description': serializer.toJson<String>(description),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  TableNoteData copyWith({
    int? id,
    String? name,
    String? description,
    DateTime? createdAt,
  }) => TableNoteData(
    id: id ?? this.id,
    name: name ?? this.name,
    description: description ?? this.description,
    createdAt: createdAt ?? this.createdAt,
  );
  TableNoteData copyWithCompanion(TableNoteCompanion data) {
    return TableNoteData(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      description: data.description.present
          ? data.description.value
          : this.description,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TableNoteData(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('description: $description, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, description, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TableNoteData &&
          other.id == this.id &&
          other.name == this.name &&
          other.description == this.description &&
          other.createdAt == this.createdAt);
}

class TableNoteCompanion extends UpdateCompanion<TableNoteData> {
  final Value<int> id;
  final Value<String> name;
  final Value<String> description;
  final Value<DateTime> createdAt;
  const TableNoteCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.description = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  TableNoteCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    required String description,
    this.createdAt = const Value.absent(),
  }) : name = Value(name),
       description = Value(description);
  static Insertable<TableNoteData> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? description,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (description != null) 'description': description,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  TableNoteCompanion copyWith({
    Value<int>? id,
    Value<String>? name,
    Value<String>? description,
    Value<DateTime>? createdAt,
  }) {
    return TableNoteCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TableNoteCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('description: $description, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $TableJournalTable tableJournal = $TableJournalTable(this);
  late final $TablePushTable tablePush = $TablePushTable(this);
  late final $TableMapTable tableMap = $TableMapTable(this);
  late final $TableNoteTable tableNote = $TableNoteTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    tableJournal,
    tablePush,
    tableMap,
    tableNote,
  ];
}

typedef $$TableJournalTableCreateCompanionBuilder =
    TableJournalCompanion Function({
      Value<int> id,
      required DateTime startDate,
      required DateTime endDate,
      required double price,
      Value<String?> conditions,
    });
typedef $$TableJournalTableUpdateCompanionBuilder =
    TableJournalCompanion Function({
      Value<int> id,
      Value<DateTime> startDate,
      Value<DateTime> endDate,
      Value<double> price,
      Value<String?> conditions,
    });

class $$TableJournalTableFilterComposer
    extends Composer<_$AppDatabase, $TableJournalTable> {
  $$TableJournalTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get startDate => $composableBuilder(
    column: $table.startDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get endDate => $composableBuilder(
    column: $table.endDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get price => $composableBuilder(
    column: $table.price,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get conditions => $composableBuilder(
    column: $table.conditions,
    builder: (column) => ColumnFilters(column),
  );
}

class $$TableJournalTableOrderingComposer
    extends Composer<_$AppDatabase, $TableJournalTable> {
  $$TableJournalTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get startDate => $composableBuilder(
    column: $table.startDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get endDate => $composableBuilder(
    column: $table.endDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get price => $composableBuilder(
    column: $table.price,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get conditions => $composableBuilder(
    column: $table.conditions,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$TableJournalTableAnnotationComposer
    extends Composer<_$AppDatabase, $TableJournalTable> {
  $$TableJournalTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get startDate =>
      $composableBuilder(column: $table.startDate, builder: (column) => column);

  GeneratedColumn<DateTime> get endDate =>
      $composableBuilder(column: $table.endDate, builder: (column) => column);

  GeneratedColumn<double> get price =>
      $composableBuilder(column: $table.price, builder: (column) => column);

  GeneratedColumn<String> get conditions => $composableBuilder(
    column: $table.conditions,
    builder: (column) => column,
  );
}

class $$TableJournalTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $TableJournalTable,
          TableJournalData,
          $$TableJournalTableFilterComposer,
          $$TableJournalTableOrderingComposer,
          $$TableJournalTableAnnotationComposer,
          $$TableJournalTableCreateCompanionBuilder,
          $$TableJournalTableUpdateCompanionBuilder,
          (
            TableJournalData,
            BaseReferences<_$AppDatabase, $TableJournalTable, TableJournalData>,
          ),
          TableJournalData,
          PrefetchHooks Function()
        > {
  $$TableJournalTableTableManager(_$AppDatabase db, $TableJournalTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TableJournalTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TableJournalTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TableJournalTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<DateTime> startDate = const Value.absent(),
                Value<DateTime> endDate = const Value.absent(),
                Value<double> price = const Value.absent(),
                Value<String?> conditions = const Value.absent(),
              }) => TableJournalCompanion(
                id: id,
                startDate: startDate,
                endDate: endDate,
                price: price,
                conditions: conditions,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required DateTime startDate,
                required DateTime endDate,
                required double price,
                Value<String?> conditions = const Value.absent(),
              }) => TableJournalCompanion.insert(
                id: id,
                startDate: startDate,
                endDate: endDate,
                price: price,
                conditions: conditions,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$TableJournalTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $TableJournalTable,
      TableJournalData,
      $$TableJournalTableFilterComposer,
      $$TableJournalTableOrderingComposer,
      $$TableJournalTableAnnotationComposer,
      $$TableJournalTableCreateCompanionBuilder,
      $$TableJournalTableUpdateCompanionBuilder,
      (
        TableJournalData,
        BaseReferences<_$AppDatabase, $TableJournalTable, TableJournalData>,
      ),
      TableJournalData,
      PrefetchHooks Function()
    >;
typedef $$TablePushTableCreateCompanionBuilder =
    TablePushCompanion Function({
      Value<int> id,
      required String title,
      required DateTime remindAt,
      Value<bool> isActive,
    });
typedef $$TablePushTableUpdateCompanionBuilder =
    TablePushCompanion Function({
      Value<int> id,
      Value<String> title,
      Value<DateTime> remindAt,
      Value<bool> isActive,
    });

class $$TablePushTableFilterComposer
    extends Composer<_$AppDatabase, $TablePushTable> {
  $$TablePushTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get remindAt => $composableBuilder(
    column: $table.remindAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnFilters(column),
  );
}

class $$TablePushTableOrderingComposer
    extends Composer<_$AppDatabase, $TablePushTable> {
  $$TablePushTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get remindAt => $composableBuilder(
    column: $table.remindAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$TablePushTableAnnotationComposer
    extends Composer<_$AppDatabase, $TablePushTable> {
  $$TablePushTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<DateTime> get remindAt =>
      $composableBuilder(column: $table.remindAt, builder: (column) => column);

  GeneratedColumn<bool> get isActive =>
      $composableBuilder(column: $table.isActive, builder: (column) => column);
}

class $$TablePushTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $TablePushTable,
          TablePushData,
          $$TablePushTableFilterComposer,
          $$TablePushTableOrderingComposer,
          $$TablePushTableAnnotationComposer,
          $$TablePushTableCreateCompanionBuilder,
          $$TablePushTableUpdateCompanionBuilder,
          (
            TablePushData,
            BaseReferences<_$AppDatabase, $TablePushTable, TablePushData>,
          ),
          TablePushData,
          PrefetchHooks Function()
        > {
  $$TablePushTableTableManager(_$AppDatabase db, $TablePushTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TablePushTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TablePushTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TablePushTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<DateTime> remindAt = const Value.absent(),
                Value<bool> isActive = const Value.absent(),
              }) => TablePushCompanion(
                id: id,
                title: title,
                remindAt: remindAt,
                isActive: isActive,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String title,
                required DateTime remindAt,
                Value<bool> isActive = const Value.absent(),
              }) => TablePushCompanion.insert(
                id: id,
                title: title,
                remindAt: remindAt,
                isActive: isActive,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$TablePushTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $TablePushTable,
      TablePushData,
      $$TablePushTableFilterComposer,
      $$TablePushTableOrderingComposer,
      $$TablePushTableAnnotationComposer,
      $$TablePushTableCreateCompanionBuilder,
      $$TablePushTableUpdateCompanionBuilder,
      (
        TablePushData,
        BaseReferences<_$AppDatabase, $TablePushTable, TablePushData>,
      ),
      TablePushData,
      PrefetchHooks Function()
    >;
typedef $$TableMapTableCreateCompanionBuilder =
    TableMapCompanion Function({
      Value<int> id,
      Value<String?> name,
      required String address,
      required double latitude,
      required double longitude,
    });
typedef $$TableMapTableUpdateCompanionBuilder =
    TableMapCompanion Function({
      Value<int> id,
      Value<String?> name,
      Value<String> address,
      Value<double> latitude,
      Value<double> longitude,
    });

class $$TableMapTableFilterComposer
    extends Composer<_$AppDatabase, $TableMapTable> {
  $$TableMapTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get address => $composableBuilder(
    column: $table.address,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get latitude => $composableBuilder(
    column: $table.latitude,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get longitude => $composableBuilder(
    column: $table.longitude,
    builder: (column) => ColumnFilters(column),
  );
}

class $$TableMapTableOrderingComposer
    extends Composer<_$AppDatabase, $TableMapTable> {
  $$TableMapTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get address => $composableBuilder(
    column: $table.address,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get latitude => $composableBuilder(
    column: $table.latitude,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get longitude => $composableBuilder(
    column: $table.longitude,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$TableMapTableAnnotationComposer
    extends Composer<_$AppDatabase, $TableMapTable> {
  $$TableMapTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get address =>
      $composableBuilder(column: $table.address, builder: (column) => column);

  GeneratedColumn<double> get latitude =>
      $composableBuilder(column: $table.latitude, builder: (column) => column);

  GeneratedColumn<double> get longitude =>
      $composableBuilder(column: $table.longitude, builder: (column) => column);
}

class $$TableMapTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $TableMapTable,
          TableMapData,
          $$TableMapTableFilterComposer,
          $$TableMapTableOrderingComposer,
          $$TableMapTableAnnotationComposer,
          $$TableMapTableCreateCompanionBuilder,
          $$TableMapTableUpdateCompanionBuilder,
          (
            TableMapData,
            BaseReferences<_$AppDatabase, $TableMapTable, TableMapData>,
          ),
          TableMapData,
          PrefetchHooks Function()
        > {
  $$TableMapTableTableManager(_$AppDatabase db, $TableMapTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TableMapTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TableMapTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TableMapTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String?> name = const Value.absent(),
                Value<String> address = const Value.absent(),
                Value<double> latitude = const Value.absent(),
                Value<double> longitude = const Value.absent(),
              }) => TableMapCompanion(
                id: id,
                name: name,
                address: address,
                latitude: latitude,
                longitude: longitude,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String?> name = const Value.absent(),
                required String address,
                required double latitude,
                required double longitude,
              }) => TableMapCompanion.insert(
                id: id,
                name: name,
                address: address,
                latitude: latitude,
                longitude: longitude,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$TableMapTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $TableMapTable,
      TableMapData,
      $$TableMapTableFilterComposer,
      $$TableMapTableOrderingComposer,
      $$TableMapTableAnnotationComposer,
      $$TableMapTableCreateCompanionBuilder,
      $$TableMapTableUpdateCompanionBuilder,
      (
        TableMapData,
        BaseReferences<_$AppDatabase, $TableMapTable, TableMapData>,
      ),
      TableMapData,
      PrefetchHooks Function()
    >;
typedef $$TableNoteTableCreateCompanionBuilder =
    TableNoteCompanion Function({
      Value<int> id,
      required String name,
      required String description,
      Value<DateTime> createdAt,
    });
typedef $$TableNoteTableUpdateCompanionBuilder =
    TableNoteCompanion Function({
      Value<int> id,
      Value<String> name,
      Value<String> description,
      Value<DateTime> createdAt,
    });

class $$TableNoteTableFilterComposer
    extends Composer<_$AppDatabase, $TableNoteTable> {
  $$TableNoteTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$TableNoteTableOrderingComposer
    extends Composer<_$AppDatabase, $TableNoteTable> {
  $$TableNoteTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$TableNoteTableAnnotationComposer
    extends Composer<_$AppDatabase, $TableNoteTable> {
  $$TableNoteTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$TableNoteTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $TableNoteTable,
          TableNoteData,
          $$TableNoteTableFilterComposer,
          $$TableNoteTableOrderingComposer,
          $$TableNoteTableAnnotationComposer,
          $$TableNoteTableCreateCompanionBuilder,
          $$TableNoteTableUpdateCompanionBuilder,
          (
            TableNoteData,
            BaseReferences<_$AppDatabase, $TableNoteTable, TableNoteData>,
          ),
          TableNoteData,
          PrefetchHooks Function()
        > {
  $$TableNoteTableTableManager(_$AppDatabase db, $TableNoteTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TableNoteTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TableNoteTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TableNoteTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> description = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => TableNoteCompanion(
                id: id,
                name: name,
                description: description,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String name,
                required String description,
                Value<DateTime> createdAt = const Value.absent(),
              }) => TableNoteCompanion.insert(
                id: id,
                name: name,
                description: description,
                createdAt: createdAt,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$TableNoteTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $TableNoteTable,
      TableNoteData,
      $$TableNoteTableFilterComposer,
      $$TableNoteTableOrderingComposer,
      $$TableNoteTableAnnotationComposer,
      $$TableNoteTableCreateCompanionBuilder,
      $$TableNoteTableUpdateCompanionBuilder,
      (
        TableNoteData,
        BaseReferences<_$AppDatabase, $TableNoteTable, TableNoteData>,
      ),
      TableNoteData,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$TableJournalTableTableManager get tableJournal =>
      $$TableJournalTableTableManager(_db, _db.tableJournal);
  $$TablePushTableTableManager get tablePush =>
      $$TablePushTableTableManager(_db, _db.tablePush);
  $$TableMapTableTableManager get tableMap =>
      $$TableMapTableTableManager(_db, _db.tableMap);
  $$TableNoteTableTableManager get tableNote =>
      $$TableNoteTableTableManager(_db, _db.tableNote);
}
