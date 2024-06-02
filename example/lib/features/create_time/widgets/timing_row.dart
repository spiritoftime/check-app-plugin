import 'dart:async';

import 'package:checkapp_plugin_example/features/create_time/cubit/cubit/time_cubit.dart';
import 'package:checkapp_plugin_example/features/create_time/models/time/time.dart';
import 'package:checkapp_plugin_example/features/create_time/models/timing/timing.dart';
import 'package:checkapp_plugin_example/shared/widgets/grey_container.dart';
import 'package:checkapp_plugin_example/shared/widgets/hover_ink_well.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';

class TimingRow extends StatefulWidget {
  final Function() deleteRow;
  final TimeCubit timeCubit;
  final CopyTimeCubit copyTimeCubit;
  const TimingRow({
    super.key,
    required this.deleteRow,
    required this.timeCubit,
    required this.copyTimeCubit,
  });

  @override
  State<TimingRow> createState() => _TimingRowState();
}

class _TimingRowState extends State<TimingRow> {
  late StreamSubscription<int> subscription;

  TimeOfDay _startTimeOfDay = TimeOfDay.now();
  TimeOfDay _endTimeOfDay = TimeOfDay.now();
  Future<void> _selectTime(
      {required bool isStartTime, required TimeOfDay initialTime}) async {
    TimeOfDay? chosenTime =
        await showTimePicker(context: context, initialTime: initialTime);
    if (isStartTime && chosenTime != null) {
      setState(() {
        _startTimeOfDay = chosenTime;
      });
    } else if (!isStartTime && chosenTime != null) {
      setState(() {
        _endTimeOfDay = chosenTime;
      });
    }
  }

  DateTime convertTimeOfDay(TimeOfDay timeOfDay) {
    return DateTime(timeOfDay.hour, timeOfDay.minute);
  }

  @override
  void dispose() async {
    super.dispose();
    await subscription.cancel();
  }

  @override
  Widget build(BuildContext context) {
    subscription =
        widget.copyTimeCubit.stream.listen((int call) async {
        widget.timeCubit.updateTime(
          timings: widget.timeCubit.state.timings +
              [
                Timing(
                    start: DateFormat('HH:mm')
                        .format(convertTimeOfDay(_startTimeOfDay)),
                    end: DateFormat('HH:mm')
                        .format(convertTimeOfDay(_endTimeOfDay)))
              ],
        );
        print(
            "${widget.timeCubit.state.timings.length} timings, timing_row updated");
      }
    );
    return Padding(
      padding: const EdgeInsets.only(top: 16.0),
      child: HoverInkWell(
        inkWellPadding: const EdgeInsets.all(0),
        child: GreyContainer(
          // height: 64,
          child: Row(
            children: [
              const Icon(Icons.schedule, color: Colors.blue, size: 30),
              const Gap(16),
              HoverInkWell(
                borderColor: const Color(0xff21222D),
                onTap: () async {
                  await _selectTime(
                      initialTime: _startTimeOfDay, isStartTime: true);
                },
                inkWellPadding:
                    const EdgeInsets.symmetric(vertical: 0, horizontal: 8),
                child: Text(_startTimeOfDay.format(context),
                    style: const TextStyle(fontSize: 16)),
              ),
              const Gap(8),
              const Text(":"),
              const Gap(8),
              HoverInkWell(
                onTap: () async {
                  await _selectTime(
                      initialTime: _endTimeOfDay, isStartTime: false);
                },
                borderColor: const Color(0xff21222D),
                inkWellPadding:
                    const EdgeInsets.symmetric(vertical: 0, horizontal: 8),
                child: Text(_endTimeOfDay.format(context),
                    style: const TextStyle(fontSize: 16)),
              ),
              const Spacer(),
              HoverInkWell(
                  borderColor: const Color(0xff21222D),
                  inkWellPadding: const EdgeInsets.all(0),
                  onTap: widget.deleteRow,
                  child: const Icon(Icons.close, color: Colors.blue, size: 30)),
            ],
          ),
        ),
      ),
    );
  }
}
