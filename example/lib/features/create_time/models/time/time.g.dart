// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'time.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Time _$TimeFromJson(Map<String, dynamic> json) => Time(
      days: (json['days'] as List<dynamic>)
          .map((e) => Day.fromJson(e as Map<String, dynamic>))
          .toList(),
      timings: (json['timings'] as List<dynamic>)
          .map((e) => Timing.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$TimeToJson(Time instance) => <String, dynamic>{
      'days': instance.days.map((e) => e.toJson()).toList(),
      'timings': instance.timings.map((e) => e.toJson()).toList(),
    };
