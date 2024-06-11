// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'keyword.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Keyword _$KeywordFromJson(Map<String, dynamic> json) => Keyword(
      id: (json['id'] as num?)?.toInt(),
      keyword: json['keyword'] as String,
    );

Map<String, dynamic> _$KeywordToJson(Keyword instance) => <String, dynamic>{
      'id': instance.id,
      'keyword': instance.keyword,
    };
