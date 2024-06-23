import 'package:json_annotation/json_annotation.dart';

part 'timing.g.dart';

@JsonSerializable(explicitToJson: true)
class Timing {
  final String startTiming;
  final String endTiming;
  final int? timeId;
  final int? id;
  const Timing({
    this.timeId,
    this.id,
    required this.startTiming,
    required this.endTiming,
  });

  factory Timing.fromJson(Map<String, dynamic> json) => _$TimingFromJson(json);
  Map<String, dynamic> toJson() => _$TimingToJson(this);
}
