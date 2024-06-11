// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'website.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Website _$WebsiteFromJson(Map<String, dynamic> json) => Website(
      id: (json['id'] as num?)?.toInt(),
      url: json['url'] as String,
    );

Map<String, dynamic> _$WebsiteToJson(Website instance) => <String, dynamic>{
      'id': instance.id,
      'url': instance.url,
    };
