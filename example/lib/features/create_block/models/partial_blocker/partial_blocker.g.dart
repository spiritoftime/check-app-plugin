// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'partial_blocker.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PartialBlocker _$PartialBlockerFromJson(Map<String, dynamic> json) =>
    PartialBlocker(
      packageName: json['packageName'] as String,
      appName: json['appName'] as String,
      feature: json['feature'] as String,
      blockId: (json['blockId'] as num?)?.toInt(),
      imagePath: json['imagePath'] as String,
      id: (json['id'] as num?)?.toInt(),
    );

Map<String, dynamic> _$PartialBlockerToJson(PartialBlocker instance) =>
    <String, dynamic>{
      'id': instance.id,
      'imagePath': instance.imagePath,
      'appName': instance.appName,
      'packageName': instance.packageName,
      'feature': instance.feature,
      'blockId': instance.blockId,
    };
