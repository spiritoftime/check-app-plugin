// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'timing.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Timing _$TimingFromJson(Map<String, dynamic> json) => Timing(
      timeId: (json['timeId'] as num?)?.toInt(),
      id: (json['id'] as num?)?.toInt(),
      startTiming: json['startTiming'] as String,
      endTiming: json['endTiming'] as String,
    );

Map<String, dynamic> _$TimingToJson(Timing instance) => <String, dynamic>{
      'startTiming': instance.startTiming,
      'endTiming': instance.endTiming,
      'timeId': instance.timeId,
      'id': instance.id,
    };
