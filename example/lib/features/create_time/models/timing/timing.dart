import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'timing.g.dart';

@JsonSerializable(explicitToJson: true)
class Timing {
  final String start;
  final String end;

  const Timing({
    required this.start,
    required this.end,
  });

  factory Timing.fromJson(Map<String, dynamic> json) => _$TimingFromJson(json);
  Map<String, dynamic> toJson() => _$TimingToJson(this);
}
