import 'package:checkapp_plugin/checkapp_plugin.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

CheckappPlugin _checkappPlugin = CheckappPlugin();

final List<Map<String, dynamic>> conditions = [
  {
    'text': 'Location',
    'description': 'Campus, home, work, etc.',
    'icon': const Icon(
      Icons.near_me,
      size: 24,
    ),
    'onTap': (BuildContext context, extra) async {
      bool isLocationEnabled = await _checkappPlugin.checkLocationPermission();
      if (!isLocationEnabled && context.mounted) {
        context.pushNamed('create-location-permission', extra: extra);
      } else if (context.mounted) {
        context.pushNamed('create-location', extra: extra);
      }
    },
  },
  {
    'text': 'Time',
    'description': 'eg. Working hours, weekend',
    'icon': const Icon(Icons.schedule, size: 24),
    'onTap': (BuildContext context, extra) =>
        context.pushNamed('create-time', extra: extra),
  },
  {
    'text': 'Wi-Fi',
    'description': 'Block only when home!',
    'icon': const Icon(Icons.wifi, size: 24),
    'onTap': (BuildContext context, extra) async {
      List<bool> wifiPermissionsEnabled = await Future.wait([
        _checkappPlugin.checkWifiPermission(),
        _checkappPlugin.checkAboveAPI33(),
        _checkappPlugin.checkLocationPermission()
      ]);
      final bool isWifiEnabled = wifiPermissionsEnabled[0];
      final bool isAboveAPI33 = wifiPermissionsEnabled[1];
      final bool isLocationEnabled = wifiPermissionsEnabled[2];
      print(wifiPermissionsEnabled);
      if (!context.mounted) return;
      if (isAboveAPI33) {
        // !isWifiEnabled not needed for our use case https://developer.android.com/develop/connectivity/wifi/wifi-permissions
        if ( !isLocationEnabled) {
          context.pushNamed('create-wifi-permission',
              extra: {'wifiPermissionsEnabled': wifiPermissionsEnabled});
          return;
        }
      }
      if (!isAboveAPI33) {
        if (!isLocationEnabled) {
          context.pushNamed('create-wifi-permission',
              extra: {'wifiPermissionsEnabled': wifiPermissionsEnabled});
          return;
        }
      }

      context.pushNamed('create-wifi', extra: extra);
    }
  },
  {
    'text': 'Launch Count',
    'description': 'Max 20 times a day',
    'icon': const Icon(Icons.power_settings_new, size: 24),
    'onTap': (BuildContext context, extra) =>
        context.pushNamed('create-launch-count', extra: extra),
  },
  {
    'text': 'Usage Limit',
    'description': '30 mins a day',
    'icon': const Icon(Icons.battery_alert, size: 24),
    'onTap': (BuildContext context, extra) =>
        context.pushNamed('create-usage-limit', extra: extra),
  },
];
