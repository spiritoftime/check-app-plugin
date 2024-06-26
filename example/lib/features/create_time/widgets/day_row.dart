import 'package:checkapp_plugin_example/features/create_time/cubit/cubit/time_cubit.dart';
import 'package:checkapp_plugin_example/features/create_time/models/day/day.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class DayRow extends StatefulWidget {
  final TimeCubit timeCubit;
  const DayRow({super.key, required this.timeCubit});
  @override
  State<DayRow> createState() => _DayRowState();
}

class _DayRowState extends State<DayRow> {
  late List<String> selectedDays;
  @override
  void initState() {
    super.initState();

    selectedDays =
        widget.timeCubit.state.days.map((d) => daysMap[d.day]!).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            const Text(
              "Days",
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const Gap(16),
            Expanded(
              child: Wrap(
                alignment: WrapAlignment.end,
                children: [
                  Text(
                    "${selectedDays.isNotEmpty ? "Every" : ''} ${selectedDays.join(", ")}",
                    style: const TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                ],
              ),
            ),
          ],
        ),
        const Gap(12),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: daysMap.values
              .map((String day) => GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedDays.contains(day)
                            ? selectedDays.length == 1
                                ? null
                                : selectedDays.remove(day)
                            : selectedDays.add(day);
                      });
                      widget.timeCubit.updateTime(
                        days: selectedDays.map((d) => Day(day: d)).toList(),
                      );
                    },
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: selectedDays.contains(day)
                            ? Colors.blue
                            : const Color(0xff21222D),
                      ),
                      child: Center(
                        child: Text(
                          day.substring(0, 2),
                          style: TextStyle(
                            color: selectedDays.contains(day)
                                ? Colors.white
                                : Colors.grey,
                          ),
                        ),
                      ),
                    ),
                  ))
              .toList(),
        ),
      ],
    );
  }
}
