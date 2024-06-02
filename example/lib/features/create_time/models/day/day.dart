import 'package:json_annotation/json_annotation.dart';

part 'day.g.dart';

// enum Days { monday, tuesday, wednesday, thursday, friday, saturday, sunday }

// extension DaysExtension on Days {
//   String get day {
//     switch (this) {
//       case Days.monday:
//         return 'Monday';
//       case Days.tuesday:
//         return 'Tuesday';
//       case Days.wednesday:
//         return 'Wednesday';
//       case Days.thursday:
//         return 'Thursday';
//       case Days.friday:
//         return 'Friday';
//       case Days.saturday:
//         return 'Saturday';
//       case Days.sunday:
//         return 'Sunday';
//     }
//   }
// }

Map<String, String> daysMap = {
  'Monday': 'Monday',
  'Tuesday': 'Tuesday',
  'Wednesday': 'Wednesday',
  'Thursday': 'Thursday',
  'Friday': 'Friday',
  'Saturday': 'Saturday',
  'Sunday': 'Sunday',
};


@JsonSerializable()
class Day {
  final String day;

  Day({
    required this.day,
  });

  factory Day.fromJson(Map<dynamic, dynamic> json) => _$DayFromJson(json);
  Map<dynamic, dynamic> toJson() => _$DayToJson(this);
}
