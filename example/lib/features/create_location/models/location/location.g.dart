// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'location.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Location _$LocationFromJson(Map<String, dynamic> json) => Location(
      longitude: (json['longitude'] as num).toDouble(),
      location: json['location'] as String,
      latitude: (json['latitude'] as num).toDouble(),
    );

Map<String, dynamic> _$LocationToJson(Location instance) => <String, dynamic>{
      'location': instance.location,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
    };
