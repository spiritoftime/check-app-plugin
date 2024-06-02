import 'package:checkapp_plugin_example/features/create_time/cubit/cubit/time_cubit.dart';
import 'package:checkapp_plugin_example/features/create_time/models/timing/timing.dart';
import 'package:checkapp_plugin_example/features/create_time/widgets/day_row.dart';
import 'package:checkapp_plugin_example/features/create_time/widgets/all_day_timing_row.dart';
import 'package:checkapp_plugin_example/features/create_time/widgets/timing_row.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

class TimeLimitPage extends StatefulWidget {
  const TimeLimitPage({super.key});

  @override
  State<TimeLimitPage> createState() => _TimeLimitPageState();
}


class _TimeLimitPageState extends State<TimeLimitPage> {
  final CopyTimeCubit copyTimeCubit = CopyTimeCubit();
  final TimeCubit timeCubit = TimeCubit();
  final Map<String, TimingRow> timings = {};
  void _addTiming() {
    setState(() {
      String uniqueKey = UniqueKey().toString();
      timings.putIfAbsent(
          uniqueKey,
          () => TimingRow(
                key: ValueKey(uniqueKey),
                deleteRow: () {
                  _deleteTiming(uniqueKey);
                },
                timeCubit: timeCubit,
                copyTimeCubit: copyTimeCubit,
              ));
    });
  }

  void _deleteTiming(String id) {
    setState(() {
      timings.remove(id);
    });
  }

  void _clearTimings() {
    setState(() {
      timings.clear();
    });
  }

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
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      DayRow(
                        timeCubit: timeCubit,
                      ),
                      const Gap(32),
                      const Text(
                        "Times",
                        style: TextStyle(color: Colors.grey, fontSize: 16.0),
                      ),
                      const Gap(16),
                      AllDayTimingRow(
                        clearTimings: _clearTimings,
                        addTiming: _addTiming,
                        timeCubit: timeCubit,
                        copyTimeCubit: copyTimeCubit,
                      ),
                      ListView.builder(
                          shrinkWrap: true,
                          itemCount: timings.length,
                          itemBuilder: (BuildContext context, int index) {
                            String key = timings.keys.elementAt(index);
                            return timings[key]!;
                          }),
                      const Gap(16),
                      ElevatedButton.icon(
                        onPressed: _addTiming,
                        icon: const Icon(Icons.add, color: Colors.white),
                        label: const Text(
                          "Add",
                          style: TextStyle(color: Colors.white),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              MaterialButton(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                minWidth: double.infinity,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                  side: const BorderSide(color: Colors.black),
                ),
                onPressed: () {
                  //  clear timings in cubit first before regrabbing all the new timings to prevent duplicates
                  timeCubit.updateTime(timings: []);
                  copyTimeCubit.copyTime();
                  // issue: unable to determine when the stream listeners finish copytime
                  print("timings at time limit page:${timeCubit.state.timings.toString()}");
                  print("days:${timeCubit.state.days.toString()}");
                },
                color: Colors.blue,
                child: const Text(
                  "Save",
                  style: TextStyle(fontSize: 24),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
