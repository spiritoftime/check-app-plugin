// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'block.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Block _$BlockFromJson(Map<String, dynamic> json) => Block(
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
      'apps': instance.apps,
      'websites': instance.websites,
      'keywords': instance.keywords,
    };
