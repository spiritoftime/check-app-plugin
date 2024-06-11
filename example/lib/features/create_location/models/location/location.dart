import 'package:equatable/equatable.dart';
import 'package:geocoder_buddy/geocoder_buddy.dart';
import 'package:json_annotation/json_annotation.dart';
part 'location.g.dart';

@JsonSerializable(explicitToJson: true)
class Location extends Equatable {
  final int? id;
  final String location;
  final double latitude;
  final double longitude;
  const Location({
    this.id,
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
        id: id, location: location, latitude: latitude, longitude: longitude);
  }

  @override
  List<Object> get props => [location, latitude, longitude];
  factory Location.fromJson(Map<String, dynamic> json) =>
      _$LocationFromJson(json);
  Map<String, dynamic> toJson() => _$LocationToJson(this);
}
