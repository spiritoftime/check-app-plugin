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

  factory Timing.fromJson(Map<String, dynamic> json) => _$TimingFromJson(json);
  Map<String, dynamic> toJson() => _$TimingToJson(this);
}