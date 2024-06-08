import 'package:checkapp_plugin_example/features/create_time/models/day/day.dart';
import 'package:checkapp_plugin_example/features/create_time/models/timing/timing.dart';
import 'package:json_annotation/json_annotation.dart';
part 'time.g.dart';

@JsonSerializable()
class Time {
  final List<Day> days;
  final List<Timing> timings;

  Time({
    required this.days,
    required this.timings,
  });
  copyWith({
    List<Day>? days,
    List<Timing>? timings,
  }) {
    return Time(
      days: days ?? this.days,
      timings: timings ?? this.timings,
    );
  }

  factory Time.fromJson(Map<String, dynamic> json) => _$TimeFromJson(json);
  Map<String, dynamic> toJson() => _$TimeToJson(this);
}
