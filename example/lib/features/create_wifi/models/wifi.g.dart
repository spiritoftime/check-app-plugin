// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'wifi.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Wifi _$WifiFromJson(Map<String, dynamic> json) => Wifi(
      scheduleId: (json['scheduleId'] as num?)?.toInt(),
      id: (json['id'] as num?)?.toInt(),
      wifiName: json['wifiName'] as String,
    );

Map<String, dynamic> _$WifiToJson(Wifi instance) => <String, dynamic>{
      'wifiName': instance.wifiName,
      'id': instance.id,
      'scheduleId': instance.scheduleId,
    };
