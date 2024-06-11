import 'package:checkapp_plugin_example/features/create_block/models/app/app.dart';
import 'package:checkapp_plugin_example/features/create_block/models/keyword/keyword.dart';
import 'package:checkapp_plugin_example/features/create_block/models/website/website.dart';
import 'package:json_annotation/json_annotation.dart';
part 'block.g.dart';

@JsonSerializable(explicitToJson: true)
class Block {
  final int? id;

  final List<App> apps;
  final List<Website> websites;
  final List<Keyword> keywords;

  Block({
    this.id,
    required this.apps,
    required this.websites,
    required this.keywords,
  });
  copyWith(
      {List<App>? apps,
      List<Website>? websites,
      List<Keyword>? keywords,
      int? id}) {
    return Block(
      id: id ?? this.id,
      apps: apps ?? this.apps,
      websites: websites ?? this.websites,
      keywords: keywords ?? this.keywords,
    );
  }

  factory Block.fromJson(Map<String, dynamic> json) => _$BlockFromJson(json);
  Map<String, dynamic> toJson() => _$BlockToJson(this);
}
