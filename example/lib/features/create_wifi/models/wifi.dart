import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'wifi.g.dart';

@JsonSerializable(explicitToJson: true)
class Wifi extends Equatable {
  final String wifiName;

  const Wifi({
    required this.wifiName,
  });
  @override
  List<Object?> get props => [wifiName];
  factory Wifi.fromJson(Map<String, dynamic> json) => _$WifiFromJson(json);
  Map<String, dynamic> toJson() => _$WifiToJson(this);
}
