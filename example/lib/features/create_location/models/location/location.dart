import 'package:checkapp_plugin_example/features/create_time/models/time/time.dart';
import 'package:checkapp_plugin_example/features/create_block/models/block/block.dart';
import 'package:json_annotation/json_annotation.dart';
part 'location.g.dart';

@JsonSerializable(explicitToJson: true)
class Location {
  final String location;
  final double latitude;
  final double longitude;
  Location(
   {required this.longitude,
    required this.location,
    required this.latitude,
  });

  copyWith({
    final String? location,
    final double? latitude,
    final double? longitude,
  }) {
    return Location(
        location: location ?? this.location,
        latitude: latitude ?? this.latitude,
        longitude: longitude ?? this.longitude);
  }

  factory Location.fromJson(Map<String, dynamic> json) =>
      _$LocationFromJson(json);
  Map<String, dynamic> toJson() => _$LocationToJson(this);
}
