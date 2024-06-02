import 'package:flutter/material.dart';

final List<Map<String, dynamic>> conditions = [
    {
      'text': 'Location',
      'description': 'Campus, home, work, etc.',
      'icon': const Icon(Icons.near_me,size: 24,),
      'route': 'create-location',
    },
    {
      'text': 'Time',
      'description': 'eg. Working hours, weekend',
      'icon': const Icon(Icons.schedule, size: 24),
      'route': 'create-time',
    },
    {
      'text': 'Wi-Fi',
      'description':
          'Block only when home!',
      'icon': const Icon(Icons.wifi, size: 24),
      'route': 'create-wifi',
    },
    {
      'text': 'Launch Count',
      'description': 'Max 20 times a day',
      'icon': const Icon(Icons.power_settings_new, size: 24),
      'route': 'create-launch-count',
    },
    {
      'text': 'Usage Limit',
      'description': '30 mins a day',
      'icon': const Icon(Icons.battery_alert, size: 24),
      'route': 'create-usage-limit',
    },
  ];