import 'dart:async';

import 'package:checkapp_plugin_example/features/create_time/cubit/cubit/time_cubit.dart';
import 'package:checkapp_plugin_example/features/create_time/models/timing/timing.dart';
import 'package:checkapp_plugin_example/shared/widgets/grey_container.dart';
import 'package:checkapp_plugin_example/shared/widgets/hover_ink_well.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';

class AllDayTimingRow extends StatefulWidget {
  final TimeCubit timeCubit;
  final CopyTimeCubit copyTimeCubit;
  final Function clearTimings;
  final Function addTiming;
  const AllDayTimingRow(
      {super.key,
      required this.clearTimings,
      required this.addTiming,
      required this.timeCubit,
      required this.copyTimeCubit});

  @override
  State<AllDayTimingRow> createState() => _AllDayTimingRowState();
}

class _AllDayTimingRowState extends State<AllDayTimingRow> {
  late StreamSubscription<int> subscription;
  late bool _isEnabled;
  @override
  void initState() {
    super.initState();

    _isEnabled = widget.timeCubit.state.timings
        .contains(const Timing(start: '00:00', end: '23:59'));
  }

  @override
  void dispose() async {
    super.dispose();
    await subscription.cancel();
  }

  @override
  Widget build(BuildContext context) {
    subscription = widget.copyTimeCubit.stream.listen((int call) async {
      if (_isEnabled) {
        widget.timeCubit
            .updateTime(timings: [Timing(start: '00:00', end: '23:59')]);
        print('updated all day timing ${widget.timeCubit.state.timings}');
      }
    });
    return HoverInkWell(
      onTap: () {
        bool newState = !_isEnabled;
        setState(() {
          _isEnabled = newState;
        });
        if (newState) {
          widget.clearTimings();
        } else {
          widget.addTiming();
        }
      },
      inkWellPadding: const EdgeInsets.all(0),
      child: GreyContainer(
        child: Row(
          children: [
            Icon(Icons.schedule,
                color: _isEnabled ? Colors.blue : Colors.grey, size: 30),
            const Gap(16),
            const Text(
              "All day long",
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
            const Spacer(),
            SizedBox(
              height: 30,
              child: FittedBox(
                fit: BoxFit.fill,
                child: Switch(
                    thumbColor: WidgetStateProperty.all(Colors.white),
                    activeColor: Colors.blue,
                    inactiveTrackColor: Colors.grey,
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    value: _isEnabled,
                    trackOutlineWidth: WidgetStateProperty.all(0),
                    onChanged: (bool isEnabled) {
                      setState(() {
                        _isEnabled = isEnabled;
                      });
                      if (isEnabled) {
                        widget.clearTimings();
                      } else {
                        widget.addTiming();
                      }
                    }),
              ),
            ),
          ],
        ),
      ),
    );
  }
}