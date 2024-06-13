// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

App _$AppFromJson(Map<String, dynamic> json) => App(
      id: (json['id'] as num?)?.toInt(),
      blockId: (json['blockId'] as num?)?.toInt(),
      packageName: json['packageName'] as String,
      iconBase64String: json['iconBase64String'] as String,
      appName: json['appName'] as String,
    );

Map<String, dynamic> _$AppToJson(App instance) => <String, dynamic>{
      'id': instance.id,
      'packageName': instance.packageName,
      'iconBase64String': instance.iconBase64String,
      'appName': instance.appName,
      'blockId': instance.blockId,
    };
