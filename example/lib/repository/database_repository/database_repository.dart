import 'package:checkapp_plugin_example/features/create_block/models/app/app.dart';
import 'package:checkapp_plugin_example/features/create_block/models/block/block.dart';
import 'package:checkapp_plugin_example/features/create_block/models/keyword/keyword.dart';
import 'package:checkapp_plugin_example/features/create_block/models/website/website.dart';
import 'package:checkapp_plugin_example/features/create_location/models/location/location.dart';
import 'package:checkapp_plugin_example/features/create_schedule/models/schedule/schedule.dart';
import 'package:checkapp_plugin_example/features/create_schedule/models/schedule_details/schedule_details.dart';
import 'package:checkapp_plugin_example/features/create_time/models/day/day.dart';
import 'package:checkapp_plugin_example/features/create_time/models/time/time.dart';
import 'package:checkapp_plugin_example/features/create_time/models/timing/timing.dart';
import 'package:checkapp_plugin_example/features/create_wifi/models/wifi.dart';
import 'package:checkapp_plugin_example/repository/auth_repository/authentication_repository.dart';
import 'package:checkapp_plugin_example/repository/database_repository/create_tables.dart';
import 'package:checkapp_plugin_example/shared/helper_functions/helper_functions.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseRepository {
  // Singleton pattern
  static final DatabaseRepository _databaseRepository =
      DatabaseRepository._internal();
  factory DatabaseRepository() => _databaseRepository;
  DatabaseRepository._internal();

  static Database? _database;
  Future<Database> get database async {
    if (_database != null) return _database!;
    // Initialize the DB first time it is accessed
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final databasePath = await getDatabasesPath();

    // Set the path to the database. Note: Using the `join` function from the
    // `path` package is best practice to ensure the path is correctly
    // constructed for each platform.
    final path = join(databasePath, 'doomscroll.db');

    // Set the version. This executes the onCreate function and provides a
    // path to perform database upgrades and downgrades.
    return await openDatabase(
      path,
      onCreate: _onCreate,
      version: 1,
      onConfigure: (db) async => await db.execute('PRAGMA foreign_keys = ON'),
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await createTables(db);
  }

  Future<void> insertSchedule(Schedule schedule) async {
    final db = await _databaseRepository.database;
    String? userId = await AuthenticationRepository().userId;
    if (userId != null) {
      HelperFunctions.tryCatchWrapper(
          operation: () async => await db.transaction((txn) async {
                await txn.insert('users', {'id': userId},
                    conflictAlgorithm: ConflictAlgorithm.replace);
                final int schedulePk = await txn.insert('schedules', {
                  'userId': userId,
                  'scheduleIcon': schedule.scheduleDetails.iconName,
                  'scheduleName': schedule.scheduleDetails.scheduleName,
                  'isActive': schedule.scheduleDetails.isActive ? 1 : 0,
                });
                final int timePk =
                    await txn.insert('times', {'scheduleId': schedulePk});

                final int blockPk =
                    await txn.insert('blocks', {'scheduleId': schedulePk});
                Batch batch = txn.batch();
                // ---------------------- insert components of block --------------------
                for (App app in schedule.block.apps) {
                  batch.insert('apps', {...app.toJson(), 'blockId': blockPk},
                      conflictAlgorithm: ConflictAlgorithm.replace);
                }

                for (Website web in schedule.block.websites) {
                  batch.insert(
                      'websites', {...web.toJson(), 'blockId': blockPk},
                      conflictAlgorithm: ConflictAlgorithm.replace);
                }
                for (Keyword keyword in schedule.block.keywords) {
                  batch.insert(
                      'keywords', {...keyword.toJson(), 'blockId': blockPk},
                      conflictAlgorithm: ConflictAlgorithm.replace);
                }
                // ---------------------- insert components of location --------------------
                for (Location location in schedule.location) {
                  batch.insert('locations',
                      {...location.toJson(), 'scheduleId': schedulePk},
                      conflictAlgorithm: ConflictAlgorithm.replace);
                }
                // ---------------------- insert components of time --------------------

                for (Timing timing in schedule.time.timings) {
                  batch.insert(
                      'timings', {...timing.toJson(), 'timeId': timePk},
                      conflictAlgorithm: ConflictAlgorithm.replace);
                }
                for (Day day in schedule.time.days) {
                  batch.insert('days', {...day.toJson(), 'timeId': timePk},
                      conflictAlgorithm: ConflictAlgorithm.replace);
                }
                // ---------------------- insert components of wifi --------------------

                for (Wifi wifi in schedule.wifi) {
                  batch.insert(
                      'wifis', {...wifi.toJson(), 'scheduleId': schedulePk},
                      conflictAlgorithm: ConflictAlgorithm.replace);
                }
                return await batch.commit(noResult: true);
              }),
          errorMessage: "Unable to create new schedule");
    }
  }

  Future<List<Schedule>> schedules() async {
    final db = await _databaseRepository.database;
    String? userId = await AuthenticationRepository().userId;
    List<Schedule> scheduleList = [];
    if (userId != null) {

        List<Map<String, dynamic>> schedules = await db
            .query('schedules', where: 'userId = ?', whereArgs: [userId]);

      for (final s in schedules) {
        int scheduleId = s['id'];

        List<Map<String, dynamic>> locations = await db.query('locations',
            where: 'scheduleId = ?', whereArgs: [scheduleId]);
        List<Location> locationList =
            locations.map((l) => Location.fromJson(l)).toList();
        List<Map<String, dynamic>> wifis = await db
            .query('wifis', where: 'scheduleId = ?', whereArgs: [scheduleId]);
        List<Wifi> wifiList = wifis.map((w) => Wifi.fromJson(w)).toList();

        List<Map<String, dynamic>> blockQuery = await db
            .query('blocks', where: 'scheduleId = ?', whereArgs: [scheduleId]);

        List<Map<String, dynamic>> apps = await db.query('apps',
            where: 'blockId = ?', whereArgs: [blockQuery[0]['id']]);
        List<App> appList = apps.map((a) => App.fromJson(a)).toList();
        List<Map<String, dynamic>> websites = await db.query('websites',
            where: 'blockId = ?', whereArgs: [blockQuery[0]['id']]);
        List<Website> websiteList =
            websites.map((w) => Website.fromJson(w)).toList();
        List<Map<String, dynamic>> keywords = await db.query('keywords',
            where: 'blockId = ?', whereArgs: [blockQuery[0]['id']]);
        List<Keyword> keywordList =
            keywords.map((k) => Keyword.fromJson(k)).toList();
        Block block = Block(
          id: blockQuery[0]['id'],
          apps: appList,
          websites: websiteList,
          keywords: keywordList,
        );

        List<Map<String, dynamic>> timeQuery = await db
            .query('times', where: 'scheduleId = ?', whereArgs: [scheduleId]);
        List<Map<String, dynamic>> timings = await db.query('timings',
            where: 'timeId = ?', whereArgs: [timeQuery[0]['id']]);
        List<Timing> timingList =
            timings.map((t) => Timing.fromJson(t)).toList();
        List<Map<String, dynamic>> days = await db.query('days',
            where: 'timeId = ?', whereArgs: [timeQuery[0]['id']]);
        List<Day> dayList = days.map((d) => Day.fromJson(d)).toList();
        Time time = Time(
          id: timeQuery[0]['id'],
          timings: timingList,
          days: dayList,
        );

        Schedule schedule = Schedule(
          userId: userId,
          id: s['id'],
          block: block,
          time: time,
          location: locationList,
          wifi: wifiList,
          scheduleDetails: ScheduleDetails(
            isActive: s['isActive'] == 1 ? true : false,
            scheduleName: s['scheduleName'],
            iconName: s['scheduleIcon'],
          ),
        );
        scheduleList.add(schedule);
      }
    }
    return scheduleList;
  }

  Future<void> updateSchedule({required Schedule s}) async {
    final db = await _databaseRepository.database;
    HelperFunctions.tryCatchWrapper(
        operation: () async => await db.transaction((txn) async {
              Batch batch = txn.batch();
              batch.update(
                  'schedules',
                  {
                    'scheduleIcon': s.scheduleDetails.iconName,
                    'scheduleName': s.scheduleDetails.scheduleName,
                    'isActive': s.scheduleDetails.isActive ? 1 : 0,
                  },
                  where: 'id = ?',
                  whereArgs: [s.id]);
              // ---------------------- update components of block --------------------
              // delete and reinsert as i dont know what was updated, if just update then if a component was removed it will still be in the db
              batch.delete('apps',
                  where: 'blockId = ?', whereArgs: [s.block.id]);
              for (App app in s.block.apps) {
                batch.insert('apps', {...app.toJson(), 'blockId': s.block.id},
                    conflictAlgorithm: ConflictAlgorithm.replace);
              }
              batch.delete('websites',
                  where: 'blockId = ?', whereArgs: [s.block.id]);
              for (Website web in s.block.websites) {
                batch.insert(
                    'websites', {...web.toJson(), 'blockId': s.block.id},
                    conflictAlgorithm: ConflictAlgorithm.replace);
              }
              batch.delete('keywords',
                  where: 'blockId = ?', whereArgs: [s.block.id]);
              for (Keyword keyword in s.block.keywords) {
                batch.insert(
                    'apps', {...keyword.toJson(), 'blockId': s.block.id},
                    conflictAlgorithm: ConflictAlgorithm.replace);
              }
              // ---------------------- update components of location --------------------
              batch.delete('locations',
                  where: 'scheduleId = ?', whereArgs: [s.id]);
              for (Location location in s.location) {
                batch.insert(
                    'locations', {...location.toJson(), 'scheduleId': s.id},
                    conflictAlgorithm: ConflictAlgorithm.replace);
              }
              // ---------------------- update components of time --------------------
              //  i didnt remove time as time is a required field
              batch.delete('timings',
                  where: 'timeId = ?', whereArgs: [s.time.id]);
              for (Timing timing in s.time.timings) {
                batch.insert(
                    'timings', {...timing.toJson(), 'timeId': s.time.id},
                    conflictAlgorithm: ConflictAlgorithm.replace);
              }
              batch.delete('days', where: 'timeId = ?', whereArgs: [s.time.id]);
              for (Day day in s.time.days) {
                batch.insert('days', {...day.toJson(), 'timeId': s.time.id},
                    conflictAlgorithm: ConflictAlgorithm.replace);
              }
              // ---------------------- update components of wifi --------------------
              batch.delete('wifis', where: 'scheduleId = ?', whereArgs: [s.id]);
              for (Wifi wifi in s.wifi) {
                batch.insert('wifis', {...wifi.toJson(), 'scheduleId': s.id},
                    conflictAlgorithm: ConflictAlgorithm.replace);
              }
              return await batch.commit(noResult: true, continueOnError: true);
            }),
        errorMessage: "Unable to update schedule");
    // await db.update(tableName, data, where: 'id = ?', whereArgs: [model.id]);
  }
  // // A method that deletes a breed data from the breeds table.
  // Future<void> deleteBreed(int id) async {
  //   // Get a reference to the database.
  //   final db = await _databaseRepository.database;

  //   // Remove the Breed from the database.
  //   await db.delete(
  //     'breeds',
  //     // Use a `where` clause to delete a specific breed.
  //     where: 'id = ?',
  //     // Pass the Breed's id as a whereArg to prevent SQL injection.
  //     whereArgs: [id],
  //   );
  // }
  // A method that deletes a breed data from the breeds table.
  Future<void> deleteSchedule({required int scheduleId}) async {
    // Get a reference to the database.
    final db = await _databaseRepository.database;

    // Remove the Breed from the database.
    await db.delete(
      'schedules',
      // Use a `where` clause to delete a specific breed.
      where: 'id = ?',
      // Pass the Breed's id as a whereArg to prevent SQL injection.
      whereArgs: [scheduleId],
    );
  }
  // // A method that updates a breed data from the breeds table.
  // Future<void> updateBreed(Breed breed) async {
  //   // Get a reference to the database.
  //   final db = await _databaseRepository.database;

  //   // Update the given breed
  //   await db.update(
  //     'breeds',
  //     breed.toMap(),
  //     // Ensure that the Breed has a matching id.
  //     where: 'id = ?',
  //     // Pass the Breed's id as a whereArg to prevent SQL injection.
  //     whereArgs: [breed.id],
  //   );
  // }
  // // Define a function that inserts breeds into the database
  // Future<void> insertBreed(Breed breed) async {
  //   // Get a reference to the database.
  //   final db = await _databaseRepository.database;

  //   // Insert the Breed into the correct table. You might also specify the
  //   // `conflictAlgorithm` to use in case the same breed is inserted twice.
  //   //
  //   // In this case, replace any previous data.
  //   await db.insert(
  //     'breeds',
  //     breed.toMap(),
  //     conflictAlgorithm: ConflictAlgorithm.replace,
  //   );
  // }

  // Future<void> insertDog(Dog dog) async {
  //   final db = await _databaseRepository.database;
  //   await db.insert(
  //     'dogs',
  //     dog.toMap(),
  //     conflictAlgorithm: ConflictAlgorithm.replace,
  //   );
  // }

  // // A method that retrieves all the breeds from the breeds table.
  // Future<List<Breed>> breeds() async {
  //   // Get a reference to the database.
  //   final db = await _databaseRepository.database;

  //   // Query the table for all the Breeds.
  //   final List<Map<String, dynamic>> maps = await db.query('breeds');

  //   // Convert the List<Map<String, dynamic> into a List<Breed>.
  //   return List.generate(maps.length, (index) => Breed.fromMap(maps[index]));
  // }

  // Future<Breed> breed(int id) async {
  //   final db = await _databaseRepository.database;
  //   final List<Map<String, dynamic>> maps =
  //       await db.query('breeds', where: 'id = ?', whereArgs: [id]);
  //   return Breed.fromMap(maps[0]);
  // }

  // Future<List<Dog>> dogs() async {
  //   final db = await _databaseRepository.database;
  //   final List<Map<String, dynamic>> maps = await db.query('dogs');
  //   return List.generate(maps.length, (index) => Dog.fromMap(maps[index]));
  // }

  // Future<void> updateDog(Dog dog) async {
  //   final db = await _databaseRepository.database;
  //   await db.update('dogs', dog.toMap(), where: 'id = ?', whereArgs: [dog.id]);
  // }

  // // A method that deletes a breed data from the breeds table.
  // Future<void> deleteBreed(int id) async {
  //   // Get a reference to the database.
  //   final db = await _databaseRepository.database;

  //   // Remove the Breed from the database.
  //   await db.delete(
  //     'breeds',
  //     // Use a `where` clause to delete a specific breed.
  //     where: 'id = ?',
  //     // Pass the Breed's id as a whereArg to prevent SQL injection.
  //     whereArgs: [id],
  //   );
  // }

  // Future<void> deleteDog(int id) async {
  //   final db = await _databaseRepository.database;
  //   await db.delete('dogs', where: 'id = ?', whereArgs: [id]);
  // }
}
