import 'package:json_annotation/json_annotation.dart';

part 'timing.g.dart';

@JsonSerializable()
class Timing {
  final String start;
  final String end;

  Timing({
    required this.start,
    required this.end,
  });

  factory Timing.fromJson(Map<dynamic, dynamic> json) => _$TimingFromJson(json);
  Map<dynamic, dynamic> toJson() => _$TimingToJson(this);
}