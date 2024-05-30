import 'package:checkapp_plugin_example/features/create_block/models/app/app.dart';
import 'package:checkapp_plugin_example/features/create_block/models/keyword/keyword.dart';
import 'package:checkapp_plugin_example/features/create_block/models/website/website.dart';
import 'package:json_annotation/json_annotation.dart';
part 'block.g.dart';

@JsonSerializable()
class Block {
  final List<App> apps;
  final List<Website> websites;
  final List<Keyword> keywords;

  Block({
    required this.apps,
    required this.websites,
    required this.keywords,
  });
  copyWith(
      {List<App>? apps, List<Website>? websites, List<Keyword>? keywords}) {
    return Block(
      apps: apps ?? this.apps,
      websites: websites ?? this.websites,
      keywords: keywords ?? this.keywords,
    );
  }

  factory Block.fromJson(Map<dynamic, dynamic> json) => _$BlockFromJson(json);
  Map<dynamic, dynamic> toJson() => _$BlockToJson(this);
}
