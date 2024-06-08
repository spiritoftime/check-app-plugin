
import 'package:json_annotation/json_annotation.dart';
part 'location.g.dart';

@JsonSerializable(explicitToJson: true)
class Location {
  final String location;
  final double latitude;
  final double longitude;
  Location({
    required this.longitude,
    required this.location,
    required this.latitude,
  });

  copyWith({
    required final String location,
    required final double latitude,
    required final double longitude,
  }) {
    return Location(
        location: location, latitude: latitude, longitude: longitude);
  }

  factory Location.fromJson(Map<String, dynamic> json) =>
      _$LocationFromJson(json);
  Map<String, dynamic> toJson() => _$LocationToJson(this);
}
