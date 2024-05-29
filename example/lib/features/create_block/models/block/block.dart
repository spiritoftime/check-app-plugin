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

  factory Block.fromJson(Map<String, dynamic> json) => _$BlockFromJson(json);
  Map<String, dynamic> toJson() => _$BlockToJson(this);
}