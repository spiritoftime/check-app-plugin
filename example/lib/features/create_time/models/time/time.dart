import 'package:checkapp_plugin_example/features/create_block/models/day/day.dart';
import 'package:checkapp_plugin_example/features/create_block/models/timing/timing.dart';
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

  factory Time.fromJson(Map<dynamic, dynamic> json) => _$TimeFromJson(json);
  Map<dynamic, dynamic> toJson() => _$TimeToJson(this);
}