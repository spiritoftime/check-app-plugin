import 'package:checkapp_plugin_example/features/create_location/models/location/location.dart';
import 'package:checkapp_plugin_example/features/create_schedule/models/schedule_details/schedule_details.dart';
import 'package:checkapp_plugin_example/features/create_time/models/time/time.dart';
import 'package:checkapp_plugin_example/features/create_block/models/block/block.dart';
import 'package:json_annotation/json_annotation.dart';
part 'schedule.g.dart';

@JsonSerializable(explicitToJson: true)
class Schedule {
  final Block block;
  final Time time;
  final ScheduleDetails scheduleDetails;
  final Location? location;
  final int? id;
  Schedule(
 {this.id,    this.location,
    required this.scheduleDetails,
    required this.block,
    required this.time,
  });

  copyWith(
      {Block? block,
      Time? time,
      Location? location,
      ScheduleDetails? scheduleDetails}) {
    return Schedule(location:location ?? this.location,id: id ?? this.id,
        block: block ?? this.block,
        time: time ?? this.time,
        scheduleDetails: scheduleDetails ?? this.scheduleDetails);
  }

  factory Schedule.fromJson(Map<String, dynamic> json) =>
      _$ScheduleFromJson(json);
  Map<String, dynamic> toJson() => _$ScheduleToJson(this);
}


// Schedule(toBlock:{apps:<App>[],websites:<Websites>[],keywords:<Keywords>[]})