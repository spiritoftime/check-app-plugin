// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'schedule.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Schedule _$ScheduleFromJson(Map<String, dynamic> json) => Schedule(
      id: (json['id'] as num?)?.toInt(),
      location: (json['location'] as List<dynamic>?)
          ?.map((e) => Location.fromJson(e as Map<String, dynamic>))
          .toList(),
      scheduleDetails: ScheduleDetails.fromJson(
          json['scheduleDetails'] as Map<String, dynamic>),
      block: Block.fromJson(json['block'] as Map<String, dynamic>),
      time: Time.fromJson(json['time'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ScheduleToJson(Schedule instance) => <String, dynamic>{
      'block': instance.block.toJson(),
      'time': instance.time.toJson(),
      'scheduleDetails': instance.scheduleDetails.toJson(),
      'location': instance.location?.map((e) => e.toJson()).toList(),
      'id': instance.id,
    };
