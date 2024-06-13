// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'schedule_details.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ScheduleDetails _$ScheduleDetailsFromJson(Map<String, dynamic> json) =>
    ScheduleDetails(
      isActive: json['isActive'] as bool,
      scheduleName: json['scheduleName'] as String,
      iconName: json['iconName'] as String,
    );

Map<String, dynamic> _$ScheduleDetailsToJson(ScheduleDetails instance) =>
    <String, dynamic>{
      'scheduleName': instance.scheduleName,
      'iconName': instance.iconName,
      'isActive': instance.isActive,
    };
