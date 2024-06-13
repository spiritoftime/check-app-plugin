// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'block.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Block _$BlockFromJson(Map<String, dynamic> json) => Block(
      scheduleId: (json['scheduleId'] as num?)?.toInt(),
      id: (json['id'] as num?)?.toInt(),
      apps: (json['apps'] as List<dynamic>)
          .map((e) => App.fromJson(e as Map<String, dynamic>))
          .toList(),
      websites: (json['websites'] as List<dynamic>)
          .map((e) => Website.fromJson(e as Map<String, dynamic>))
          .toList(),
      keywords: (json['keywords'] as List<dynamic>)
          .map((e) => Keyword.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$BlockToJson(Block instance) => <String, dynamic>{
      'id': instance.id,
      'apps': instance.apps.map((e) => e.toJson()).toList(),
      'websites': instance.websites.map((e) => e.toJson()).toList(),
      'keywords': instance.keywords.map((e) => e.toJson()).toList(),
      'scheduleId': instance.scheduleId,
    };
