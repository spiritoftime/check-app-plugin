import 'package:json_annotation/json_annotation.dart';

part 'website.g.dart';

@JsonSerializable()
class Website {
  final String url;
  final String title;

  Website({
    required this.url,
    required this.title,
  });

  factory Website.fromJson(Map<String, dynamic> json) => _$WebsiteFromJson(json);
  Map<String, dynamic> toJson() => _$WebsiteToJson(this);
}