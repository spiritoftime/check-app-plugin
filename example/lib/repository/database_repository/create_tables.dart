import 'package:checkapp_plugin_example/shared/helper_functions/helper_functions.dart';
import 'package:sqflite/sqflite.dart';

Future<void> createTables(Database db) async {
  final createTables = [
    {'create': createUsersTable, 'tableName': 'users'},
    {'create': createKeywordsTable, 'tableName': 'keywords'},
    {'create': createAppsTable, 'tableName': 'apps'},
    {'create': createWebsitesTable, 'tableName': 'websites'},
    {'create': createBlocksTable, 'tableName': 'blocks'},
    {'create': createLocationsTable, 'tableName': 'locations'},
    {'create': createWifisTable, 'tableName': 'wifis'},
    {'create': createTimingsTable, 'tableName': 'timings'},
    {'create': createDaysTable, 'tableName': 'days'},
    {'create': createTimesTable, 'tableName': 'times'},
    {'create': createSchedulesTable, 'tableName': 'schedules'},
    {'create': createPartialBlockersTable, 'tableName': 'partialblockers'},
  ];

  for (var createStatement in createTables) {
    final Future<void> Function(Database) createTable =
        createStatement['create'] as Future<void> Function(Database);
    await HelperFunctions.tryCatchWrapper(
      operation: () async => await createTable(db),
      errorMessage: "Unable to create table ${createStatement['tableName']}",
    );
  }
}

Future<void> createUsersTable(Database db) async {
  await db.execute(
    'CREATE TABLE users ('
    'id TEXT PRIMARY KEY'
    ')',
  );
}

Future<void> createKeywordsTable(Database db) async {
  await db.execute(
    'CREATE TABLE keywords('
    'id INTEGER PRIMARY KEY AUTOINCREMENT, '
    'keyword TEXT, '
    'blockId INTEGER, '
    'FOREIGN KEY(blockId) REFERENCES blocks(id) ON DELETE CASCADE'
    ')',
  );
}

Future<void> createAppsTable(Database db) async {
  await db.execute(
    'CREATE TABLE apps('
    'id INTEGER PRIMARY KEY AUTOINCREMENT, '
    'packageName TEXT, '
    'iconBase64String TEXT, '
    'appName TEXT, '
    'blockId INTEGER, '
    'FOREIGN KEY(blockId) REFERENCES blocks(id) ON DELETE CASCADE'
    ')',
  );
}

Future<void> createPartialBlockersTable(Database db) async {
  await db.execute(
    'CREATE TABLE partialblockers('
    'id INTEGER PRIMARY KEY AUTOINCREMENT, '
    'imagePath TEXT, '
    'packageName TEXT, '
    'feature TEXT, '
    'appName TEXT, '
    'blockId INTEGER, '
    'FOREIGN KEY(blockId) REFERENCES blocks(id) ON DELETE CASCADE'
    ')',
  );
}

Future<void> createWebsitesTable(Database db) async {
  await db.execute(
    'CREATE TABLE websites('
    'id INTEGER PRIMARY KEY AUTOINCREMENT, '
    'url TEXT, '
    'blockId INTEGER, '
    'FOREIGN KEY(blockId) REFERENCES blocks(id) ON DELETE CASCADE'
    ')',
  );
}

Future<void> createBlocksTable(Database db) async {
  await db.execute(
    'CREATE TABLE blocks('
    'id INTEGER PRIMARY KEY AUTOINCREMENT, '
    'scheduleId INTEGER, '
    'FOREIGN KEY(scheduleId) REFERENCES schedules(id) ON DELETE CASCADE'
    ')',
  );
}

Future<void> createLocationsTable(Database db) async {
  await db.execute(
    'CREATE TABLE locations('
    'id INTEGER PRIMARY KEY AUTOINCREMENT, '
    'latitude NUMERIC, '
    'longitude NUMERIC, '
    'location TEXT, '
    'scheduleId INTEGER, '
    'FOREIGN KEY(scheduleId) REFERENCES schedules(id) ON DELETE CASCADE'
    ')',
  );
}

Future<void> createWifisTable(Database db) async {
  await db.execute(
    'CREATE TABLE wifis('
    'id INTEGER PRIMARY KEY AUTOINCREMENT, '
    'wifiName TEXT, '
    'scheduleId INTEGER, '
    'FOREIGN KEY(scheduleId) REFERENCES schedules(id) ON DELETE CASCADE'
    ')',
  );
}

Future<void> createTimingsTable(Database db) async {
  await db.execute(
    'CREATE TABLE timings('
    'id INTEGER PRIMARY KEY AUTOINCREMENT, '
    'startTiming TEXT, '
    'endTiming TEXT, '
    'timeId INTEGER, '
    'FOREIGN KEY(timeId) REFERENCES times(id) ON DELETE CASCADE'
    ')',
  );
}

Future<void> createDaysTable(Database db) async {
  await db.execute(
    'CREATE TABLE days('
    'id INTEGER PRIMARY KEY AUTOINCREMENT, '
    'day TEXT, '
    'timeId INTEGER, '
    'FOREIGN KEY(timeId) REFERENCES times(id) ON DELETE CASCADE'
    ')',
  );
}

Future<void> createTimesTable(Database db) async {
  await db.execute(
    'CREATE TABLE times('
    'id INTEGER PRIMARY KEY AUTOINCREMENT, '
    'scheduleId INTEGER, '
    'FOREIGN KEY(scheduleId) REFERENCES schedules(id) ON DELETE CASCADE'
    ')',
  );
}

Future<void> createSchedulesTable(Database db) async {
  await db.execute(
    'CREATE TABLE schedules('
    'id INTEGER PRIMARY KEY AUTOINCREMENT, '
    'userId TEXT, '
    'scheduleName TEXT, '
    'scheduleIcon TEXT, '
    'isActive INTEGER DEFAULT 0, '
    'FOREIGN KEY(userId) REFERENCES users(id) ON DELETE CASCADE'
    ')',
  );
}
