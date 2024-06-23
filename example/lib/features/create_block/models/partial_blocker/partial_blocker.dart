import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
part 'partial_blocker.g.dart';

@JsonSerializable(explicitToJson: true)
class PartialBlocker extends Equatable {
  final int? id;
  final String imagePath;
  final String appName;
  final String feature;
  final int? blockId;
  const PartialBlocker({
    required this.appName,
    required this.feature,
    this.blockId,
    required this.imagePath,
    this.id,
  });
  @override
  List<Object?> get props =>
      [imagePath, feature, appName, blockId, id];
  factory PartialBlocker.fromJson(Map<String, dynamic> json) =>
      _$PartialBlockerFromJson(json);
  Map<String, dynamic> toJson() => _$PartialBlockerToJson(this);
}
