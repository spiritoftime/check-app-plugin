import 'package:json_annotation/json_annotation.dart';

part 'keyword.g.dart';

@JsonSerializable()
class Keyword {
  final String keyword;

  Keyword({
    required this.keyword,
  });

  factory Keyword.fromJson(Map<dynamic, dynamic> json) => _$KeywordFromJson(json);
  Map<dynamic, dynamic> toJson() => _$KeywordToJson(this);
}