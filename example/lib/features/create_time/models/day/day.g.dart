// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'day.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Day _$DayFromJson(Map<String, dynamic> json) => Day(
      timeId: (json['timeId'] as num?)?.toInt(),
      id: (json['id'] as num?)?.toInt(),
      day: json['day'] as String,
    );

Map<String, dynamic> _$DayToJson(Day instance) => <String, dynamic>{
      'id': instance.id,
      'day': instance.day,
      'timeId': instance.timeId,
    };
