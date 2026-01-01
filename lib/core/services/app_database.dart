import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

part 'app_database.g.dart';

class PlacesTable extends Table {
  @override
  String get tableName => 'places';

  TextColumn get id => text()();
  TextColumn get name => text()();
  RealColumn get latitude => real()();
  RealColumn get longitude => real()();
  TextColumn get status => text().withDefault(
    const Constant('inactive'),
  )(); // active, planned, inactive
  TextColumn get description => text().nullable()();
  TextColumn get address => text().nullable()();
  TextColumn get createdBy => text().nullable()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
  TextColumn get syncStatus => text().withDefault(
    const Constant('synced'),
  )(); // synced, created, updated, deleted

  @override
  Set<Column> get primaryKey => {id};
}

class SettingsTable extends Table {
  @override
  String get tableName => 'settings';

  IntColumn get id => integer().autoIncrement()();
  TextColumn get themeMode =>
      text().withDefault(const Constant('system'))(); // system, light, dark
  BoolColumn get gpsEnabled => boolean().withDefault(const Constant(true))();
  TextColumn get gpsPerformanceMode => text().withDefault(
    const Constant('balanced'),
  )(); // high_accuracy, balanced, low_power
  IntColumn get gpsSyncFrequency =>
      integer().withDefault(const Constant(15))(); // minutes
  DateTimeColumn get ghostModeUntil => dateTime().nullable()();
}

class BlockedFriendsTable extends Table {
  @override
  String get tableName => 'blocked_friends';

  TextColumn get userId => text()();
  DateTimeColumn get blockedAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {userId};
}

class GroupsTable extends Table {
  @override
  String get tableName => 'groups';

  TextColumn get id => text()();
  TextColumn get name => text()();
  TextColumn get description => text().nullable()();
  TextColumn get createdBy => text()();
  DateTimeColumn get createdAt => dateTime()();
  BoolColumn get isPublic => boolean().withDefault(const Constant(false))();
  BoolColumn get requiresApproval =>
      boolean().withDefault(const Constant(false))();
  BoolColumn get autoCheckinEnabled =>
      boolean().withDefault(const Constant(false))();
  BoolColumn get notificationEnabled =>
      boolean().withDefault(const Constant(true))();

  @override
  Set<Column> get primaryKey => {id};
}

class GroupPlacesTable extends Table {
  @override
  String get tableName => 'group_places';

  TextColumn get groupId => text().references(GroupsTable, #id)();
  TextColumn get placeId => text().references(PlacesTable, #id)();
  BoolColumn get isPrimary => boolean().withDefault(const Constant(false))();
  IntColumn get displayOrder => integer().withDefault(const Constant(0))();
  DateTimeColumn get addedAt => dateTime().withDefault(currentDateAndTime)();

  // New columns for per-group place settings
  RealColumn get radius => real().withDefault(const Constant(100.0))();
  TextColumn get description => text().nullable()();
  TextColumn get placeType => text().withDefault(const Constant('skatepark'))();

  @override
  Set<Column> get primaryKey => {groupId, placeId};
}

class GroupMembersTable extends Table {
  @override
  String get tableName => 'group_members';

  TextColumn get groupId => text().references(GroupsTable, #id)();
  TextColumn get userId => text()();
  TextColumn get role => text().withDefault(const Constant('member'))();
  DateTimeColumn get joinedAt => dateTime().withDefault(currentDateAndTime)();
  BoolColumn get shareLocation => boolean().withDefault(const Constant(true))();
  BoolColumn get notificationsEnabled =>
      boolean().withDefault(const Constant(true))();

  @override
  Set<Column> get primaryKey => {groupId, userId};
}

@DriftDatabase(
  tables: [
    PlacesTable,
    SettingsTable,
    BlockedFriendsTable,
    GroupsTable,
    GroupPlacesTable,
    GroupMembersTable,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 10;

  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      onCreate: (Migrator m) async {
        await m.createAll();
      },
      onUpgrade: (Migrator m, int from, int to) async {
        if (from < 2) {
          await m.createTable(settingsTable);
          await m.createTable(blockedFriendsTable);
        }
        if (from < 3) {
          await m.createTable(groupsTable);
          await m.createTable(groupPlacesTable);
          await m.createTable(groupMembersTable);
        }
        if (from < 4) {
          // Rename tables from default Drift naming (snake_case class name) to explicit names
          await m.issueCustomQuery('ALTER TABLE places_table RENAME TO places');
          await m.issueCustomQuery(
            'ALTER TABLE settings_table RENAME TO settings',
          );
          await m.issueCustomQuery(
            'ALTER TABLE blocked_friends_table RENAME TO blocked_friends',
          );
        }
        if (from < 5) {
          // Add missing columns to places table
          // We use addColumn which handles the column definition automatically
          await m.addColumn(placesTable, placesTable.createdBy);
          await m.addColumn(placesTable, placesTable.createdAt);
        }
        if (from < 6) {
          // Add new columns to group_places table
          await m.addColumn(groupPlacesTable, groupPlacesTable.radius);
          await m.addColumn(groupPlacesTable, groupPlacesTable.description);
          await m.addColumn(groupPlacesTable, groupPlacesTable.placeType);
        }
        if (from < 7) {
          // Add missing address column to places table
          await m.addColumn(placesTable, placesTable.address);
        }
        if (from < 8) {
          // Add missing updated_at column to places table
          await m.addColumn(placesTable, placesTable.updatedAt);
        }
        if (from < 9) {
          // Add missing sync_status column to places table
          await m.addColumn(placesTable, placesTable.syncStatus);
        }
        if (from < 10) {
          // Add notifications_enabled to group_members
          await m.addColumn(
            groupMembersTable,
            groupMembersTable.notificationsEnabled,
          );
        }
      },
    );
  }

  static QueryExecutor _openConnection() {
    return driftDatabase(name: 'wysx_db');
  }
}
