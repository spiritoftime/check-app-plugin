import 'package:json_annotation/json_annotation.dart';

part 'keyword.g.dart';

@JsonSerializable(explicitToJson: true)
class Keyword {
  final String keyword;

  Keyword({
    required this.keyword,
  });

  factory Keyword.fromJson(Map<String, dynamic> json) => _$KeywordFromJson(json);
  Map<String, dynamic> toJson() => _$KeywordToJson(this);
}