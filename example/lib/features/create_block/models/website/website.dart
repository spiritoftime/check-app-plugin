import 'package:json_annotation/json_annotation.dart';

part 'website.g.dart';

@JsonSerializable()
class Website {
  final String url;

  Website({
    required this.url,
  });

  factory Website.fromJson(Map<dynamic, dynamic> json) =>
      _$WebsiteFromJson(json);
  Map<dynamic, dynamic> toJson() => _$WebsiteToJson(this);
}
