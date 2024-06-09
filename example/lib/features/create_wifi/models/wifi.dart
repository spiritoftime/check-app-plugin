import 'package:json_annotation/json_annotation.dart';

part 'wifi.g.dart';



@JsonSerializable(explicitToJson: true)
class Wifi {
  final String wifiName;

  Wifi({
    required this.wifiName,
  });

  factory Wifi.fromJson(Map<String, dynamic> json) => _$WifiFromJson(json);
  Map<String, dynamic> toJson() => _$WifiToJson(this);
}
