import 'package:json_annotation/json_annotation.dart';

part 'day.g.dart';

Map<String, String> daysMap = {
  'Monday': 'Monday',
  'Tuesday': 'Tuesday',
  'Wednesday': 'Wednesday',
  'Thursday': 'Thursday',
  'Friday': 'Friday',
  'Saturday': 'Saturday',
  'Sunday': 'Sunday',
};

@JsonSerializable(explicitToJson: true)
class Day {
  final int? id;
  final String day;
  final int? timeId;
  Day({
    this.timeId,
    this.id,
    required this.day,
  });

  factory Day.fromJson(Map<String, dynamic> json) => _$DayFromJson(json);
  Map<String, dynamic> toJson() => _$DayToJson(this);
}
