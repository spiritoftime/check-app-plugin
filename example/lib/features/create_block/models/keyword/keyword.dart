import 'package:json_annotation/json_annotation.dart';

part 'keyword.g.dart';

@JsonSerializable(explicitToJson: true)
class Keyword {
  final int? id;
  final int? blockId;

  final String keyword;

  Keyword({
    this.id,
    this.blockId,
    required this.keyword,
  });

  factory Keyword.fromJson(Map<String, dynamic> json) =>
      _$KeywordFromJson(json);
  Map<String, dynamic> toJson() => _$KeywordToJson(this);
}
