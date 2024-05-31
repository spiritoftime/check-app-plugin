import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class DayRow extends StatefulWidget {
  const DayRow({super.key});
  @override
  State<DayRow> createState() => _DayRowState();
}

enum Days { monday, tuesday, wednesday, thursday, friday, saturday, sunday }

extension DaysExtension on Days {
  String get name {
    switch (this) {
      case Days.monday:
        return 'Monday';
      case Days.tuesday:
        return 'Tuesday';
      case Days.wednesday:
        return 'Wednesday';
      case Days.thursday:
        return 'Thursday';
      case Days.friday:
        return 'Friday';
      case Days.saturday:
        return 'Saturday';
      case Days.sunday:
        return 'Sunday';
    }
  }
}

class _DayRowState extends State<DayRow> {
  Days selectedDay = Days.friday;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Row(
            children: [
              const Text(
                "Days",
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
              const Spacer(),
              Text(
                "Every ${selectedDay.name}",
                style: const TextStyle(fontSize: 16, color: Colors.grey),
              ),
            ],
          ),
          const Gap(12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: Days.values
                .map((day) => GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedDay = day;
                        });
                      },
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: selectedDay == day
                              ? Colors.blue
                              : const Color(0xff21222D),
                        ),
                        child: Center(
                          child: Text(
                            day.name.substring(0, 2),
                            style: TextStyle(
                              color: selectedDay == day
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
      ),
    );
  }
}
