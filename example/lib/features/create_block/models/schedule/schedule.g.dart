// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'schedule.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Schedule _$ScheduleFromJson(Map<String, dynamic> json) => Schedule(
      block: Block.fromJson(json['block'] as Map<String, dynamic>),
      timing: Time.fromJson(json['timing'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ScheduleToJson(Schedule instance) => <String, dynamic>{
      'block': instance.block.toJson(),
      'timing': instance.timing.toJson(),
    };
