import 'package:checkapp_plugin_example/features/blocking_conditions/presentation/widgets/blocking_condition.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

class BlockingConditionsPage extends StatelessWidget {
  BlockingConditionsPage({super.key});
  final List<Map<String, dynamic>> conditions = [
    {
      'text': 'Location',
      'description': 'Campus, home, work, etc.',
      'icon': const Icon(Icons.near_me,size: 24,),
      'route': '/create-schedule-location',
    },
    {
      'text': 'Time',
      'description': 'eg. Working hours, weekend',
      'icon': const Icon(Icons.schedule, size: 24),
      'route': '/create-schedule-time',
    },
    {
      'text': 'Wi-Fi',
      'description':
          'Block only when home!',
      'icon': const Icon(Icons.wifi, size: 24),
      'route': '/create-schedule-wifi',
    },
    {
      'text': 'Launch Count',
      'description': 'Max 20 times a day',
      'icon': const Icon(Icons.power_settings_new, size: 24),
      'route': '/create-schedule-launch-count',
    },
    {
      'text': 'Usage Limit',
      'description': '30 mins a day',
      'icon': const Icon(Icons.battery_alert, size: 24),
      'route': '/create-schedule-usage-limit',
    },
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              IconButton(
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                icon: const Icon(Icons.close, size: 32, color: Colors.blue),
                onPressed: () {
                  context.pop();
                },
              ),
              const Gap(16),
              const Padding(
                padding: EdgeInsets.only(left: 12.0),
                child: Text(
                  'Blocking Conditions',
                  style: TextStyle(
                      fontSize: 24,
                      color: Colors.blue,
                      fontWeight: FontWeight.bold),
                ),
              ),
              const Gap(12),
              const Padding(
                padding: EdgeInsets.only(left: 12.0),
                child: Text(
                  'Select when or where you don\'t want to be disturbed',
                  style: TextStyle(color: Colors.grey, fontSize: 16.0),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemBuilder: (context, index) {
                    return BlockingCondition(
                        text: conditions[index]['text'],
                        description: conditions[index]['description'],
                        icon: conditions[index]['icon'],
                        route: conditions[index]['route']);
                  },
                  itemCount: conditions.length,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
