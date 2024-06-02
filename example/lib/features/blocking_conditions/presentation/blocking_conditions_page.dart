import 'package:checkapp_plugin_example/features/blocking_conditions/presentation/utils.dart';
import 'package:checkapp_plugin_example/features/blocking_conditions/presentation/widgets/blocking_condition.dart';
import 'package:checkapp_plugin_example/features/create_block/cubit/cubit/block_cubit.dart';
import 'package:checkapp_plugin_example/features/create_time/cubit/cubit/time_cubit.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

class BlockingConditionsPage extends StatelessWidget {
  final Map<String, dynamic> extra;

  const BlockingConditionsPage({super.key, required this.extra});
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
                        extra: extra,
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
