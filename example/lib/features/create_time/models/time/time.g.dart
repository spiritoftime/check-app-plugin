// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'time.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Time _$TimeFromJson(Map<dynamic, dynamic> json) => Time(
      days: (json['days'] as List<dynamic>)
          .map((e) => Day.fromJson(e as Map<dynamic, dynamic>))
          .toList(),
      timings: (json['timings'] as List<dynamic>)
          .map((e) => Timing.fromJson(e as Map<dynamic, dynamic>))
          .toList(),
    );

Map<dynamic, dynamic> _$TimeToJson(Time instance) => <dynamic, dynamic>{
      'days': instance.days,
      'timings': instance.timings,
    };
