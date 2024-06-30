import 'package:checkapp_plugin_example/features/create_time/cubit/cubit/time_cubit.dart';
import 'package:checkapp_plugin_example/features/create_time/models/timing/timing.dart';
import 'package:checkapp_plugin_example/features/create_time/widgets/day_row.dart';
import 'package:checkapp_plugin_example/features/create_time/widgets/all_day_timing_row.dart';
import 'package:checkapp_plugin_example/features/create_time/widgets/timing_row.dart';
import 'package:checkapp_plugin_example/router/route_names.dart';
import 'package:checkapp_plugin_example/shared/helper_functions/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

class TimeLimitPage extends StatefulWidget {
  final Map<String, dynamic> extra;

  const TimeLimitPage({super.key, required this.extra});

  @override
  State<TimeLimitPage> createState() => _TimeLimitPageState();
}

class _TimeLimitPageState extends State<TimeLimitPage> {
  late bool _allDayEnabled;
  late final TimeCubit timeCubit;
  final Map<String, dynamic> timings = {};
  @override
  void initState() {
    super.initState();
    timeCubit = widget.extra['timeCubit'] ?? TimeCubit();
    for (Timing timing in timeCubit.state.timings) {
      String uniqueKey = UniqueKey().toString();
      timings.putIfAbsent(
          uniqueKey,
          () => {
                'deleteRow': () {
                  _deleteTiming(uniqueKey);
                },
                'startTime': timing.startTiming,
                'endTime': timing.endTiming,
                'editRow': (Map<String, dynamic> newTimings) {
                  _editTiming(uniqueKey, newTimings);
                },
              });
    }
    _allDayEnabled = timings.values
        .any((e) => e['startTime'] == '00:00' && e['endTime'] == '23:59');
  }

  void _addTiming() {
    String uniqueKey = UniqueKey().toString();
    if (timings.values
        .any((e) => e['startTime'] == '00:00' && e['endTime'] == '23:59')) {
      timings.clear();
    }
    setState(() {
      _allDayEnabled = false;
      timings.putIfAbsent(
          uniqueKey,
          () => {
                'deleteRow': () {
                  _deleteTiming(uniqueKey);
                },
                'key': uniqueKey,
                'startTime': HelperFunctions.currentTime(),
                'endTime': HelperFunctions.currentTime(),
                'editRow': (Map<String, dynamic> newTimings) {
                  _editTiming(uniqueKey, newTimings);
                },
              });
    });
  }

  void _add24hTiming() {
    String uniqueKey = UniqueKey().toString();

    timings.clear();

    setState(() {
      _allDayEnabled = true;
      timings.putIfAbsent(
          uniqueKey,
          () => {
                'deleteRow': () {
                  _deleteTiming(uniqueKey);
                },
                'key': uniqueKey,
                'startTime': '00:00',
                'endTime': '23:59',
                'editRow': (Map<String, dynamic> newTimings) {
                  _editTiming(uniqueKey, newTimings);
                },
              });
    });
  }

  void _editTiming(String id, Map<String, dynamic> newTimings) {
    setState(() {
      timings[id] = {...timings[id], ...newTimings};
    });
  }

  void _deleteTiming(String id) {
    setState(() {
      timings.remove(id);
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
                        isEnabled: _allDayEnabled,

                        add24hTiming: _add24hTiming,
                        addTiming: _addTiming,
                      ),
                      ListView.builder(
                          shrinkWrap: true,
                          itemCount: timings.length,
                          itemBuilder: (BuildContext context, int index) {
                            String key = timings.keys.elementAt(index);
                            if (timings[key]['startTime'] != '00:00' &&
                                timings[key]['endTime'] != '23:59') {
                              return TimingRow(
                                key: ValueKey(key),
                                deleteRow: timings[key]['deleteRow'],
                                editRow: timings[key]['editRow'],
                                startTime: timings[key]['startTime'],
                                endTime: timings[key]['endTime'],
                              );
                            }
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
                  List<Timing> finalTimings = [];
                  for (String k in timings.keys) {
                    finalTimings.add(Timing(
                        startTiming: timings[k]['startTime'],
                        endTiming: timings[k]['endTime']));
                  }
                  timeCubit.updateTime(timings: finalTimings);

                  context.goNamed(RouteNames.confirmSchedule,
                      extra: {...widget.extra, 'timeCubit': timeCubit});
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
