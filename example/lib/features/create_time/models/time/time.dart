import 'package:checkapp_plugin_example/features/create_time/models/day/day.dart';
import 'package:checkapp_plugin_example/features/create_time/models/timing/timing.dart';
import 'package:json_annotation/json_annotation.dart';
part 'time.g.dart';

@JsonSerializable(explicitToJson: true)
class Time {
  final List<Day> days;
  final List<Timing> timings;
final int? id;
final int? scheduleId;
  Time({
    this.scheduleId,
    this.id,
    required this.days,
    required this.timings,
  });
  copyWith({
    List<Day>? days,
    List<Timing>? timings,
  }) {
    return Time(
      scheduleId: scheduleId,
      id:id,
      days: days ?? this.days,
      timings: timings ?? this.timings,
    );
  }

  factory Time.fromJson(Map<String, dynamic> json) => _$TimeFromJson(json);
  Map<String, dynamic> toJson() => _$TimeToJson(this);
}
