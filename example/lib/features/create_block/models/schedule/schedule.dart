
import 'package:checkapp_plugin_example/features/create_block/models/time/time.dart';
import 'package:checkapp_plugin_example/features/create_block/models/block/block.dart';
import 'package:json_annotation/json_annotation.dart';
part 'schedule.g.dart';

@JsonSerializable()
class Schedule {
  @JsonKey(name: 'toBlock')
  final Block block;
  @JsonKey(name: 'timing')
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

  factory Schedule.fromJson(Map<dynamic, dynamic> json) =>
      _$ScheduleFromJson(json);
  Map<dynamic, dynamic> toJson() => _$ScheduleToJson(this);
}


// Schedule(toBlock:{apps:<App>[],websites:<Websites>[],keywords:<Keywords>[]})