import 'package:json_annotation/json_annotation.dart';

part 'website.g.dart';

@JsonSerializable(explicitToJson: true)
class Website {
  final int? id;
  final String url;

  Website({
    this.id,
    required this.url,
  });

  factory Website.fromJson(Map<String, dynamic> json) =>
      _$WebsiteFromJson(json);
  Map<String, dynamic> toJson() => _$WebsiteToJson(this);
}
