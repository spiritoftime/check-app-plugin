import 'package:json_annotation/json_annotation.dart';

part 'day.g.dart';

enum Days { monday, tuesday, wednesday, thursday, friday, saturday, sunday }

@JsonSerializable()
class Day {
  final Days name;

  Day({
    required this.name,
  });

  factory Day.fromJson(Map<dynamic, dynamic> json) => _$DayFromJson(json);
  Map<dynamic, dynamic> toJson() => _$DayToJson(this);
}
