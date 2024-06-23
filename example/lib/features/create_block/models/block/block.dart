import 'package:checkapp_plugin_example/features/create_block/models/app/app.dart';
import 'package:checkapp_plugin_example/features/create_block/models/keyword/keyword.dart';
import 'package:checkapp_plugin_example/features/create_block/models/partial_blocker/partial_blocker.dart';
import 'package:checkapp_plugin_example/features/create_block/models/website/website.dart';
import 'package:json_annotation/json_annotation.dart';
part 'block.g.dart';

@JsonSerializable(explicitToJson: true)
class Block {
  final int? id;
  final List<PartialBlocker> partialBlockers;
  final List<App> apps;
  final List<Website> websites;
  final List<Keyword> keywords;
  final int? scheduleId;
  Block({
    required this.partialBlockers,
    this.scheduleId,
    this.id,
    required this.apps,
    required this.websites,
    required this.keywords,
  });
  copyWith({
    List<PartialBlocker>? partialBlockers,
    List<App>? apps,
    List<Website>? websites,
    List<Keyword>? keywords,
  }) {
    return Block(
      scheduleId: scheduleId,
      id: id,
      partialBlockers: partialBlockers ?? this.partialBlockers,
      apps: apps ?? this.apps,
      websites: websites ?? this.websites,
      keywords: keywords ?? this.keywords,
    );
  }

  factory Block.fromJson(Map<String, dynamic> json) => _$BlockFromJson(json);
  Map<String, dynamic> toJson() => _$BlockToJson(this);
}
