import 'dart:async';


import 'package:checkapp_plugin_example/shared/helper_functions/helper_functions.dart';
import 'package:checkapp_plugin_example/shared/widgets/grey_container.dart';
import 'package:checkapp_plugin_example/shared/widgets/hover_ink_well.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class TimingRow extends StatefulWidget {
  final Function() deleteRow;

  final String startTime;
  final String endTime;
  final Function(Map<String, dynamic>) editRow;
  const TimingRow({
    super.key,
    required this.deleteRow,
    required this.startTime,
    required this.endTime,
    required this.editRow,

  });

  @override
  State<TimingRow> createState() => _TimingRowState();
}

class _TimingRowState extends State<TimingRow> {

  late String _startTimeOfDay;

  late String _endTimeOfDay;
  @override
  void initState() {
    super.initState();
    _startTimeOfDay = widget.startTime;
    _endTimeOfDay = widget.endTime;
  }

  Future<void> _selectTime(
      {required bool isStartTime, required String initialTime}) async {
    TimeOfDay initialTimeOfDay =
        HelperFunctions.convertToTimeOfDay(initialTime);
    TimeOfDay? chosenTime =
        await showTimePicker(context: context, initialTime: initialTimeOfDay);
    if (isStartTime && chosenTime != null) {
      setState(() {
        _startTimeOfDay = HelperFunctions.convertToHHMM(chosenTime);
      });
      widget.editRow({'startTime': HelperFunctions.convertToHHMM(chosenTime)});
    } else if (!isStartTime && chosenTime != null) {
      setState(() {
        _endTimeOfDay = HelperFunctions.convertToHHMM(chosenTime);
      });
      widget.editRow({'endTime': HelperFunctions.convertToHHMM(chosenTime)});
    }
  }



  @override
  Widget build(BuildContext context) {

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
                child: Text(
                    HelperFunctions.convertToTimeOfDay(_startTimeOfDay)
                        .format(context),
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
                child: Text(
                    HelperFunctions.convertToTimeOfDay(_endTimeOfDay)
                        .format(context),
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
