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
  ];

  for (var createStatement in createTables) {
    final Future<void> Function(Database) createTable =
        createStatement['create'] as Future<void> Function(Database);
    HelperFunctions.tryCatchWrapper(
      operation: () => createTable(db),
      errorMessage: "Unable to create table ${createStatement['tableName']}",
    );
  }
}

Future<void> createUsersTable(Database db) async {
  await db.execute(
    'CREATE TABLE users('
    'id TEXT PRIMARY KEY, '
    'name TEXT, '
    'email TEXT'
    ')',
  );
}

Future<void> createKeywordsTable(Database db) async {
  await db.execute(
    'CREATE TABLE keywords('
    'id INTEGER PRIMARY KEY AUTOINCREMENT, '
    'string TEXT'
    ')',
  );
}

Future<void> createAppsTable(Database db) async {
  await db.execute(
    'CREATE TABLE apps('
    'id INTEGER PRIMARY KEY AUTOINCREMENT, '
    'packageName TEXT, '
    'iconBase64String TEXT, '
    'appName TEXT'
    ')',
  );
}

Future<void> createWebsitesTable(Database db) async {
  await db.execute(
    'CREATE TABLE websites('
    'id INTEGER PRIMARY KEY AUTOINCREMENT, '
    'url TEXT, '
    'title TEXT, '
    'description TEXT, '
    'imageBase64String TEXT'
    ')',
  );
}

Future<void> createBlocksTable(Database db) async {
  await db.execute(
    'CREATE TABLE blocks('
    'id INTEGER PRIMARY KEY AUTOINCREMENT, '
    'keywordId INTEGER, '
    'websiteId INTEGER, '
    'appId INTEGER, '
    'FOREIGN KEY(keywordId) REFERENCES keywords(id) ON DELETE SET NULL, '
    'FOREIGN KEY(websiteId) REFERENCES websites(id) ON DELETE SET NULL, '
    'FOREIGN KEY(appId) REFERENCES apps(id) ON DELETE SET NULL'
    ')',
  );
}

Future<void> createLocationsTable(Database db) async {
  await db.execute(
    'CREATE TABLE locations('
    'id INTEGER PRIMARY KEY AUTOINCREMENT, '
    'latitude NUMERIC, '
    'longitude NUMERIC, '
    'location TEXT'
    ')',
  );
}

Future<void> createWifisTable(Database db) async {
  await db.execute(
    'CREATE TABLE wifis('
    'id INTEGER PRIMARY KEY AUTOINCREMENT, '
    'wifiName TEXT'
    ')',
  );
}

Future<void> createTimingsTable(Database db) async {
  await db.execute(
    'CREATE TABLE timings('
    'id INTEGER PRIMARY KEY AUTOINCREMENT, '
    'start TEXT, '
    'end TEXT'
    ')',
  );
}

Future<void> createDaysTable(Database db) async {
  await db.execute(
    'CREATE TABLE days('
    'id INTEGER PRIMARY KEY AUTOINCREMENT, '
    'day TEXT'
    ')',
  );
}

Future<void> createTimesTable(Database db) async {
  await db.execute(
    'CREATE TABLE times('
    'id INTEGER PRIMARY KEY AUTOINCREMENT, '
    'timingId INTEGER, '
    'dayId INTEGER, '
    'FOREIGN KEY(timingId) REFERENCES timings(id) ON DELETE SET NULL, '
    'FOREIGN KEY(dayId) REFERENCES days(id) ON DELETE SET NULL'
    ')',
  );
}

Future<void> createSchedulesTable(Database db) async {
  await db.execute(
    'CREATE TABLE schedules('
    'id INTEGER PRIMARY KEY AUTOINCREMENT, '
    'timeId INTEGER, '
    'locationId INTEGER, '
    'wifiId INTEGER, '
    'blockId INTEGER, '
    'userId TEXT, '
    'scheduleName TEXT, '
    'scheduleIcon TEXT, '
    'FOREIGN KEY(timeId) REFERENCES times(id) ON DELETE SET NULL, '
    'FOREIGN KEY(locationId) REFERENCES locations(id) ON DELETE SET NULL, '
    'FOREIGN KEY(wifiId) REFERENCES wifis(id) ON DELETE SET NULL, '
    'FOREIGN KEY(blockId) REFERENCES blocks(id) ON DELETE SET NULL, '
    'FOREIGN KEY(userId) REFERENCES users(id) ON DELETE SET NULL'
    ')',
  );
}
