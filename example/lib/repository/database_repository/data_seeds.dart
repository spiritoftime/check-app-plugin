import 'package:checkapp_plugin_example/shared/helper_functions/helper_functions.dart';
import 'package:sqflite/sqflite.dart';

Future<void> insertMockData(Database db) async {
  final mockInserts = [
    () => db.insert('users',
        {'id': 'user1', 'name': 'John Doe', 'email': 'john.doe@example.com'}),
    () => db.insert('users', {
          'id': 'user2',
          'name': 'Jane Smith',
          'email': 'jane.smith@example.com'
        }),
    () => db.insert('keywords', {'string': 'keyword1'}),
    () => db.insert('keywords', {'string': 'keyword2'}),
    () => db.insert('apps', {
          'packageName': 'com.example.app1',
          'iconBase64String': 'icon1base64',
          'appName': 'App 1'
        }),
    () => db.insert('apps', {
          'packageName': 'com.example.app2',
          'iconBase64String': 'icon2base64',
          'appName': 'App 2'
        }),
    () => db.insert('websites', {
          'url': 'https://example.com',
          'title': 'Example',
          'description': 'Example Website',
          'imageBase64String': 'image1base64'
        }),
    () => db.insert('websites', {
          'url': 'https://example.org',
          'title': 'Example Org',
          'description': 'Example Organization',
          'imageBase64String': 'image2base64'
        }),
    () => db.insert('blocks', {'keywordId': 1, 'websiteId': 1, 'appId': 1}),
    () => db.insert('blocks', {'keywordId': 2, 'websiteId': 2, 'appId': 2}),
    () => db.insert('locations', {
          'latitude': 37.7749,
          'longitude': -122.4194,
          'location': 'San Francisco'
        }),
    () => db.insert('locations', {
          'latitude': 34.0522,
          'longitude': -118.2437,
          'location': 'Los Angeles'
        }),
    () => db.insert('wifis', {'wifiName': 'HomeWifi'}),
    () => db.insert('wifis', {'wifiName': 'OfficeWifi'}),
    () => db.insert('timings', {'start': '09:00', 'end': '17:00'}),
    () => db.insert('timings', {'start': '10:00', 'end': '18:00'}),
    () => db.insert('days', {'day': 'Monday'}),
    () => db.insert('days', {'day': 'Tuesday'}),
    () => db.insert('times', {'timingId': 1, 'dayId': 1}),
    () => db.insert('times', {'timingId': 2, 'dayId': 2}),
    () => db.insert('schedules', {
          'timeId': 1,
          'locationId': 1,
          'wifiId': 1,
          'blockId': 1,
          'userId': 'user1',
          'scheduleName': 'Morning Routine',
          'scheduleIcon': 'iconBase64'
        }),
    () => db.insert('schedules', {
          'timeId': 2,
          'locationId': 2,
          'wifiId': 2,
          'blockId': 2,
          'userId': 'user2',
          'scheduleName': 'Work Routine',
          'scheduleIcon': 'iconBase64'
        }),
  ];
  for (var insert in mockInserts) {
     HelperFunctions.tryCatchWrapper(
      operation: insert,
      errorMessage: 'Unable to insert mock data',
    );
  }
}
