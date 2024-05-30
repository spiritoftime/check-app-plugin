// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'schedule.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Schedule _$ScheduleFromJson(Map<dynamic, dynamic> json) => Schedule(
      block: Block.fromJson(json['toBlock'] as Map<String, dynamic>),
      timing: Time.fromJson(json['timing'] as Map<String, dynamic>),
    );

Map<dynamic, dynamic> _$ScheduleToJson(Schedule instance) => <dynamic, dynamic>{
      'toBlock': instance.block,
      'timing': instance.timing,
    };
