import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'timing.g.dart';

@JsonSerializable()
class Timing extends Equatable {
  final String start;
  final String end;

  const Timing({
    required this.start,
    required this.end,
  });
  @override
  List<Object?> get props => [start, end];
  factory Timing.fromJson(Map<String, dynamic> json) => _$TimingFromJson(json);
  Map<String, dynamic> toJson() => _$TimingToJson(this);
}
