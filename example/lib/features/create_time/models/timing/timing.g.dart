// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'timing.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Timing _$TimingFromJson(Map<String, dynamic> json) => Timing(
      id: (json['id'] as num?)?.toInt(),
      start: json['start'] as String,
      end: json['end'] as String,
    );

Map<String, dynamic> _$TimingToJson(Timing instance) => <String, dynamic>{
      'start': instance.start,
      'end': instance.end,
      'id': instance.id,
    };
