
import 'package:checkapp_plugin_example/features/create_time/models/time/time.dart';
import 'package:checkapp_plugin_example/features/create_block/models/block/block.dart';
import 'package:json_annotation/json_annotation.dart';
part 'schedule.g.dart';

@JsonSerializable(explicitToJson: true)
class Schedule {
  final Block block;
  final Time timing;
  Schedule({
    required this.block,
    required this.timing,
  });

  copyWith({
    Block? block,
    Time? timing,
  }) {
    return Schedule(block: block ?? this.block, timing: timing ?? this.timing);
  }

  factory Schedule.fromJson(Map<String, dynamic> json) =>
      _$ScheduleFromJson(json);
  Map<String, dynamic> toJson() => _$ScheduleToJson(this);
}


// Schedule(toBlock:{apps:<App>[],websites:<Websites>[],keywords:<Keywords>[]})