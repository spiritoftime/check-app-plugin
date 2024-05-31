import 'package:checkapp_plugin_example/features/create_time/widgets/day_row.dart';
import 'package:checkapp_plugin_example/features/create_time/widgets/all_day_timing_row.dart';
import 'package:checkapp_plugin_example/features/create_time/widgets/timing_row.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

class TimeLimit extends StatelessWidget {
  const TimeLimit({super.key});

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
                style: const ButtonStyle(
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                onPressed: () => context.pop(),
                icon:
                    const Icon(Icons.arrow_back, color: Colors.blue, size: 24),
              ),
              const Gap(16),
              const Text(
                "Active Time",
                style: TextStyle(
                    color: Colors.blue,
                    fontWeight: FontWeight.bold,
                    fontSize: 32.0),
              ),
              const Gap(12),
              const Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      DayRow(),
                      Gap(32),
                      const Text(
                        "Times",
                        style: TextStyle(color: Colors.grey, fontSize: 16.0),
                      ),
                      Gap(16),
                      AllDayTimingRow(),
                      Padding(
                        padding: EdgeInsets.only(top:16.0),
                        child: TimingRow(),
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
