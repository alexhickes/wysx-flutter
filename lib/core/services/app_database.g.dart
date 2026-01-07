// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $PlacesTableTable extends PlacesTable
    with TableInfo<$PlacesTableTable, PlacesTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PlacesTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
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
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('inactive'),
  );
  static const VerificationMeta _descriptionMeta = const VerificationMeta(
    'description',
  );
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
    'description',
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
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdByMeta = const VerificationMeta(
    'createdBy',
  );
  @override
  late final GeneratedColumn<String> createdBy = GeneratedColumn<String>(
    'created_by',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
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
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _syncStatusMeta = const VerificationMeta(
    'syncStatus',
  );
  @override
  late final GeneratedColumn<String> syncStatus = GeneratedColumn<String>(
    'sync_status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('synced'),
  );
  static const VerificationMeta _radiusMeta = const VerificationMeta('radius');
  @override
  late final GeneratedColumn<double> radius = GeneratedColumn<double>(
    'radius',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    latitude,
    longitude,
    status,
    description,
    address,
    createdBy,
    createdAt,
    updatedAt,
    syncStatus,
    radius,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'places';
  @override
  VerificationContext validateIntegrity(
    Insertable<PlacesTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
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
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    }
    if (data.containsKey('description')) {
      context.handle(
        _descriptionMeta,
        description.isAcceptableOrUnknown(
          data['description']!,
          _descriptionMeta,
        ),
      );
    }
    if (data.containsKey('address')) {
      context.handle(
        _addressMeta,
        address.isAcceptableOrUnknown(data['address']!, _addressMeta),
      );
    }
    if (data.containsKey('created_by')) {
      context.handle(
        _createdByMeta,
        createdBy.isAcceptableOrUnknown(data['created_by']!, _createdByMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    if (data.containsKey('sync_status')) {
      context.handle(
        _syncStatusMeta,
        syncStatus.isAcceptableOrUnknown(data['sync_status']!, _syncStatusMeta),
      );
    }
    if (data.containsKey('radius')) {
      context.handle(
        _radiusMeta,
        radius.isAcceptableOrUnknown(data['radius']!, _radiusMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  PlacesTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PlacesTableData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      latitude: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}latitude'],
      )!,
      longitude: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}longitude'],
      )!,
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      ),
      address: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}address'],
      ),
      createdBy: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}created_by'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      syncStatus: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}sync_status'],
      )!,
      radius: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}radius'],
      ),
    );
  }

  @override
  $PlacesTableTable createAlias(String alias) {
    return $PlacesTableTable(attachedDatabase, alias);
  }
}

class PlacesTableData extends DataClass implements Insertable<PlacesTableData> {
  final String id;
  final String name;
  final double latitude;
  final double longitude;
  final String status;
  final String? description;
  final String? address;
  final String? createdBy;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String syncStatus;
  final double? radius;
  const PlacesTableData({
    required this.id,
    required this.name,
    required this.latitude,
    required this.longitude,
    required this.status,
    this.description,
    this.address,
    this.createdBy,
    required this.createdAt,
    required this.updatedAt,
    required this.syncStatus,
    this.radius,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    map['latitude'] = Variable<double>(latitude);
    map['longitude'] = Variable<double>(longitude);
    map['status'] = Variable<String>(status);
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    if (!nullToAbsent || address != null) {
      map['address'] = Variable<String>(address);
    }
    if (!nullToAbsent || createdBy != null) {
      map['created_by'] = Variable<String>(createdBy);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    map['sync_status'] = Variable<String>(syncStatus);
    if (!nullToAbsent || radius != null) {
      map['radius'] = Variable<double>(radius);
    }
    return map;
  }

  PlacesTableCompanion toCompanion(bool nullToAbsent) {
    return PlacesTableCompanion(
      id: Value(id),
      name: Value(name),
      latitude: Value(latitude),
      longitude: Value(longitude),
      status: Value(status),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
      address: address == null && nullToAbsent
          ? const Value.absent()
          : Value(address),
      createdBy: createdBy == null && nullToAbsent
          ? const Value.absent()
          : Value(createdBy),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      syncStatus: Value(syncStatus),
      radius: radius == null && nullToAbsent
          ? const Value.absent()
          : Value(radius),
    );
  }

  factory PlacesTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PlacesTableData(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      latitude: serializer.fromJson<double>(json['latitude']),
      longitude: serializer.fromJson<double>(json['longitude']),
      status: serializer.fromJson<String>(json['status']),
      description: serializer.fromJson<String?>(json['description']),
      address: serializer.fromJson<String?>(json['address']),
      createdBy: serializer.fromJson<String?>(json['createdBy']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      syncStatus: serializer.fromJson<String>(json['syncStatus']),
      radius: serializer.fromJson<double?>(json['radius']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'latitude': serializer.toJson<double>(latitude),
      'longitude': serializer.toJson<double>(longitude),
      'status': serializer.toJson<String>(status),
      'description': serializer.toJson<String?>(description),
      'address': serializer.toJson<String?>(address),
      'createdBy': serializer.toJson<String?>(createdBy),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'syncStatus': serializer.toJson<String>(syncStatus),
      'radius': serializer.toJson<double?>(radius),
    };
  }

  PlacesTableData copyWith({
    String? id,
    String? name,
    double? latitude,
    double? longitude,
    String? status,
    Value<String?> description = const Value.absent(),
    Value<String?> address = const Value.absent(),
    Value<String?> createdBy = const Value.absent(),
    DateTime? createdAt,
    DateTime? updatedAt,
    String? syncStatus,
    Value<double?> radius = const Value.absent(),
  }) => PlacesTableData(
    id: id ?? this.id,
    name: name ?? this.name,
    latitude: latitude ?? this.latitude,
    longitude: longitude ?? this.longitude,
    status: status ?? this.status,
    description: description.present ? description.value : this.description,
    address: address.present ? address.value : this.address,
    createdBy: createdBy.present ? createdBy.value : this.createdBy,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    syncStatus: syncStatus ?? this.syncStatus,
    radius: radius.present ? radius.value : this.radius,
  );
  PlacesTableData copyWithCompanion(PlacesTableCompanion data) {
    return PlacesTableData(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      latitude: data.latitude.present ? data.latitude.value : this.latitude,
      longitude: data.longitude.present ? data.longitude.value : this.longitude,
      status: data.status.present ? data.status.value : this.status,
      description: data.description.present
          ? data.description.value
          : this.description,
      address: data.address.present ? data.address.value : this.address,
      createdBy: data.createdBy.present ? data.createdBy.value : this.createdBy,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      syncStatus: data.syncStatus.present
          ? data.syncStatus.value
          : this.syncStatus,
      radius: data.radius.present ? data.radius.value : this.radius,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PlacesTableData(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('latitude: $latitude, ')
          ..write('longitude: $longitude, ')
          ..write('status: $status, ')
          ..write('description: $description, ')
          ..write('address: $address, ')
          ..write('createdBy: $createdBy, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('radius: $radius')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    name,
    latitude,
    longitude,
    status,
    description,
    address,
    createdBy,
    createdAt,
    updatedAt,
    syncStatus,
    radius,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PlacesTableData &&
          other.id == this.id &&
          other.name == this.name &&
          other.latitude == this.latitude &&
          other.longitude == this.longitude &&
          other.status == this.status &&
          other.description == this.description &&
          other.address == this.address &&
          other.createdBy == this.createdBy &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.syncStatus == this.syncStatus &&
          other.radius == this.radius);
}

class PlacesTableCompanion extends UpdateCompanion<PlacesTableData> {
  final Value<String> id;
  final Value<String> name;
  final Value<double> latitude;
  final Value<double> longitude;
  final Value<String> status;
  final Value<String?> description;
  final Value<String?> address;
  final Value<String?> createdBy;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<String> syncStatus;
  final Value<double?> radius;
  final Value<int> rowid;
  const PlacesTableCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.latitude = const Value.absent(),
    this.longitude = const Value.absent(),
    this.status = const Value.absent(),
    this.description = const Value.absent(),
    this.address = const Value.absent(),
    this.createdBy = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.syncStatus = const Value.absent(),
    this.radius = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  PlacesTableCompanion.insert({
    required String id,
    required String name,
    required double latitude,
    required double longitude,
    this.status = const Value.absent(),
    this.description = const Value.absent(),
    this.address = const Value.absent(),
    this.createdBy = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.syncStatus = const Value.absent(),
    this.radius = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       name = Value(name),
       latitude = Value(latitude),
       longitude = Value(longitude);
  static Insertable<PlacesTableData> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<double>? latitude,
    Expression<double>? longitude,
    Expression<String>? status,
    Expression<String>? description,
    Expression<String>? address,
    Expression<String>? createdBy,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<String>? syncStatus,
    Expression<double>? radius,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (latitude != null) 'latitude': latitude,
      if (longitude != null) 'longitude': longitude,
      if (status != null) 'status': status,
      if (description != null) 'description': description,
      if (address != null) 'address': address,
      if (createdBy != null) 'created_by': createdBy,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (syncStatus != null) 'sync_status': syncStatus,
      if (radius != null) 'radius': radius,
      if (rowid != null) 'rowid': rowid,
    });
  }

  PlacesTableCompanion copyWith({
    Value<String>? id,
    Value<String>? name,
    Value<double>? latitude,
    Value<double>? longitude,
    Value<String>? status,
    Value<String?>? description,
    Value<String?>? address,
    Value<String?>? createdBy,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<String>? syncStatus,
    Value<double?>? radius,
    Value<int>? rowid,
  }) {
    return PlacesTableCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      status: status ?? this.status,
      description: description ?? this.description,
      address: address ?? this.address,
      createdBy: createdBy ?? this.createdBy,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      syncStatus: syncStatus ?? this.syncStatus,
      radius: radius ?? this.radius,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (latitude.present) {
      map['latitude'] = Variable<double>(latitude.value);
    }
    if (longitude.present) {
      map['longitude'] = Variable<double>(longitude.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (address.present) {
      map['address'] = Variable<String>(address.value);
    }
    if (createdBy.present) {
      map['created_by'] = Variable<String>(createdBy.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (syncStatus.present) {
      map['sync_status'] = Variable<String>(syncStatus.value);
    }
    if (radius.present) {
      map['radius'] = Variable<double>(radius.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PlacesTableCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('latitude: $latitude, ')
          ..write('longitude: $longitude, ')
          ..write('status: $status, ')
          ..write('description: $description, ')
          ..write('address: $address, ')
          ..write('createdBy: $createdBy, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('radius: $radius, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SettingsTableTable extends SettingsTable
    with TableInfo<$SettingsTableTable, SettingsTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SettingsTableTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _themeModeMeta = const VerificationMeta(
    'themeMode',
  );
  @override
  late final GeneratedColumn<String> themeMode = GeneratedColumn<String>(
    'theme_mode',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('system'),
  );
  static const VerificationMeta _gpsEnabledMeta = const VerificationMeta(
    'gpsEnabled',
  );
  @override
  late final GeneratedColumn<bool> gpsEnabled = GeneratedColumn<bool>(
    'gps_enabled',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("gps_enabled" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _gpsPerformanceModeMeta =
      const VerificationMeta('gpsPerformanceMode');
  @override
  late final GeneratedColumn<String> gpsPerformanceMode =
      GeneratedColumn<String>(
        'gps_performance_mode',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
        defaultValue: const Constant('balanced'),
      );
  static const VerificationMeta _gpsSyncFrequencyMeta = const VerificationMeta(
    'gpsSyncFrequency',
  );
  @override
  late final GeneratedColumn<int> gpsSyncFrequency = GeneratedColumn<int>(
    'gps_sync_frequency',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(15),
  );
  static const VerificationMeta _ghostModeUntilMeta = const VerificationMeta(
    'ghostModeUntil',
  );
  @override
  late final GeneratedColumn<DateTime> ghostModeUntil =
      GeneratedColumn<DateTime>(
        'ghost_mode_until',
        aliasedName,
        true,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
      );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    themeMode,
    gpsEnabled,
    gpsPerformanceMode,
    gpsSyncFrequency,
    ghostModeUntil,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'settings';
  @override
  VerificationContext validateIntegrity(
    Insertable<SettingsTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('theme_mode')) {
      context.handle(
        _themeModeMeta,
        themeMode.isAcceptableOrUnknown(data['theme_mode']!, _themeModeMeta),
      );
    }
    if (data.containsKey('gps_enabled')) {
      context.handle(
        _gpsEnabledMeta,
        gpsEnabled.isAcceptableOrUnknown(data['gps_enabled']!, _gpsEnabledMeta),
      );
    }
    if (data.containsKey('gps_performance_mode')) {
      context.handle(
        _gpsPerformanceModeMeta,
        gpsPerformanceMode.isAcceptableOrUnknown(
          data['gps_performance_mode']!,
          _gpsPerformanceModeMeta,
        ),
      );
    }
    if (data.containsKey('gps_sync_frequency')) {
      context.handle(
        _gpsSyncFrequencyMeta,
        gpsSyncFrequency.isAcceptableOrUnknown(
          data['gps_sync_frequency']!,
          _gpsSyncFrequencyMeta,
        ),
      );
    }
    if (data.containsKey('ghost_mode_until')) {
      context.handle(
        _ghostModeUntilMeta,
        ghostModeUntil.isAcceptableOrUnknown(
          data['ghost_mode_until']!,
          _ghostModeUntilMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SettingsTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SettingsTableData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      themeMode: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}theme_mode'],
      )!,
      gpsEnabled: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}gps_enabled'],
      )!,
      gpsPerformanceMode: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}gps_performance_mode'],
      )!,
      gpsSyncFrequency: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}gps_sync_frequency'],
      )!,
      ghostModeUntil: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}ghost_mode_until'],
      ),
    );
  }

  @override
  $SettingsTableTable createAlias(String alias) {
    return $SettingsTableTable(attachedDatabase, alias);
  }
}

class SettingsTableData extends DataClass
    implements Insertable<SettingsTableData> {
  final int id;
  final String themeMode;
  final bool gpsEnabled;
  final String gpsPerformanceMode;
  final int gpsSyncFrequency;
  final DateTime? ghostModeUntil;
  const SettingsTableData({
    required this.id,
    required this.themeMode,
    required this.gpsEnabled,
    required this.gpsPerformanceMode,
    required this.gpsSyncFrequency,
    this.ghostModeUntil,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['theme_mode'] = Variable<String>(themeMode);
    map['gps_enabled'] = Variable<bool>(gpsEnabled);
    map['gps_performance_mode'] = Variable<String>(gpsPerformanceMode);
    map['gps_sync_frequency'] = Variable<int>(gpsSyncFrequency);
    if (!nullToAbsent || ghostModeUntil != null) {
      map['ghost_mode_until'] = Variable<DateTime>(ghostModeUntil);
    }
    return map;
  }

  SettingsTableCompanion toCompanion(bool nullToAbsent) {
    return SettingsTableCompanion(
      id: Value(id),
      themeMode: Value(themeMode),
      gpsEnabled: Value(gpsEnabled),
      gpsPerformanceMode: Value(gpsPerformanceMode),
      gpsSyncFrequency: Value(gpsSyncFrequency),
      ghostModeUntil: ghostModeUntil == null && nullToAbsent
          ? const Value.absent()
          : Value(ghostModeUntil),
    );
  }

  factory SettingsTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SettingsTableData(
      id: serializer.fromJson<int>(json['id']),
      themeMode: serializer.fromJson<String>(json['themeMode']),
      gpsEnabled: serializer.fromJson<bool>(json['gpsEnabled']),
      gpsPerformanceMode: serializer.fromJson<String>(
        json['gpsPerformanceMode'],
      ),
      gpsSyncFrequency: serializer.fromJson<int>(json['gpsSyncFrequency']),
      ghostModeUntil: serializer.fromJson<DateTime?>(json['ghostModeUntil']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'themeMode': serializer.toJson<String>(themeMode),
      'gpsEnabled': serializer.toJson<bool>(gpsEnabled),
      'gpsPerformanceMode': serializer.toJson<String>(gpsPerformanceMode),
      'gpsSyncFrequency': serializer.toJson<int>(gpsSyncFrequency),
      'ghostModeUntil': serializer.toJson<DateTime?>(ghostModeUntil),
    };
  }

  SettingsTableData copyWith({
    int? id,
    String? themeMode,
    bool? gpsEnabled,
    String? gpsPerformanceMode,
    int? gpsSyncFrequency,
    Value<DateTime?> ghostModeUntil = const Value.absent(),
  }) => SettingsTableData(
    id: id ?? this.id,
    themeMode: themeMode ?? this.themeMode,
    gpsEnabled: gpsEnabled ?? this.gpsEnabled,
    gpsPerformanceMode: gpsPerformanceMode ?? this.gpsPerformanceMode,
    gpsSyncFrequency: gpsSyncFrequency ?? this.gpsSyncFrequency,
    ghostModeUntil: ghostModeUntil.present
        ? ghostModeUntil.value
        : this.ghostModeUntil,
  );
  SettingsTableData copyWithCompanion(SettingsTableCompanion data) {
    return SettingsTableData(
      id: data.id.present ? data.id.value : this.id,
      themeMode: data.themeMode.present ? data.themeMode.value : this.themeMode,
      gpsEnabled: data.gpsEnabled.present
          ? data.gpsEnabled.value
          : this.gpsEnabled,
      gpsPerformanceMode: data.gpsPerformanceMode.present
          ? data.gpsPerformanceMode.value
          : this.gpsPerformanceMode,
      gpsSyncFrequency: data.gpsSyncFrequency.present
          ? data.gpsSyncFrequency.value
          : this.gpsSyncFrequency,
      ghostModeUntil: data.ghostModeUntil.present
          ? data.ghostModeUntil.value
          : this.ghostModeUntil,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SettingsTableData(')
          ..write('id: $id, ')
          ..write('themeMode: $themeMode, ')
          ..write('gpsEnabled: $gpsEnabled, ')
          ..write('gpsPerformanceMode: $gpsPerformanceMode, ')
          ..write('gpsSyncFrequency: $gpsSyncFrequency, ')
          ..write('ghostModeUntil: $ghostModeUntil')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    themeMode,
    gpsEnabled,
    gpsPerformanceMode,
    gpsSyncFrequency,
    ghostModeUntil,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SettingsTableData &&
          other.id == this.id &&
          other.themeMode == this.themeMode &&
          other.gpsEnabled == this.gpsEnabled &&
          other.gpsPerformanceMode == this.gpsPerformanceMode &&
          other.gpsSyncFrequency == this.gpsSyncFrequency &&
          other.ghostModeUntil == this.ghostModeUntil);
}

class SettingsTableCompanion extends UpdateCompanion<SettingsTableData> {
  final Value<int> id;
  final Value<String> themeMode;
  final Value<bool> gpsEnabled;
  final Value<String> gpsPerformanceMode;
  final Value<int> gpsSyncFrequency;
  final Value<DateTime?> ghostModeUntil;
  const SettingsTableCompanion({
    this.id = const Value.absent(),
    this.themeMode = const Value.absent(),
    this.gpsEnabled = const Value.absent(),
    this.gpsPerformanceMode = const Value.absent(),
    this.gpsSyncFrequency = const Value.absent(),
    this.ghostModeUntil = const Value.absent(),
  });
  SettingsTableCompanion.insert({
    this.id = const Value.absent(),
    this.themeMode = const Value.absent(),
    this.gpsEnabled = const Value.absent(),
    this.gpsPerformanceMode = const Value.absent(),
    this.gpsSyncFrequency = const Value.absent(),
    this.ghostModeUntil = const Value.absent(),
  });
  static Insertable<SettingsTableData> custom({
    Expression<int>? id,
    Expression<String>? themeMode,
    Expression<bool>? gpsEnabled,
    Expression<String>? gpsPerformanceMode,
    Expression<int>? gpsSyncFrequency,
    Expression<DateTime>? ghostModeUntil,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (themeMode != null) 'theme_mode': themeMode,
      if (gpsEnabled != null) 'gps_enabled': gpsEnabled,
      if (gpsPerformanceMode != null)
        'gps_performance_mode': gpsPerformanceMode,
      if (gpsSyncFrequency != null) 'gps_sync_frequency': gpsSyncFrequency,
      if (ghostModeUntil != null) 'ghost_mode_until': ghostModeUntil,
    });
  }

  SettingsTableCompanion copyWith({
    Value<int>? id,
    Value<String>? themeMode,
    Value<bool>? gpsEnabled,
    Value<String>? gpsPerformanceMode,
    Value<int>? gpsSyncFrequency,
    Value<DateTime?>? ghostModeUntil,
  }) {
    return SettingsTableCompanion(
      id: id ?? this.id,
      themeMode: themeMode ?? this.themeMode,
      gpsEnabled: gpsEnabled ?? this.gpsEnabled,
      gpsPerformanceMode: gpsPerformanceMode ?? this.gpsPerformanceMode,
      gpsSyncFrequency: gpsSyncFrequency ?? this.gpsSyncFrequency,
      ghostModeUntil: ghostModeUntil ?? this.ghostModeUntil,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (themeMode.present) {
      map['theme_mode'] = Variable<String>(themeMode.value);
    }
    if (gpsEnabled.present) {
      map['gps_enabled'] = Variable<bool>(gpsEnabled.value);
    }
    if (gpsPerformanceMode.present) {
      map['gps_performance_mode'] = Variable<String>(gpsPerformanceMode.value);
    }
    if (gpsSyncFrequency.present) {
      map['gps_sync_frequency'] = Variable<int>(gpsSyncFrequency.value);
    }
    if (ghostModeUntil.present) {
      map['ghost_mode_until'] = Variable<DateTime>(ghostModeUntil.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SettingsTableCompanion(')
          ..write('id: $id, ')
          ..write('themeMode: $themeMode, ')
          ..write('gpsEnabled: $gpsEnabled, ')
          ..write('gpsPerformanceMode: $gpsPerformanceMode, ')
          ..write('gpsSyncFrequency: $gpsSyncFrequency, ')
          ..write('ghostModeUntil: $ghostModeUntil')
          ..write(')'))
        .toString();
  }
}

class $BlockedFriendsTableTable extends BlockedFriendsTable
    with TableInfo<$BlockedFriendsTableTable, BlockedFriendsTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $BlockedFriendsTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<String> userId = GeneratedColumn<String>(
    'user_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _blockedAtMeta = const VerificationMeta(
    'blockedAt',
  );
  @override
  late final GeneratedColumn<DateTime> blockedAt = GeneratedColumn<DateTime>(
    'blocked_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [userId, blockedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'blocked_friends';
  @override
  VerificationContext validateIntegrity(
    Insertable<BlockedFriendsTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('user_id')) {
      context.handle(
        _userIdMeta,
        userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta),
      );
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (data.containsKey('blocked_at')) {
      context.handle(
        _blockedAtMeta,
        blockedAt.isAcceptableOrUnknown(data['blocked_at']!, _blockedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {userId};
  @override
  BlockedFriendsTableData map(
    Map<String, dynamic> data, {
    String? tablePrefix,
  }) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return BlockedFriendsTableData(
      userId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}user_id'],
      )!,
      blockedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}blocked_at'],
      )!,
    );
  }

  @override
  $BlockedFriendsTableTable createAlias(String alias) {
    return $BlockedFriendsTableTable(attachedDatabase, alias);
  }
}

class BlockedFriendsTableData extends DataClass
    implements Insertable<BlockedFriendsTableData> {
  final String userId;
  final DateTime blockedAt;
  const BlockedFriendsTableData({
    required this.userId,
    required this.blockedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['user_id'] = Variable<String>(userId);
    map['blocked_at'] = Variable<DateTime>(blockedAt);
    return map;
  }

  BlockedFriendsTableCompanion toCompanion(bool nullToAbsent) {
    return BlockedFriendsTableCompanion(
      userId: Value(userId),
      blockedAt: Value(blockedAt),
    );
  }

  factory BlockedFriendsTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return BlockedFriendsTableData(
      userId: serializer.fromJson<String>(json['userId']),
      blockedAt: serializer.fromJson<DateTime>(json['blockedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'userId': serializer.toJson<String>(userId),
      'blockedAt': serializer.toJson<DateTime>(blockedAt),
    };
  }

  BlockedFriendsTableData copyWith({String? userId, DateTime? blockedAt}) =>
      BlockedFriendsTableData(
        userId: userId ?? this.userId,
        blockedAt: blockedAt ?? this.blockedAt,
      );
  BlockedFriendsTableData copyWithCompanion(BlockedFriendsTableCompanion data) {
    return BlockedFriendsTableData(
      userId: data.userId.present ? data.userId.value : this.userId,
      blockedAt: data.blockedAt.present ? data.blockedAt.value : this.blockedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('BlockedFriendsTableData(')
          ..write('userId: $userId, ')
          ..write('blockedAt: $blockedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(userId, blockedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is BlockedFriendsTableData &&
          other.userId == this.userId &&
          other.blockedAt == this.blockedAt);
}

class BlockedFriendsTableCompanion
    extends UpdateCompanion<BlockedFriendsTableData> {
  final Value<String> userId;
  final Value<DateTime> blockedAt;
  final Value<int> rowid;
  const BlockedFriendsTableCompanion({
    this.userId = const Value.absent(),
    this.blockedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  BlockedFriendsTableCompanion.insert({
    required String userId,
    this.blockedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : userId = Value(userId);
  static Insertable<BlockedFriendsTableData> custom({
    Expression<String>? userId,
    Expression<DateTime>? blockedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (userId != null) 'user_id': userId,
      if (blockedAt != null) 'blocked_at': blockedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  BlockedFriendsTableCompanion copyWith({
    Value<String>? userId,
    Value<DateTime>? blockedAt,
    Value<int>? rowid,
  }) {
    return BlockedFriendsTableCompanion(
      userId: userId ?? this.userId,
      blockedAt: blockedAt ?? this.blockedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (userId.present) {
      map['user_id'] = Variable<String>(userId.value);
    }
    if (blockedAt.present) {
      map['blocked_at'] = Variable<DateTime>(blockedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('BlockedFriendsTableCompanion(')
          ..write('userId: $userId, ')
          ..write('blockedAt: $blockedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $GroupsTableTable extends GroupsTable
    with TableInfo<$GroupsTableTable, GroupsTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $GroupsTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
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
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdByMeta = const VerificationMeta(
    'createdBy',
  );
  @override
  late final GeneratedColumn<String> createdBy = GeneratedColumn<String>(
    'created_by',
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
    requiredDuringInsert: true,
  );
  static const VerificationMeta _isPublicMeta = const VerificationMeta(
    'isPublic',
  );
  @override
  late final GeneratedColumn<bool> isPublic = GeneratedColumn<bool>(
    'is_public',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_public" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _requiresApprovalMeta = const VerificationMeta(
    'requiresApproval',
  );
  @override
  late final GeneratedColumn<bool> requiresApproval = GeneratedColumn<bool>(
    'requires_approval',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("requires_approval" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _autoCheckinEnabledMeta =
      const VerificationMeta('autoCheckinEnabled');
  @override
  late final GeneratedColumn<bool> autoCheckinEnabled = GeneratedColumn<bool>(
    'auto_checkin_enabled',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("auto_checkin_enabled" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _notificationEnabledMeta =
      const VerificationMeta('notificationEnabled');
  @override
  late final GeneratedColumn<bool> notificationEnabled = GeneratedColumn<bool>(
    'notification_enabled',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("notification_enabled" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    description,
    createdBy,
    createdAt,
    isPublic,
    requiresApproval,
    autoCheckinEnabled,
    notificationEnabled,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'groups';
  @override
  VerificationContext validateIntegrity(
    Insertable<GroupsTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
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
    }
    if (data.containsKey('created_by')) {
      context.handle(
        _createdByMeta,
        createdBy.isAcceptableOrUnknown(data['created_by']!, _createdByMeta),
      );
    } else if (isInserting) {
      context.missing(_createdByMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('is_public')) {
      context.handle(
        _isPublicMeta,
        isPublic.isAcceptableOrUnknown(data['is_public']!, _isPublicMeta),
      );
    }
    if (data.containsKey('requires_approval')) {
      context.handle(
        _requiresApprovalMeta,
        requiresApproval.isAcceptableOrUnknown(
          data['requires_approval']!,
          _requiresApprovalMeta,
        ),
      );
    }
    if (data.containsKey('auto_checkin_enabled')) {
      context.handle(
        _autoCheckinEnabledMeta,
        autoCheckinEnabled.isAcceptableOrUnknown(
          data['auto_checkin_enabled']!,
          _autoCheckinEnabledMeta,
        ),
      );
    }
    if (data.containsKey('notification_enabled')) {
      context.handle(
        _notificationEnabledMeta,
        notificationEnabled.isAcceptableOrUnknown(
          data['notification_enabled']!,
          _notificationEnabledMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  GroupsTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return GroupsTableData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      ),
      createdBy: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}created_by'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      isPublic: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_public'],
      )!,
      requiresApproval: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}requires_approval'],
      )!,
      autoCheckinEnabled: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}auto_checkin_enabled'],
      )!,
      notificationEnabled: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}notification_enabled'],
      )!,
    );
  }

  @override
  $GroupsTableTable createAlias(String alias) {
    return $GroupsTableTable(attachedDatabase, alias);
  }
}

class GroupsTableData extends DataClass implements Insertable<GroupsTableData> {
  final String id;
  final String name;
  final String? description;
  final String createdBy;
  final DateTime createdAt;
  final bool isPublic;
  final bool requiresApproval;
  final bool autoCheckinEnabled;
  final bool notificationEnabled;
  const GroupsTableData({
    required this.id,
    required this.name,
    this.description,
    required this.createdBy,
    required this.createdAt,
    required this.isPublic,
    required this.requiresApproval,
    required this.autoCheckinEnabled,
    required this.notificationEnabled,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    map['created_by'] = Variable<String>(createdBy);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['is_public'] = Variable<bool>(isPublic);
    map['requires_approval'] = Variable<bool>(requiresApproval);
    map['auto_checkin_enabled'] = Variable<bool>(autoCheckinEnabled);
    map['notification_enabled'] = Variable<bool>(notificationEnabled);
    return map;
  }

  GroupsTableCompanion toCompanion(bool nullToAbsent) {
    return GroupsTableCompanion(
      id: Value(id),
      name: Value(name),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
      createdBy: Value(createdBy),
      createdAt: Value(createdAt),
      isPublic: Value(isPublic),
      requiresApproval: Value(requiresApproval),
      autoCheckinEnabled: Value(autoCheckinEnabled),
      notificationEnabled: Value(notificationEnabled),
    );
  }

  factory GroupsTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return GroupsTableData(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      description: serializer.fromJson<String?>(json['description']),
      createdBy: serializer.fromJson<String>(json['createdBy']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      isPublic: serializer.fromJson<bool>(json['isPublic']),
      requiresApproval: serializer.fromJson<bool>(json['requiresApproval']),
      autoCheckinEnabled: serializer.fromJson<bool>(json['autoCheckinEnabled']),
      notificationEnabled: serializer.fromJson<bool>(
        json['notificationEnabled'],
      ),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'description': serializer.toJson<String?>(description),
      'createdBy': serializer.toJson<String>(createdBy),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'isPublic': serializer.toJson<bool>(isPublic),
      'requiresApproval': serializer.toJson<bool>(requiresApproval),
      'autoCheckinEnabled': serializer.toJson<bool>(autoCheckinEnabled),
      'notificationEnabled': serializer.toJson<bool>(notificationEnabled),
    };
  }

  GroupsTableData copyWith({
    String? id,
    String? name,
    Value<String?> description = const Value.absent(),
    String? createdBy,
    DateTime? createdAt,
    bool? isPublic,
    bool? requiresApproval,
    bool? autoCheckinEnabled,
    bool? notificationEnabled,
  }) => GroupsTableData(
    id: id ?? this.id,
    name: name ?? this.name,
    description: description.present ? description.value : this.description,
    createdBy: createdBy ?? this.createdBy,
    createdAt: createdAt ?? this.createdAt,
    isPublic: isPublic ?? this.isPublic,
    requiresApproval: requiresApproval ?? this.requiresApproval,
    autoCheckinEnabled: autoCheckinEnabled ?? this.autoCheckinEnabled,
    notificationEnabled: notificationEnabled ?? this.notificationEnabled,
  );
  GroupsTableData copyWithCompanion(GroupsTableCompanion data) {
    return GroupsTableData(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      description: data.description.present
          ? data.description.value
          : this.description,
      createdBy: data.createdBy.present ? data.createdBy.value : this.createdBy,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      isPublic: data.isPublic.present ? data.isPublic.value : this.isPublic,
      requiresApproval: data.requiresApproval.present
          ? data.requiresApproval.value
          : this.requiresApproval,
      autoCheckinEnabled: data.autoCheckinEnabled.present
          ? data.autoCheckinEnabled.value
          : this.autoCheckinEnabled,
      notificationEnabled: data.notificationEnabled.present
          ? data.notificationEnabled.value
          : this.notificationEnabled,
    );
  }

  @override
  String toString() {
    return (StringBuffer('GroupsTableData(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('description: $description, ')
          ..write('createdBy: $createdBy, ')
          ..write('createdAt: $createdAt, ')
          ..write('isPublic: $isPublic, ')
          ..write('requiresApproval: $requiresApproval, ')
          ..write('autoCheckinEnabled: $autoCheckinEnabled, ')
          ..write('notificationEnabled: $notificationEnabled')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    name,
    description,
    createdBy,
    createdAt,
    isPublic,
    requiresApproval,
    autoCheckinEnabled,
    notificationEnabled,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is GroupsTableData &&
          other.id == this.id &&
          other.name == this.name &&
          other.description == this.description &&
          other.createdBy == this.createdBy &&
          other.createdAt == this.createdAt &&
          other.isPublic == this.isPublic &&
          other.requiresApproval == this.requiresApproval &&
          other.autoCheckinEnabled == this.autoCheckinEnabled &&
          other.notificationEnabled == this.notificationEnabled);
}

class GroupsTableCompanion extends UpdateCompanion<GroupsTableData> {
  final Value<String> id;
  final Value<String> name;
  final Value<String?> description;
  final Value<String> createdBy;
  final Value<DateTime> createdAt;
  final Value<bool> isPublic;
  final Value<bool> requiresApproval;
  final Value<bool> autoCheckinEnabled;
  final Value<bool> notificationEnabled;
  final Value<int> rowid;
  const GroupsTableCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.description = const Value.absent(),
    this.createdBy = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.isPublic = const Value.absent(),
    this.requiresApproval = const Value.absent(),
    this.autoCheckinEnabled = const Value.absent(),
    this.notificationEnabled = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  GroupsTableCompanion.insert({
    required String id,
    required String name,
    this.description = const Value.absent(),
    required String createdBy,
    required DateTime createdAt,
    this.isPublic = const Value.absent(),
    this.requiresApproval = const Value.absent(),
    this.autoCheckinEnabled = const Value.absent(),
    this.notificationEnabled = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       name = Value(name),
       createdBy = Value(createdBy),
       createdAt = Value(createdAt);
  static Insertable<GroupsTableData> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? description,
    Expression<String>? createdBy,
    Expression<DateTime>? createdAt,
    Expression<bool>? isPublic,
    Expression<bool>? requiresApproval,
    Expression<bool>? autoCheckinEnabled,
    Expression<bool>? notificationEnabled,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (description != null) 'description': description,
      if (createdBy != null) 'created_by': createdBy,
      if (createdAt != null) 'created_at': createdAt,
      if (isPublic != null) 'is_public': isPublic,
      if (requiresApproval != null) 'requires_approval': requiresApproval,
      if (autoCheckinEnabled != null)
        'auto_checkin_enabled': autoCheckinEnabled,
      if (notificationEnabled != null)
        'notification_enabled': notificationEnabled,
      if (rowid != null) 'rowid': rowid,
    });
  }

  GroupsTableCompanion copyWith({
    Value<String>? id,
    Value<String>? name,
    Value<String?>? description,
    Value<String>? createdBy,
    Value<DateTime>? createdAt,
    Value<bool>? isPublic,
    Value<bool>? requiresApproval,
    Value<bool>? autoCheckinEnabled,
    Value<bool>? notificationEnabled,
    Value<int>? rowid,
  }) {
    return GroupsTableCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      createdBy: createdBy ?? this.createdBy,
      createdAt: createdAt ?? this.createdAt,
      isPublic: isPublic ?? this.isPublic,
      requiresApproval: requiresApproval ?? this.requiresApproval,
      autoCheckinEnabled: autoCheckinEnabled ?? this.autoCheckinEnabled,
      notificationEnabled: notificationEnabled ?? this.notificationEnabled,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (createdBy.present) {
      map['created_by'] = Variable<String>(createdBy.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (isPublic.present) {
      map['is_public'] = Variable<bool>(isPublic.value);
    }
    if (requiresApproval.present) {
      map['requires_approval'] = Variable<bool>(requiresApproval.value);
    }
    if (autoCheckinEnabled.present) {
      map['auto_checkin_enabled'] = Variable<bool>(autoCheckinEnabled.value);
    }
    if (notificationEnabled.present) {
      map['notification_enabled'] = Variable<bool>(notificationEnabled.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('GroupsTableCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('description: $description, ')
          ..write('createdBy: $createdBy, ')
          ..write('createdAt: $createdAt, ')
          ..write('isPublic: $isPublic, ')
          ..write('requiresApproval: $requiresApproval, ')
          ..write('autoCheckinEnabled: $autoCheckinEnabled, ')
          ..write('notificationEnabled: $notificationEnabled, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $GroupPlacesTableTable extends GroupPlacesTable
    with TableInfo<$GroupPlacesTableTable, GroupPlacesTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $GroupPlacesTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _groupIdMeta = const VerificationMeta(
    'groupId',
  );
  @override
  late final GeneratedColumn<String> groupId = GeneratedColumn<String>(
    'group_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES "groups" (id)',
    ),
  );
  static const VerificationMeta _placeIdMeta = const VerificationMeta(
    'placeId',
  );
  @override
  late final GeneratedColumn<String> placeId = GeneratedColumn<String>(
    'place_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES places (id)',
    ),
  );
  static const VerificationMeta _isPrimaryMeta = const VerificationMeta(
    'isPrimary',
  );
  @override
  late final GeneratedColumn<bool> isPrimary = GeneratedColumn<bool>(
    'is_primary',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_primary" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _displayOrderMeta = const VerificationMeta(
    'displayOrder',
  );
  @override
  late final GeneratedColumn<int> displayOrder = GeneratedColumn<int>(
    'display_order',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _addedAtMeta = const VerificationMeta(
    'addedAt',
  );
  @override
  late final GeneratedColumn<DateTime> addedAt = GeneratedColumn<DateTime>(
    'added_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _radiusMeta = const VerificationMeta('radius');
  @override
  late final GeneratedColumn<double> radius = GeneratedColumn<double>(
    'radius',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(100.0),
  );
  static const VerificationMeta _descriptionMeta = const VerificationMeta(
    'description',
  );
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
    'description',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _placeTypeMeta = const VerificationMeta(
    'placeType',
  );
  @override
  late final GeneratedColumn<String> placeType = GeneratedColumn<String>(
    'place_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('skatepark'),
  );
  @override
  List<GeneratedColumn> get $columns => [
    groupId,
    placeId,
    isPrimary,
    displayOrder,
    addedAt,
    radius,
    description,
    placeType,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'group_places';
  @override
  VerificationContext validateIntegrity(
    Insertable<GroupPlacesTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('group_id')) {
      context.handle(
        _groupIdMeta,
        groupId.isAcceptableOrUnknown(data['group_id']!, _groupIdMeta),
      );
    } else if (isInserting) {
      context.missing(_groupIdMeta);
    }
    if (data.containsKey('place_id')) {
      context.handle(
        _placeIdMeta,
        placeId.isAcceptableOrUnknown(data['place_id']!, _placeIdMeta),
      );
    } else if (isInserting) {
      context.missing(_placeIdMeta);
    }
    if (data.containsKey('is_primary')) {
      context.handle(
        _isPrimaryMeta,
        isPrimary.isAcceptableOrUnknown(data['is_primary']!, _isPrimaryMeta),
      );
    }
    if (data.containsKey('display_order')) {
      context.handle(
        _displayOrderMeta,
        displayOrder.isAcceptableOrUnknown(
          data['display_order']!,
          _displayOrderMeta,
        ),
      );
    }
    if (data.containsKey('added_at')) {
      context.handle(
        _addedAtMeta,
        addedAt.isAcceptableOrUnknown(data['added_at']!, _addedAtMeta),
      );
    }
    if (data.containsKey('radius')) {
      context.handle(
        _radiusMeta,
        radius.isAcceptableOrUnknown(data['radius']!, _radiusMeta),
      );
    }
    if (data.containsKey('description')) {
      context.handle(
        _descriptionMeta,
        description.isAcceptableOrUnknown(
          data['description']!,
          _descriptionMeta,
        ),
      );
    }
    if (data.containsKey('place_type')) {
      context.handle(
        _placeTypeMeta,
        placeType.isAcceptableOrUnknown(data['place_type']!, _placeTypeMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {groupId, placeId};
  @override
  GroupPlacesTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return GroupPlacesTableData(
      groupId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}group_id'],
      )!,
      placeId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}place_id'],
      )!,
      isPrimary: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_primary'],
      )!,
      displayOrder: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}display_order'],
      )!,
      addedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}added_at'],
      )!,
      radius: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}radius'],
      )!,
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      ),
      placeType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}place_type'],
      )!,
    );
  }

  @override
  $GroupPlacesTableTable createAlias(String alias) {
    return $GroupPlacesTableTable(attachedDatabase, alias);
  }
}

class GroupPlacesTableData extends DataClass
    implements Insertable<GroupPlacesTableData> {
  final String groupId;
  final String placeId;
  final bool isPrimary;
  final int displayOrder;
  final DateTime addedAt;
  final double radius;
  final String? description;
  final String placeType;
  const GroupPlacesTableData({
    required this.groupId,
    required this.placeId,
    required this.isPrimary,
    required this.displayOrder,
    required this.addedAt,
    required this.radius,
    this.description,
    required this.placeType,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['group_id'] = Variable<String>(groupId);
    map['place_id'] = Variable<String>(placeId);
    map['is_primary'] = Variable<bool>(isPrimary);
    map['display_order'] = Variable<int>(displayOrder);
    map['added_at'] = Variable<DateTime>(addedAt);
    map['radius'] = Variable<double>(radius);
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    map['place_type'] = Variable<String>(placeType);
    return map;
  }

  GroupPlacesTableCompanion toCompanion(bool nullToAbsent) {
    return GroupPlacesTableCompanion(
      groupId: Value(groupId),
      placeId: Value(placeId),
      isPrimary: Value(isPrimary),
      displayOrder: Value(displayOrder),
      addedAt: Value(addedAt),
      radius: Value(radius),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
      placeType: Value(placeType),
    );
  }

  factory GroupPlacesTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return GroupPlacesTableData(
      groupId: serializer.fromJson<String>(json['groupId']),
      placeId: serializer.fromJson<String>(json['placeId']),
      isPrimary: serializer.fromJson<bool>(json['isPrimary']),
      displayOrder: serializer.fromJson<int>(json['displayOrder']),
      addedAt: serializer.fromJson<DateTime>(json['addedAt']),
      radius: serializer.fromJson<double>(json['radius']),
      description: serializer.fromJson<String?>(json['description']),
      placeType: serializer.fromJson<String>(json['placeType']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'groupId': serializer.toJson<String>(groupId),
      'placeId': serializer.toJson<String>(placeId),
      'isPrimary': serializer.toJson<bool>(isPrimary),
      'displayOrder': serializer.toJson<int>(displayOrder),
      'addedAt': serializer.toJson<DateTime>(addedAt),
      'radius': serializer.toJson<double>(radius),
      'description': serializer.toJson<String?>(description),
      'placeType': serializer.toJson<String>(placeType),
    };
  }

  GroupPlacesTableData copyWith({
    String? groupId,
    String? placeId,
    bool? isPrimary,
    int? displayOrder,
    DateTime? addedAt,
    double? radius,
    Value<String?> description = const Value.absent(),
    String? placeType,
  }) => GroupPlacesTableData(
    groupId: groupId ?? this.groupId,
    placeId: placeId ?? this.placeId,
    isPrimary: isPrimary ?? this.isPrimary,
    displayOrder: displayOrder ?? this.displayOrder,
    addedAt: addedAt ?? this.addedAt,
    radius: radius ?? this.radius,
    description: description.present ? description.value : this.description,
    placeType: placeType ?? this.placeType,
  );
  GroupPlacesTableData copyWithCompanion(GroupPlacesTableCompanion data) {
    return GroupPlacesTableData(
      groupId: data.groupId.present ? data.groupId.value : this.groupId,
      placeId: data.placeId.present ? data.placeId.value : this.placeId,
      isPrimary: data.isPrimary.present ? data.isPrimary.value : this.isPrimary,
      displayOrder: data.displayOrder.present
          ? data.displayOrder.value
          : this.displayOrder,
      addedAt: data.addedAt.present ? data.addedAt.value : this.addedAt,
      radius: data.radius.present ? data.radius.value : this.radius,
      description: data.description.present
          ? data.description.value
          : this.description,
      placeType: data.placeType.present ? data.placeType.value : this.placeType,
    );
  }

  @override
  String toString() {
    return (StringBuffer('GroupPlacesTableData(')
          ..write('groupId: $groupId, ')
          ..write('placeId: $placeId, ')
          ..write('isPrimary: $isPrimary, ')
          ..write('displayOrder: $displayOrder, ')
          ..write('addedAt: $addedAt, ')
          ..write('radius: $radius, ')
          ..write('description: $description, ')
          ..write('placeType: $placeType')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    groupId,
    placeId,
    isPrimary,
    displayOrder,
    addedAt,
    radius,
    description,
    placeType,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is GroupPlacesTableData &&
          other.groupId == this.groupId &&
          other.placeId == this.placeId &&
          other.isPrimary == this.isPrimary &&
          other.displayOrder == this.displayOrder &&
          other.addedAt == this.addedAt &&
          other.radius == this.radius &&
          other.description == this.description &&
          other.placeType == this.placeType);
}

class GroupPlacesTableCompanion extends UpdateCompanion<GroupPlacesTableData> {
  final Value<String> groupId;
  final Value<String> placeId;
  final Value<bool> isPrimary;
  final Value<int> displayOrder;
  final Value<DateTime> addedAt;
  final Value<double> radius;
  final Value<String?> description;
  final Value<String> placeType;
  final Value<int> rowid;
  const GroupPlacesTableCompanion({
    this.groupId = const Value.absent(),
    this.placeId = const Value.absent(),
    this.isPrimary = const Value.absent(),
    this.displayOrder = const Value.absent(),
    this.addedAt = const Value.absent(),
    this.radius = const Value.absent(),
    this.description = const Value.absent(),
    this.placeType = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  GroupPlacesTableCompanion.insert({
    required String groupId,
    required String placeId,
    this.isPrimary = const Value.absent(),
    this.displayOrder = const Value.absent(),
    this.addedAt = const Value.absent(),
    this.radius = const Value.absent(),
    this.description = const Value.absent(),
    this.placeType = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : groupId = Value(groupId),
       placeId = Value(placeId);
  static Insertable<GroupPlacesTableData> custom({
    Expression<String>? groupId,
    Expression<String>? placeId,
    Expression<bool>? isPrimary,
    Expression<int>? displayOrder,
    Expression<DateTime>? addedAt,
    Expression<double>? radius,
    Expression<String>? description,
    Expression<String>? placeType,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (groupId != null) 'group_id': groupId,
      if (placeId != null) 'place_id': placeId,
      if (isPrimary != null) 'is_primary': isPrimary,
      if (displayOrder != null) 'display_order': displayOrder,
      if (addedAt != null) 'added_at': addedAt,
      if (radius != null) 'radius': radius,
      if (description != null) 'description': description,
      if (placeType != null) 'place_type': placeType,
      if (rowid != null) 'rowid': rowid,
    });
  }

  GroupPlacesTableCompanion copyWith({
    Value<String>? groupId,
    Value<String>? placeId,
    Value<bool>? isPrimary,
    Value<int>? displayOrder,
    Value<DateTime>? addedAt,
    Value<double>? radius,
    Value<String?>? description,
    Value<String>? placeType,
    Value<int>? rowid,
  }) {
    return GroupPlacesTableCompanion(
      groupId: groupId ?? this.groupId,
      placeId: placeId ?? this.placeId,
      isPrimary: isPrimary ?? this.isPrimary,
      displayOrder: displayOrder ?? this.displayOrder,
      addedAt: addedAt ?? this.addedAt,
      radius: radius ?? this.radius,
      description: description ?? this.description,
      placeType: placeType ?? this.placeType,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (groupId.present) {
      map['group_id'] = Variable<String>(groupId.value);
    }
    if (placeId.present) {
      map['place_id'] = Variable<String>(placeId.value);
    }
    if (isPrimary.present) {
      map['is_primary'] = Variable<bool>(isPrimary.value);
    }
    if (displayOrder.present) {
      map['display_order'] = Variable<int>(displayOrder.value);
    }
    if (addedAt.present) {
      map['added_at'] = Variable<DateTime>(addedAt.value);
    }
    if (radius.present) {
      map['radius'] = Variable<double>(radius.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (placeType.present) {
      map['place_type'] = Variable<String>(placeType.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('GroupPlacesTableCompanion(')
          ..write('groupId: $groupId, ')
          ..write('placeId: $placeId, ')
          ..write('isPrimary: $isPrimary, ')
          ..write('displayOrder: $displayOrder, ')
          ..write('addedAt: $addedAt, ')
          ..write('radius: $radius, ')
          ..write('description: $description, ')
          ..write('placeType: $placeType, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $GroupMembersTableTable extends GroupMembersTable
    with TableInfo<$GroupMembersTableTable, GroupMembersTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $GroupMembersTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _groupIdMeta = const VerificationMeta(
    'groupId',
  );
  @override
  late final GeneratedColumn<String> groupId = GeneratedColumn<String>(
    'group_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES "groups" (id)',
    ),
  );
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<String> userId = GeneratedColumn<String>(
    'user_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _roleMeta = const VerificationMeta('role');
  @override
  late final GeneratedColumn<String> role = GeneratedColumn<String>(
    'role',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('member'),
  );
  static const VerificationMeta _joinedAtMeta = const VerificationMeta(
    'joinedAt',
  );
  @override
  late final GeneratedColumn<DateTime> joinedAt = GeneratedColumn<DateTime>(
    'joined_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _shareLocationMeta = const VerificationMeta(
    'shareLocation',
  );
  @override
  late final GeneratedColumn<bool> shareLocation = GeneratedColumn<bool>(
    'share_location',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("share_location" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _notificationsEnabledMeta =
      const VerificationMeta('notificationsEnabled');
  @override
  late final GeneratedColumn<bool> notificationsEnabled = GeneratedColumn<bool>(
    'notifications_enabled',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("notifications_enabled" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  @override
  List<GeneratedColumn> get $columns => [
    groupId,
    userId,
    role,
    joinedAt,
    shareLocation,
    notificationsEnabled,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'group_members';
  @override
  VerificationContext validateIntegrity(
    Insertable<GroupMembersTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('group_id')) {
      context.handle(
        _groupIdMeta,
        groupId.isAcceptableOrUnknown(data['group_id']!, _groupIdMeta),
      );
    } else if (isInserting) {
      context.missing(_groupIdMeta);
    }
    if (data.containsKey('user_id')) {
      context.handle(
        _userIdMeta,
        userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta),
      );
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (data.containsKey('role')) {
      context.handle(
        _roleMeta,
        role.isAcceptableOrUnknown(data['role']!, _roleMeta),
      );
    }
    if (data.containsKey('joined_at')) {
      context.handle(
        _joinedAtMeta,
        joinedAt.isAcceptableOrUnknown(data['joined_at']!, _joinedAtMeta),
      );
    }
    if (data.containsKey('share_location')) {
      context.handle(
        _shareLocationMeta,
        shareLocation.isAcceptableOrUnknown(
          data['share_location']!,
          _shareLocationMeta,
        ),
      );
    }
    if (data.containsKey('notifications_enabled')) {
      context.handle(
        _notificationsEnabledMeta,
        notificationsEnabled.isAcceptableOrUnknown(
          data['notifications_enabled']!,
          _notificationsEnabledMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {groupId, userId};
  @override
  GroupMembersTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return GroupMembersTableData(
      groupId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}group_id'],
      )!,
      userId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}user_id'],
      )!,
      role: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}role'],
      )!,
      joinedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}joined_at'],
      )!,
      shareLocation: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}share_location'],
      )!,
      notificationsEnabled: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}notifications_enabled'],
      )!,
    );
  }

  @override
  $GroupMembersTableTable createAlias(String alias) {
    return $GroupMembersTableTable(attachedDatabase, alias);
  }
}

class GroupMembersTableData extends DataClass
    implements Insertable<GroupMembersTableData> {
  final String groupId;
  final String userId;
  final String role;
  final DateTime joinedAt;
  final bool shareLocation;
  final bool notificationsEnabled;
  const GroupMembersTableData({
    required this.groupId,
    required this.userId,
    required this.role,
    required this.joinedAt,
    required this.shareLocation,
    required this.notificationsEnabled,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['group_id'] = Variable<String>(groupId);
    map['user_id'] = Variable<String>(userId);
    map['role'] = Variable<String>(role);
    map['joined_at'] = Variable<DateTime>(joinedAt);
    map['share_location'] = Variable<bool>(shareLocation);
    map['notifications_enabled'] = Variable<bool>(notificationsEnabled);
    return map;
  }

  GroupMembersTableCompanion toCompanion(bool nullToAbsent) {
    return GroupMembersTableCompanion(
      groupId: Value(groupId),
      userId: Value(userId),
      role: Value(role),
      joinedAt: Value(joinedAt),
      shareLocation: Value(shareLocation),
      notificationsEnabled: Value(notificationsEnabled),
    );
  }

  factory GroupMembersTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return GroupMembersTableData(
      groupId: serializer.fromJson<String>(json['groupId']),
      userId: serializer.fromJson<String>(json['userId']),
      role: serializer.fromJson<String>(json['role']),
      joinedAt: serializer.fromJson<DateTime>(json['joinedAt']),
      shareLocation: serializer.fromJson<bool>(json['shareLocation']),
      notificationsEnabled: serializer.fromJson<bool>(
        json['notificationsEnabled'],
      ),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'groupId': serializer.toJson<String>(groupId),
      'userId': serializer.toJson<String>(userId),
      'role': serializer.toJson<String>(role),
      'joinedAt': serializer.toJson<DateTime>(joinedAt),
      'shareLocation': serializer.toJson<bool>(shareLocation),
      'notificationsEnabled': serializer.toJson<bool>(notificationsEnabled),
    };
  }

  GroupMembersTableData copyWith({
    String? groupId,
    String? userId,
    String? role,
    DateTime? joinedAt,
    bool? shareLocation,
    bool? notificationsEnabled,
  }) => GroupMembersTableData(
    groupId: groupId ?? this.groupId,
    userId: userId ?? this.userId,
    role: role ?? this.role,
    joinedAt: joinedAt ?? this.joinedAt,
    shareLocation: shareLocation ?? this.shareLocation,
    notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
  );
  GroupMembersTableData copyWithCompanion(GroupMembersTableCompanion data) {
    return GroupMembersTableData(
      groupId: data.groupId.present ? data.groupId.value : this.groupId,
      userId: data.userId.present ? data.userId.value : this.userId,
      role: data.role.present ? data.role.value : this.role,
      joinedAt: data.joinedAt.present ? data.joinedAt.value : this.joinedAt,
      shareLocation: data.shareLocation.present
          ? data.shareLocation.value
          : this.shareLocation,
      notificationsEnabled: data.notificationsEnabled.present
          ? data.notificationsEnabled.value
          : this.notificationsEnabled,
    );
  }

  @override
  String toString() {
    return (StringBuffer('GroupMembersTableData(')
          ..write('groupId: $groupId, ')
          ..write('userId: $userId, ')
          ..write('role: $role, ')
          ..write('joinedAt: $joinedAt, ')
          ..write('shareLocation: $shareLocation, ')
          ..write('notificationsEnabled: $notificationsEnabled')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    groupId,
    userId,
    role,
    joinedAt,
    shareLocation,
    notificationsEnabled,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is GroupMembersTableData &&
          other.groupId == this.groupId &&
          other.userId == this.userId &&
          other.role == this.role &&
          other.joinedAt == this.joinedAt &&
          other.shareLocation == this.shareLocation &&
          other.notificationsEnabled == this.notificationsEnabled);
}

class GroupMembersTableCompanion
    extends UpdateCompanion<GroupMembersTableData> {
  final Value<String> groupId;
  final Value<String> userId;
  final Value<String> role;
  final Value<DateTime> joinedAt;
  final Value<bool> shareLocation;
  final Value<bool> notificationsEnabled;
  final Value<int> rowid;
  const GroupMembersTableCompanion({
    this.groupId = const Value.absent(),
    this.userId = const Value.absent(),
    this.role = const Value.absent(),
    this.joinedAt = const Value.absent(),
    this.shareLocation = const Value.absent(),
    this.notificationsEnabled = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  GroupMembersTableCompanion.insert({
    required String groupId,
    required String userId,
    this.role = const Value.absent(),
    this.joinedAt = const Value.absent(),
    this.shareLocation = const Value.absent(),
    this.notificationsEnabled = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : groupId = Value(groupId),
       userId = Value(userId);
  static Insertable<GroupMembersTableData> custom({
    Expression<String>? groupId,
    Expression<String>? userId,
    Expression<String>? role,
    Expression<DateTime>? joinedAt,
    Expression<bool>? shareLocation,
    Expression<bool>? notificationsEnabled,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (groupId != null) 'group_id': groupId,
      if (userId != null) 'user_id': userId,
      if (role != null) 'role': role,
      if (joinedAt != null) 'joined_at': joinedAt,
      if (shareLocation != null) 'share_location': shareLocation,
      if (notificationsEnabled != null)
        'notifications_enabled': notificationsEnabled,
      if (rowid != null) 'rowid': rowid,
    });
  }

  GroupMembersTableCompanion copyWith({
    Value<String>? groupId,
    Value<String>? userId,
    Value<String>? role,
    Value<DateTime>? joinedAt,
    Value<bool>? shareLocation,
    Value<bool>? notificationsEnabled,
    Value<int>? rowid,
  }) {
    return GroupMembersTableCompanion(
      groupId: groupId ?? this.groupId,
      userId: userId ?? this.userId,
      role: role ?? this.role,
      joinedAt: joinedAt ?? this.joinedAt,
      shareLocation: shareLocation ?? this.shareLocation,
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (groupId.present) {
      map['group_id'] = Variable<String>(groupId.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<String>(userId.value);
    }
    if (role.present) {
      map['role'] = Variable<String>(role.value);
    }
    if (joinedAt.present) {
      map['joined_at'] = Variable<DateTime>(joinedAt.value);
    }
    if (shareLocation.present) {
      map['share_location'] = Variable<bool>(shareLocation.value);
    }
    if (notificationsEnabled.present) {
      map['notifications_enabled'] = Variable<bool>(notificationsEnabled.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('GroupMembersTableCompanion(')
          ..write('groupId: $groupId, ')
          ..write('userId: $userId, ')
          ..write('role: $role, ')
          ..write('joinedAt: $joinedAt, ')
          ..write('shareLocation: $shareLocation, ')
          ..write('notificationsEnabled: $notificationsEnabled, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $PlacesTableTable placesTable = $PlacesTableTable(this);
  late final $SettingsTableTable settingsTable = $SettingsTableTable(this);
  late final $BlockedFriendsTableTable blockedFriendsTable =
      $BlockedFriendsTableTable(this);
  late final $GroupsTableTable groupsTable = $GroupsTableTable(this);
  late final $GroupPlacesTableTable groupPlacesTable = $GroupPlacesTableTable(
    this,
  );
  late final $GroupMembersTableTable groupMembersTable =
      $GroupMembersTableTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    placesTable,
    settingsTable,
    blockedFriendsTable,
    groupsTable,
    groupPlacesTable,
    groupMembersTable,
  ];
}

typedef $$PlacesTableTableCreateCompanionBuilder =
    PlacesTableCompanion Function({
      required String id,
      required String name,
      required double latitude,
      required double longitude,
      Value<String> status,
      Value<String?> description,
      Value<String?> address,
      Value<String?> createdBy,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<String> syncStatus,
      Value<double?> radius,
      Value<int> rowid,
    });
typedef $$PlacesTableTableUpdateCompanionBuilder =
    PlacesTableCompanion Function({
      Value<String> id,
      Value<String> name,
      Value<double> latitude,
      Value<double> longitude,
      Value<String> status,
      Value<String?> description,
      Value<String?> address,
      Value<String?> createdBy,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<String> syncStatus,
      Value<double?> radius,
      Value<int> rowid,
    });

final class $$PlacesTableTableReferences
    extends BaseReferences<_$AppDatabase, $PlacesTableTable, PlacesTableData> {
  $$PlacesTableTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$GroupPlacesTableTable, List<GroupPlacesTableData>>
  _groupPlacesTableRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.groupPlacesTable,
    aliasName: $_aliasNameGenerator(
      db.placesTable.id,
      db.groupPlacesTable.placeId,
    ),
  );

  $$GroupPlacesTableTableProcessedTableManager get groupPlacesTableRefs {
    final manager = $$GroupPlacesTableTableTableManager(
      $_db,
      $_db.groupPlacesTable,
    ).filter((f) => f.placeId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _groupPlacesTableRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$PlacesTableTableFilterComposer
    extends Composer<_$AppDatabase, $PlacesTableTable> {
  $$PlacesTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
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

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get address => $composableBuilder(
    column: $table.address,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get createdBy => $composableBuilder(
    column: $table.createdBy,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get radius => $composableBuilder(
    column: $table.radius,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> groupPlacesTableRefs(
    Expression<bool> Function($$GroupPlacesTableTableFilterComposer f) f,
  ) {
    final $$GroupPlacesTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.groupPlacesTable,
      getReferencedColumn: (t) => t.placeId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$GroupPlacesTableTableFilterComposer(
            $db: $db,
            $table: $db.groupPlacesTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$PlacesTableTableOrderingComposer
    extends Composer<_$AppDatabase, $PlacesTableTable> {
  $$PlacesTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
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

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get address => $composableBuilder(
    column: $table.address,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get createdBy => $composableBuilder(
    column: $table.createdBy,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get radius => $composableBuilder(
    column: $table.radius,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$PlacesTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $PlacesTableTable> {
  $$PlacesTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<double> get latitude =>
      $composableBuilder(column: $table.latitude, builder: (column) => column);

  GeneratedColumn<double> get longitude =>
      $composableBuilder(column: $table.longitude, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );

  GeneratedColumn<String> get address =>
      $composableBuilder(column: $table.address, builder: (column) => column);

  GeneratedColumn<String> get createdBy =>
      $composableBuilder(column: $table.createdBy, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<String> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => column,
  );

  GeneratedColumn<double> get radius =>
      $composableBuilder(column: $table.radius, builder: (column) => column);

  Expression<T> groupPlacesTableRefs<T extends Object>(
    Expression<T> Function($$GroupPlacesTableTableAnnotationComposer a) f,
  ) {
    final $$GroupPlacesTableTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.groupPlacesTable,
      getReferencedColumn: (t) => t.placeId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$GroupPlacesTableTableAnnotationComposer(
            $db: $db,
            $table: $db.groupPlacesTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$PlacesTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $PlacesTableTable,
          PlacesTableData,
          $$PlacesTableTableFilterComposer,
          $$PlacesTableTableOrderingComposer,
          $$PlacesTableTableAnnotationComposer,
          $$PlacesTableTableCreateCompanionBuilder,
          $$PlacesTableTableUpdateCompanionBuilder,
          (PlacesTableData, $$PlacesTableTableReferences),
          PlacesTableData,
          PrefetchHooks Function({bool groupPlacesTableRefs})
        > {
  $$PlacesTableTableTableManager(_$AppDatabase db, $PlacesTableTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PlacesTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PlacesTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PlacesTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<double> latitude = const Value.absent(),
                Value<double> longitude = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<String?> description = const Value.absent(),
                Value<String?> address = const Value.absent(),
                Value<String?> createdBy = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<String> syncStatus = const Value.absent(),
                Value<double?> radius = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => PlacesTableCompanion(
                id: id,
                name: name,
                latitude: latitude,
                longitude: longitude,
                status: status,
                description: description,
                address: address,
                createdBy: createdBy,
                createdAt: createdAt,
                updatedAt: updatedAt,
                syncStatus: syncStatus,
                radius: radius,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String name,
                required double latitude,
                required double longitude,
                Value<String> status = const Value.absent(),
                Value<String?> description = const Value.absent(),
                Value<String?> address = const Value.absent(),
                Value<String?> createdBy = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<String> syncStatus = const Value.absent(),
                Value<double?> radius = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => PlacesTableCompanion.insert(
                id: id,
                name: name,
                latitude: latitude,
                longitude: longitude,
                status: status,
                description: description,
                address: address,
                createdBy: createdBy,
                createdAt: createdAt,
                updatedAt: updatedAt,
                syncStatus: syncStatus,
                radius: radius,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$PlacesTableTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({groupPlacesTableRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (groupPlacesTableRefs) db.groupPlacesTable,
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (groupPlacesTableRefs)
                    await $_getPrefetchedData<
                      PlacesTableData,
                      $PlacesTableTable,
                      GroupPlacesTableData
                    >(
                      currentTable: table,
                      referencedTable: $$PlacesTableTableReferences
                          ._groupPlacesTableRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$PlacesTableTableReferences(
                            db,
                            table,
                            p0,
                          ).groupPlacesTableRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.placeId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$PlacesTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $PlacesTableTable,
      PlacesTableData,
      $$PlacesTableTableFilterComposer,
      $$PlacesTableTableOrderingComposer,
      $$PlacesTableTableAnnotationComposer,
      $$PlacesTableTableCreateCompanionBuilder,
      $$PlacesTableTableUpdateCompanionBuilder,
      (PlacesTableData, $$PlacesTableTableReferences),
      PlacesTableData,
      PrefetchHooks Function({bool groupPlacesTableRefs})
    >;
typedef $$SettingsTableTableCreateCompanionBuilder =
    SettingsTableCompanion Function({
      Value<int> id,
      Value<String> themeMode,
      Value<bool> gpsEnabled,
      Value<String> gpsPerformanceMode,
      Value<int> gpsSyncFrequency,
      Value<DateTime?> ghostModeUntil,
    });
typedef $$SettingsTableTableUpdateCompanionBuilder =
    SettingsTableCompanion Function({
      Value<int> id,
      Value<String> themeMode,
      Value<bool> gpsEnabled,
      Value<String> gpsPerformanceMode,
      Value<int> gpsSyncFrequency,
      Value<DateTime?> ghostModeUntil,
    });

class $$SettingsTableTableFilterComposer
    extends Composer<_$AppDatabase, $SettingsTableTable> {
  $$SettingsTableTableFilterComposer({
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

  ColumnFilters<String> get themeMode => $composableBuilder(
    column: $table.themeMode,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get gpsEnabled => $composableBuilder(
    column: $table.gpsEnabled,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get gpsPerformanceMode => $composableBuilder(
    column: $table.gpsPerformanceMode,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get gpsSyncFrequency => $composableBuilder(
    column: $table.gpsSyncFrequency,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get ghostModeUntil => $composableBuilder(
    column: $table.ghostModeUntil,
    builder: (column) => ColumnFilters(column),
  );
}

class $$SettingsTableTableOrderingComposer
    extends Composer<_$AppDatabase, $SettingsTableTable> {
  $$SettingsTableTableOrderingComposer({
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

  ColumnOrderings<String> get themeMode => $composableBuilder(
    column: $table.themeMode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get gpsEnabled => $composableBuilder(
    column: $table.gpsEnabled,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get gpsPerformanceMode => $composableBuilder(
    column: $table.gpsPerformanceMode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get gpsSyncFrequency => $composableBuilder(
    column: $table.gpsSyncFrequency,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get ghostModeUntil => $composableBuilder(
    column: $table.ghostModeUntil,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SettingsTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $SettingsTableTable> {
  $$SettingsTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get themeMode =>
      $composableBuilder(column: $table.themeMode, builder: (column) => column);

  GeneratedColumn<bool> get gpsEnabled => $composableBuilder(
    column: $table.gpsEnabled,
    builder: (column) => column,
  );

  GeneratedColumn<String> get gpsPerformanceMode => $composableBuilder(
    column: $table.gpsPerformanceMode,
    builder: (column) => column,
  );

  GeneratedColumn<int> get gpsSyncFrequency => $composableBuilder(
    column: $table.gpsSyncFrequency,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get ghostModeUntil => $composableBuilder(
    column: $table.ghostModeUntil,
    builder: (column) => column,
  );
}

class $$SettingsTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SettingsTableTable,
          SettingsTableData,
          $$SettingsTableTableFilterComposer,
          $$SettingsTableTableOrderingComposer,
          $$SettingsTableTableAnnotationComposer,
          $$SettingsTableTableCreateCompanionBuilder,
          $$SettingsTableTableUpdateCompanionBuilder,
          (
            SettingsTableData,
            BaseReferences<
              _$AppDatabase,
              $SettingsTableTable,
              SettingsTableData
            >,
          ),
          SettingsTableData,
          PrefetchHooks Function()
        > {
  $$SettingsTableTableTableManager(_$AppDatabase db, $SettingsTableTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SettingsTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SettingsTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SettingsTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> themeMode = const Value.absent(),
                Value<bool> gpsEnabled = const Value.absent(),
                Value<String> gpsPerformanceMode = const Value.absent(),
                Value<int> gpsSyncFrequency = const Value.absent(),
                Value<DateTime?> ghostModeUntil = const Value.absent(),
              }) => SettingsTableCompanion(
                id: id,
                themeMode: themeMode,
                gpsEnabled: gpsEnabled,
                gpsPerformanceMode: gpsPerformanceMode,
                gpsSyncFrequency: gpsSyncFrequency,
                ghostModeUntil: ghostModeUntil,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> themeMode = const Value.absent(),
                Value<bool> gpsEnabled = const Value.absent(),
                Value<String> gpsPerformanceMode = const Value.absent(),
                Value<int> gpsSyncFrequency = const Value.absent(),
                Value<DateTime?> ghostModeUntil = const Value.absent(),
              }) => SettingsTableCompanion.insert(
                id: id,
                themeMode: themeMode,
                gpsEnabled: gpsEnabled,
                gpsPerformanceMode: gpsPerformanceMode,
                gpsSyncFrequency: gpsSyncFrequency,
                ghostModeUntil: ghostModeUntil,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$SettingsTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SettingsTableTable,
      SettingsTableData,
      $$SettingsTableTableFilterComposer,
      $$SettingsTableTableOrderingComposer,
      $$SettingsTableTableAnnotationComposer,
      $$SettingsTableTableCreateCompanionBuilder,
      $$SettingsTableTableUpdateCompanionBuilder,
      (
        SettingsTableData,
        BaseReferences<_$AppDatabase, $SettingsTableTable, SettingsTableData>,
      ),
      SettingsTableData,
      PrefetchHooks Function()
    >;
typedef $$BlockedFriendsTableTableCreateCompanionBuilder =
    BlockedFriendsTableCompanion Function({
      required String userId,
      Value<DateTime> blockedAt,
      Value<int> rowid,
    });
typedef $$BlockedFriendsTableTableUpdateCompanionBuilder =
    BlockedFriendsTableCompanion Function({
      Value<String> userId,
      Value<DateTime> blockedAt,
      Value<int> rowid,
    });

class $$BlockedFriendsTableTableFilterComposer
    extends Composer<_$AppDatabase, $BlockedFriendsTableTable> {
  $$BlockedFriendsTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get blockedAt => $composableBuilder(
    column: $table.blockedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$BlockedFriendsTableTableOrderingComposer
    extends Composer<_$AppDatabase, $BlockedFriendsTableTable> {
  $$BlockedFriendsTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get blockedAt => $composableBuilder(
    column: $table.blockedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$BlockedFriendsTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $BlockedFriendsTableTable> {
  $$BlockedFriendsTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get userId =>
      $composableBuilder(column: $table.userId, builder: (column) => column);

  GeneratedColumn<DateTime> get blockedAt =>
      $composableBuilder(column: $table.blockedAt, builder: (column) => column);
}

class $$BlockedFriendsTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $BlockedFriendsTableTable,
          BlockedFriendsTableData,
          $$BlockedFriendsTableTableFilterComposer,
          $$BlockedFriendsTableTableOrderingComposer,
          $$BlockedFriendsTableTableAnnotationComposer,
          $$BlockedFriendsTableTableCreateCompanionBuilder,
          $$BlockedFriendsTableTableUpdateCompanionBuilder,
          (
            BlockedFriendsTableData,
            BaseReferences<
              _$AppDatabase,
              $BlockedFriendsTableTable,
              BlockedFriendsTableData
            >,
          ),
          BlockedFriendsTableData,
          PrefetchHooks Function()
        > {
  $$BlockedFriendsTableTableTableManager(
    _$AppDatabase db,
    $BlockedFriendsTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$BlockedFriendsTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$BlockedFriendsTableTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$BlockedFriendsTableTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> userId = const Value.absent(),
                Value<DateTime> blockedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => BlockedFriendsTableCompanion(
                userId: userId,
                blockedAt: blockedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String userId,
                Value<DateTime> blockedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => BlockedFriendsTableCompanion.insert(
                userId: userId,
                blockedAt: blockedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$BlockedFriendsTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $BlockedFriendsTableTable,
      BlockedFriendsTableData,
      $$BlockedFriendsTableTableFilterComposer,
      $$BlockedFriendsTableTableOrderingComposer,
      $$BlockedFriendsTableTableAnnotationComposer,
      $$BlockedFriendsTableTableCreateCompanionBuilder,
      $$BlockedFriendsTableTableUpdateCompanionBuilder,
      (
        BlockedFriendsTableData,
        BaseReferences<
          _$AppDatabase,
          $BlockedFriendsTableTable,
          BlockedFriendsTableData
        >,
      ),
      BlockedFriendsTableData,
      PrefetchHooks Function()
    >;
typedef $$GroupsTableTableCreateCompanionBuilder =
    GroupsTableCompanion Function({
      required String id,
      required String name,
      Value<String?> description,
      required String createdBy,
      required DateTime createdAt,
      Value<bool> isPublic,
      Value<bool> requiresApproval,
      Value<bool> autoCheckinEnabled,
      Value<bool> notificationEnabled,
      Value<int> rowid,
    });
typedef $$GroupsTableTableUpdateCompanionBuilder =
    GroupsTableCompanion Function({
      Value<String> id,
      Value<String> name,
      Value<String?> description,
      Value<String> createdBy,
      Value<DateTime> createdAt,
      Value<bool> isPublic,
      Value<bool> requiresApproval,
      Value<bool> autoCheckinEnabled,
      Value<bool> notificationEnabled,
      Value<int> rowid,
    });

final class $$GroupsTableTableReferences
    extends BaseReferences<_$AppDatabase, $GroupsTableTable, GroupsTableData> {
  $$GroupsTableTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$GroupPlacesTableTable, List<GroupPlacesTableData>>
  _groupPlacesTableRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.groupPlacesTable,
    aliasName: $_aliasNameGenerator(
      db.groupsTable.id,
      db.groupPlacesTable.groupId,
    ),
  );

  $$GroupPlacesTableTableProcessedTableManager get groupPlacesTableRefs {
    final manager = $$GroupPlacesTableTableTableManager(
      $_db,
      $_db.groupPlacesTable,
    ).filter((f) => f.groupId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _groupPlacesTableRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<
    $GroupMembersTableTable,
    List<GroupMembersTableData>
  >
  _groupMembersTableRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.groupMembersTable,
        aliasName: $_aliasNameGenerator(
          db.groupsTable.id,
          db.groupMembersTable.groupId,
        ),
      );

  $$GroupMembersTableTableProcessedTableManager get groupMembersTableRefs {
    final manager = $$GroupMembersTableTableTableManager(
      $_db,
      $_db.groupMembersTable,
    ).filter((f) => f.groupId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _groupMembersTableRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$GroupsTableTableFilterComposer
    extends Composer<_$AppDatabase, $GroupsTableTable> {
  $$GroupsTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
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

  ColumnFilters<String> get createdBy => $composableBuilder(
    column: $table.createdBy,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isPublic => $composableBuilder(
    column: $table.isPublic,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get requiresApproval => $composableBuilder(
    column: $table.requiresApproval,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get autoCheckinEnabled => $composableBuilder(
    column: $table.autoCheckinEnabled,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get notificationEnabled => $composableBuilder(
    column: $table.notificationEnabled,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> groupPlacesTableRefs(
    Expression<bool> Function($$GroupPlacesTableTableFilterComposer f) f,
  ) {
    final $$GroupPlacesTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.groupPlacesTable,
      getReferencedColumn: (t) => t.groupId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$GroupPlacesTableTableFilterComposer(
            $db: $db,
            $table: $db.groupPlacesTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> groupMembersTableRefs(
    Expression<bool> Function($$GroupMembersTableTableFilterComposer f) f,
  ) {
    final $$GroupMembersTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.groupMembersTable,
      getReferencedColumn: (t) => t.groupId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$GroupMembersTableTableFilterComposer(
            $db: $db,
            $table: $db.groupMembersTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$GroupsTableTableOrderingComposer
    extends Composer<_$AppDatabase, $GroupsTableTable> {
  $$GroupsTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
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

  ColumnOrderings<String> get createdBy => $composableBuilder(
    column: $table.createdBy,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isPublic => $composableBuilder(
    column: $table.isPublic,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get requiresApproval => $composableBuilder(
    column: $table.requiresApproval,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get autoCheckinEnabled => $composableBuilder(
    column: $table.autoCheckinEnabled,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get notificationEnabled => $composableBuilder(
    column: $table.notificationEnabled,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$GroupsTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $GroupsTableTable> {
  $$GroupsTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );

  GeneratedColumn<String> get createdBy =>
      $composableBuilder(column: $table.createdBy, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<bool> get isPublic =>
      $composableBuilder(column: $table.isPublic, builder: (column) => column);

  GeneratedColumn<bool> get requiresApproval => $composableBuilder(
    column: $table.requiresApproval,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get autoCheckinEnabled => $composableBuilder(
    column: $table.autoCheckinEnabled,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get notificationEnabled => $composableBuilder(
    column: $table.notificationEnabled,
    builder: (column) => column,
  );

  Expression<T> groupPlacesTableRefs<T extends Object>(
    Expression<T> Function($$GroupPlacesTableTableAnnotationComposer a) f,
  ) {
    final $$GroupPlacesTableTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.groupPlacesTable,
      getReferencedColumn: (t) => t.groupId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$GroupPlacesTableTableAnnotationComposer(
            $db: $db,
            $table: $db.groupPlacesTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> groupMembersTableRefs<T extends Object>(
    Expression<T> Function($$GroupMembersTableTableAnnotationComposer a) f,
  ) {
    final $$GroupMembersTableTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.groupMembersTable,
          getReferencedColumn: (t) => t.groupId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$GroupMembersTableTableAnnotationComposer(
                $db: $db,
                $table: $db.groupMembersTable,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
}

class $$GroupsTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $GroupsTableTable,
          GroupsTableData,
          $$GroupsTableTableFilterComposer,
          $$GroupsTableTableOrderingComposer,
          $$GroupsTableTableAnnotationComposer,
          $$GroupsTableTableCreateCompanionBuilder,
          $$GroupsTableTableUpdateCompanionBuilder,
          (GroupsTableData, $$GroupsTableTableReferences),
          GroupsTableData,
          PrefetchHooks Function({
            bool groupPlacesTableRefs,
            bool groupMembersTableRefs,
          })
        > {
  $$GroupsTableTableTableManager(_$AppDatabase db, $GroupsTableTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$GroupsTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$GroupsTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$GroupsTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String?> description = const Value.absent(),
                Value<String> createdBy = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<bool> isPublic = const Value.absent(),
                Value<bool> requiresApproval = const Value.absent(),
                Value<bool> autoCheckinEnabled = const Value.absent(),
                Value<bool> notificationEnabled = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => GroupsTableCompanion(
                id: id,
                name: name,
                description: description,
                createdBy: createdBy,
                createdAt: createdAt,
                isPublic: isPublic,
                requiresApproval: requiresApproval,
                autoCheckinEnabled: autoCheckinEnabled,
                notificationEnabled: notificationEnabled,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String name,
                Value<String?> description = const Value.absent(),
                required String createdBy,
                required DateTime createdAt,
                Value<bool> isPublic = const Value.absent(),
                Value<bool> requiresApproval = const Value.absent(),
                Value<bool> autoCheckinEnabled = const Value.absent(),
                Value<bool> notificationEnabled = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => GroupsTableCompanion.insert(
                id: id,
                name: name,
                description: description,
                createdBy: createdBy,
                createdAt: createdAt,
                isPublic: isPublic,
                requiresApproval: requiresApproval,
                autoCheckinEnabled: autoCheckinEnabled,
                notificationEnabled: notificationEnabled,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$GroupsTableTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({groupPlacesTableRefs = false, groupMembersTableRefs = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (groupPlacesTableRefs) db.groupPlacesTable,
                    if (groupMembersTableRefs) db.groupMembersTable,
                  ],
                  addJoins: null,
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (groupPlacesTableRefs)
                        await $_getPrefetchedData<
                          GroupsTableData,
                          $GroupsTableTable,
                          GroupPlacesTableData
                        >(
                          currentTable: table,
                          referencedTable: $$GroupsTableTableReferences
                              ._groupPlacesTableRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$GroupsTableTableReferences(
                                db,
                                table,
                                p0,
                              ).groupPlacesTableRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.groupId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (groupMembersTableRefs)
                        await $_getPrefetchedData<
                          GroupsTableData,
                          $GroupsTableTable,
                          GroupMembersTableData
                        >(
                          currentTable: table,
                          referencedTable: $$GroupsTableTableReferences
                              ._groupMembersTableRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$GroupsTableTableReferences(
                                db,
                                table,
                                p0,
                              ).groupMembersTableRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.groupId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$GroupsTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $GroupsTableTable,
      GroupsTableData,
      $$GroupsTableTableFilterComposer,
      $$GroupsTableTableOrderingComposer,
      $$GroupsTableTableAnnotationComposer,
      $$GroupsTableTableCreateCompanionBuilder,
      $$GroupsTableTableUpdateCompanionBuilder,
      (GroupsTableData, $$GroupsTableTableReferences),
      GroupsTableData,
      PrefetchHooks Function({
        bool groupPlacesTableRefs,
        bool groupMembersTableRefs,
      })
    >;
typedef $$GroupPlacesTableTableCreateCompanionBuilder =
    GroupPlacesTableCompanion Function({
      required String groupId,
      required String placeId,
      Value<bool> isPrimary,
      Value<int> displayOrder,
      Value<DateTime> addedAt,
      Value<double> radius,
      Value<String?> description,
      Value<String> placeType,
      Value<int> rowid,
    });
typedef $$GroupPlacesTableTableUpdateCompanionBuilder =
    GroupPlacesTableCompanion Function({
      Value<String> groupId,
      Value<String> placeId,
      Value<bool> isPrimary,
      Value<int> displayOrder,
      Value<DateTime> addedAt,
      Value<double> radius,
      Value<String?> description,
      Value<String> placeType,
      Value<int> rowid,
    });

final class $$GroupPlacesTableTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $GroupPlacesTableTable,
          GroupPlacesTableData
        > {
  $$GroupPlacesTableTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $GroupsTableTable _groupIdTable(_$AppDatabase db) =>
      db.groupsTable.createAlias(
        $_aliasNameGenerator(db.groupPlacesTable.groupId, db.groupsTable.id),
      );

  $$GroupsTableTableProcessedTableManager get groupId {
    final $_column = $_itemColumn<String>('group_id')!;

    final manager = $$GroupsTableTableTableManager(
      $_db,
      $_db.groupsTable,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_groupIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $PlacesTableTable _placeIdTable(_$AppDatabase db) =>
      db.placesTable.createAlias(
        $_aliasNameGenerator(db.groupPlacesTable.placeId, db.placesTable.id),
      );

  $$PlacesTableTableProcessedTableManager get placeId {
    final $_column = $_itemColumn<String>('place_id')!;

    final manager = $$PlacesTableTableTableManager(
      $_db,
      $_db.placesTable,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_placeIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$GroupPlacesTableTableFilterComposer
    extends Composer<_$AppDatabase, $GroupPlacesTableTable> {
  $$GroupPlacesTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<bool> get isPrimary => $composableBuilder(
    column: $table.isPrimary,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get displayOrder => $composableBuilder(
    column: $table.displayOrder,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get addedAt => $composableBuilder(
    column: $table.addedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get radius => $composableBuilder(
    column: $table.radius,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get placeType => $composableBuilder(
    column: $table.placeType,
    builder: (column) => ColumnFilters(column),
  );

  $$GroupsTableTableFilterComposer get groupId {
    final $$GroupsTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.groupId,
      referencedTable: $db.groupsTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$GroupsTableTableFilterComposer(
            $db: $db,
            $table: $db.groupsTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$PlacesTableTableFilterComposer get placeId {
    final $$PlacesTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.placeId,
      referencedTable: $db.placesTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PlacesTableTableFilterComposer(
            $db: $db,
            $table: $db.placesTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$GroupPlacesTableTableOrderingComposer
    extends Composer<_$AppDatabase, $GroupPlacesTableTable> {
  $$GroupPlacesTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<bool> get isPrimary => $composableBuilder(
    column: $table.isPrimary,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get displayOrder => $composableBuilder(
    column: $table.displayOrder,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get addedAt => $composableBuilder(
    column: $table.addedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get radius => $composableBuilder(
    column: $table.radius,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get placeType => $composableBuilder(
    column: $table.placeType,
    builder: (column) => ColumnOrderings(column),
  );

  $$GroupsTableTableOrderingComposer get groupId {
    final $$GroupsTableTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.groupId,
      referencedTable: $db.groupsTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$GroupsTableTableOrderingComposer(
            $db: $db,
            $table: $db.groupsTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$PlacesTableTableOrderingComposer get placeId {
    final $$PlacesTableTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.placeId,
      referencedTable: $db.placesTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PlacesTableTableOrderingComposer(
            $db: $db,
            $table: $db.placesTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$GroupPlacesTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $GroupPlacesTableTable> {
  $$GroupPlacesTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<bool> get isPrimary =>
      $composableBuilder(column: $table.isPrimary, builder: (column) => column);

  GeneratedColumn<int> get displayOrder => $composableBuilder(
    column: $table.displayOrder,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get addedAt =>
      $composableBuilder(column: $table.addedAt, builder: (column) => column);

  GeneratedColumn<double> get radius =>
      $composableBuilder(column: $table.radius, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );

  GeneratedColumn<String> get placeType =>
      $composableBuilder(column: $table.placeType, builder: (column) => column);

  $$GroupsTableTableAnnotationComposer get groupId {
    final $$GroupsTableTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.groupId,
      referencedTable: $db.groupsTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$GroupsTableTableAnnotationComposer(
            $db: $db,
            $table: $db.groupsTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$PlacesTableTableAnnotationComposer get placeId {
    final $$PlacesTableTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.placeId,
      referencedTable: $db.placesTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PlacesTableTableAnnotationComposer(
            $db: $db,
            $table: $db.placesTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$GroupPlacesTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $GroupPlacesTableTable,
          GroupPlacesTableData,
          $$GroupPlacesTableTableFilterComposer,
          $$GroupPlacesTableTableOrderingComposer,
          $$GroupPlacesTableTableAnnotationComposer,
          $$GroupPlacesTableTableCreateCompanionBuilder,
          $$GroupPlacesTableTableUpdateCompanionBuilder,
          (GroupPlacesTableData, $$GroupPlacesTableTableReferences),
          GroupPlacesTableData,
          PrefetchHooks Function({bool groupId, bool placeId})
        > {
  $$GroupPlacesTableTableTableManager(
    _$AppDatabase db,
    $GroupPlacesTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$GroupPlacesTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$GroupPlacesTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$GroupPlacesTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> groupId = const Value.absent(),
                Value<String> placeId = const Value.absent(),
                Value<bool> isPrimary = const Value.absent(),
                Value<int> displayOrder = const Value.absent(),
                Value<DateTime> addedAt = const Value.absent(),
                Value<double> radius = const Value.absent(),
                Value<String?> description = const Value.absent(),
                Value<String> placeType = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => GroupPlacesTableCompanion(
                groupId: groupId,
                placeId: placeId,
                isPrimary: isPrimary,
                displayOrder: displayOrder,
                addedAt: addedAt,
                radius: radius,
                description: description,
                placeType: placeType,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String groupId,
                required String placeId,
                Value<bool> isPrimary = const Value.absent(),
                Value<int> displayOrder = const Value.absent(),
                Value<DateTime> addedAt = const Value.absent(),
                Value<double> radius = const Value.absent(),
                Value<String?> description = const Value.absent(),
                Value<String> placeType = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => GroupPlacesTableCompanion.insert(
                groupId: groupId,
                placeId: placeId,
                isPrimary: isPrimary,
                displayOrder: displayOrder,
                addedAt: addedAt,
                radius: radius,
                description: description,
                placeType: placeType,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$GroupPlacesTableTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({groupId = false, placeId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (groupId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.groupId,
                                referencedTable:
                                    $$GroupPlacesTableTableReferences
                                        ._groupIdTable(db),
                                referencedColumn:
                                    $$GroupPlacesTableTableReferences
                                        ._groupIdTable(db)
                                        .id,
                              )
                              as T;
                    }
                    if (placeId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.placeId,
                                referencedTable:
                                    $$GroupPlacesTableTableReferences
                                        ._placeIdTable(db),
                                referencedColumn:
                                    $$GroupPlacesTableTableReferences
                                        ._placeIdTable(db)
                                        .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$GroupPlacesTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $GroupPlacesTableTable,
      GroupPlacesTableData,
      $$GroupPlacesTableTableFilterComposer,
      $$GroupPlacesTableTableOrderingComposer,
      $$GroupPlacesTableTableAnnotationComposer,
      $$GroupPlacesTableTableCreateCompanionBuilder,
      $$GroupPlacesTableTableUpdateCompanionBuilder,
      (GroupPlacesTableData, $$GroupPlacesTableTableReferences),
      GroupPlacesTableData,
      PrefetchHooks Function({bool groupId, bool placeId})
    >;
typedef $$GroupMembersTableTableCreateCompanionBuilder =
    GroupMembersTableCompanion Function({
      required String groupId,
      required String userId,
      Value<String> role,
      Value<DateTime> joinedAt,
      Value<bool> shareLocation,
      Value<bool> notificationsEnabled,
      Value<int> rowid,
    });
typedef $$GroupMembersTableTableUpdateCompanionBuilder =
    GroupMembersTableCompanion Function({
      Value<String> groupId,
      Value<String> userId,
      Value<String> role,
      Value<DateTime> joinedAt,
      Value<bool> shareLocation,
      Value<bool> notificationsEnabled,
      Value<int> rowid,
    });

final class $$GroupMembersTableTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $GroupMembersTableTable,
          GroupMembersTableData
        > {
  $$GroupMembersTableTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $GroupsTableTable _groupIdTable(_$AppDatabase db) =>
      db.groupsTable.createAlias(
        $_aliasNameGenerator(db.groupMembersTable.groupId, db.groupsTable.id),
      );

  $$GroupsTableTableProcessedTableManager get groupId {
    final $_column = $_itemColumn<String>('group_id')!;

    final manager = $$GroupsTableTableTableManager(
      $_db,
      $_db.groupsTable,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_groupIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$GroupMembersTableTableFilterComposer
    extends Composer<_$AppDatabase, $GroupMembersTableTable> {
  $$GroupMembersTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get role => $composableBuilder(
    column: $table.role,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get joinedAt => $composableBuilder(
    column: $table.joinedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get shareLocation => $composableBuilder(
    column: $table.shareLocation,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get notificationsEnabled => $composableBuilder(
    column: $table.notificationsEnabled,
    builder: (column) => ColumnFilters(column),
  );

  $$GroupsTableTableFilterComposer get groupId {
    final $$GroupsTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.groupId,
      referencedTable: $db.groupsTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$GroupsTableTableFilterComposer(
            $db: $db,
            $table: $db.groupsTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$GroupMembersTableTableOrderingComposer
    extends Composer<_$AppDatabase, $GroupMembersTableTable> {
  $$GroupMembersTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get role => $composableBuilder(
    column: $table.role,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get joinedAt => $composableBuilder(
    column: $table.joinedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get shareLocation => $composableBuilder(
    column: $table.shareLocation,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get notificationsEnabled => $composableBuilder(
    column: $table.notificationsEnabled,
    builder: (column) => ColumnOrderings(column),
  );

  $$GroupsTableTableOrderingComposer get groupId {
    final $$GroupsTableTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.groupId,
      referencedTable: $db.groupsTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$GroupsTableTableOrderingComposer(
            $db: $db,
            $table: $db.groupsTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$GroupMembersTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $GroupMembersTableTable> {
  $$GroupMembersTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get userId =>
      $composableBuilder(column: $table.userId, builder: (column) => column);

  GeneratedColumn<String> get role =>
      $composableBuilder(column: $table.role, builder: (column) => column);

  GeneratedColumn<DateTime> get joinedAt =>
      $composableBuilder(column: $table.joinedAt, builder: (column) => column);

  GeneratedColumn<bool> get shareLocation => $composableBuilder(
    column: $table.shareLocation,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get notificationsEnabled => $composableBuilder(
    column: $table.notificationsEnabled,
    builder: (column) => column,
  );

  $$GroupsTableTableAnnotationComposer get groupId {
    final $$GroupsTableTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.groupId,
      referencedTable: $db.groupsTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$GroupsTableTableAnnotationComposer(
            $db: $db,
            $table: $db.groupsTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$GroupMembersTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $GroupMembersTableTable,
          GroupMembersTableData,
          $$GroupMembersTableTableFilterComposer,
          $$GroupMembersTableTableOrderingComposer,
          $$GroupMembersTableTableAnnotationComposer,
          $$GroupMembersTableTableCreateCompanionBuilder,
          $$GroupMembersTableTableUpdateCompanionBuilder,
          (GroupMembersTableData, $$GroupMembersTableTableReferences),
          GroupMembersTableData,
          PrefetchHooks Function({bool groupId})
        > {
  $$GroupMembersTableTableTableManager(
    _$AppDatabase db,
    $GroupMembersTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$GroupMembersTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$GroupMembersTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$GroupMembersTableTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> groupId = const Value.absent(),
                Value<String> userId = const Value.absent(),
                Value<String> role = const Value.absent(),
                Value<DateTime> joinedAt = const Value.absent(),
                Value<bool> shareLocation = const Value.absent(),
                Value<bool> notificationsEnabled = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => GroupMembersTableCompanion(
                groupId: groupId,
                userId: userId,
                role: role,
                joinedAt: joinedAt,
                shareLocation: shareLocation,
                notificationsEnabled: notificationsEnabled,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String groupId,
                required String userId,
                Value<String> role = const Value.absent(),
                Value<DateTime> joinedAt = const Value.absent(),
                Value<bool> shareLocation = const Value.absent(),
                Value<bool> notificationsEnabled = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => GroupMembersTableCompanion.insert(
                groupId: groupId,
                userId: userId,
                role: role,
                joinedAt: joinedAt,
                shareLocation: shareLocation,
                notificationsEnabled: notificationsEnabled,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$GroupMembersTableTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({groupId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (groupId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.groupId,
                                referencedTable:
                                    $$GroupMembersTableTableReferences
                                        ._groupIdTable(db),
                                referencedColumn:
                                    $$GroupMembersTableTableReferences
                                        ._groupIdTable(db)
                                        .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$GroupMembersTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $GroupMembersTableTable,
      GroupMembersTableData,
      $$GroupMembersTableTableFilterComposer,
      $$GroupMembersTableTableOrderingComposer,
      $$GroupMembersTableTableAnnotationComposer,
      $$GroupMembersTableTableCreateCompanionBuilder,
      $$GroupMembersTableTableUpdateCompanionBuilder,
      (GroupMembersTableData, $$GroupMembersTableTableReferences),
      GroupMembersTableData,
      PrefetchHooks Function({bool groupId})
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$PlacesTableTableTableManager get placesTable =>
      $$PlacesTableTableTableManager(_db, _db.placesTable);
  $$SettingsTableTableTableManager get settingsTable =>
      $$SettingsTableTableTableManager(_db, _db.settingsTable);
  $$BlockedFriendsTableTableTableManager get blockedFriendsTable =>
      $$BlockedFriendsTableTableTableManager(_db, _db.blockedFriendsTable);
  $$GroupsTableTableTableManager get groupsTable =>
      $$GroupsTableTableTableManager(_db, _db.groupsTable);
  $$GroupPlacesTableTableTableManager get groupPlacesTable =>
      $$GroupPlacesTableTableTableManager(_db, _db.groupPlacesTable);
  $$GroupMembersTableTableTableManager get groupMembersTable =>
      $$GroupMembersTableTableTableManager(_db, _db.groupMembersTable);
}
