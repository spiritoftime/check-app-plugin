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
    'successRoute': 'create-location',
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
    'onTap': (BuildContext context, extra) =>
        context.pushNamed('create-wifi', extra: extra),
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
