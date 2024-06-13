// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'location.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Location _$LocationFromJson(Map<String, dynamic> json) => Location(
      scheduleId: (json['scheduleId'] as num?)?.toInt(),
      id: (json['id'] as num?)?.toInt(),
      longitude: (json['longitude'] as num).toDouble(),
      location: json['location'] as String,
      latitude: (json['latitude'] as num).toDouble(),
    );

Map<String, dynamic> _$LocationToJson(Location instance) => <String, dynamic>{
      'id': instance.id,
      'location': instance.location,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'scheduleId': instance.scheduleId,
    };
