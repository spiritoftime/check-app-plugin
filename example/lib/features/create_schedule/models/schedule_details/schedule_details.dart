
import 'package:json_annotation/json_annotation.dart';
part 'schedule_details.g.dart';

@JsonSerializable(explicitToJson: true)
class ScheduleDetails {
  final String scheduleName;
  final String iconName;
  final bool isActive;
  ScheduleDetails({
    required this.isActive,
    required this.scheduleName,
    required this.iconName,
  });

  copyWith({
    String? scheduleName,
    String? iconName,
    bool? isActive,
  }) {
    return ScheduleDetails(
      isActive: isActive ?? this.isActive,
      scheduleName: scheduleName ?? this.scheduleName,
      iconName: iconName ?? this.iconName,
    );
  }

  factory ScheduleDetails.fromJson(Map<String, dynamic> json) =>
      _$ScheduleDetailsFromJson(json);
  Map<String, dynamic> toJson() => _$ScheduleDetailsToJson(this);
}
