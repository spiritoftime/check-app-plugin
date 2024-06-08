import 'package:checkapp_plugin_example/features/create_time/models/time/time.dart';
import 'package:checkapp_plugin_example/features/create_block/models/block/block.dart';
import 'package:json_annotation/json_annotation.dart';
part 'schedule_details.g.dart';

@JsonSerializable(explicitToJson: true)
class ScheduleDetails {
  final String scheduleName;
  final String iconName;
  ScheduleDetails({
    required this.scheduleName,
    required this.iconName,
  });

  copyWith({
    String? scheduleName,
    String? iconName,
  }) {
    return ScheduleDetails(
      scheduleName: scheduleName ?? this.scheduleName,
      iconName: iconName ?? this.iconName,
    );
  }

  factory ScheduleDetails.fromJson(Map<String, dynamic> json) =>
      _$ScheduleDetailsFromJson(json);
  Map<String, dynamic> toJson() => _$ScheduleDetailsToJson(this);
}
