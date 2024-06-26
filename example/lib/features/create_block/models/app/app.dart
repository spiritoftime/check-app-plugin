import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
part 'app.g.dart';

@JsonSerializable()
class App extends Equatable {
  final int? id;

  final String packageName;
  final String iconBase64String;
  final String appName;
  final int? blockId;
  const App({
    this.id,
    this.blockId,
    required this.packageName,
    required this.iconBase64String,
    required this.appName,
  });

  copyWith({
    String? packageName,
    String? iconBase64String,
    String? appName,
  }) {
    return App(
      id: id,
      blockId: blockId,
      packageName: packageName ?? this.packageName,
      iconBase64String: iconBase64String ?? this.iconBase64String,
      appName: appName ?? this.appName,
    );
  }

  @override
  List<Object?> get props =>
      [packageName, iconBase64String, appName, blockId, id];
  factory App.fromJson(Map<String, dynamic> json) => _$AppFromJson(json);
  Map<String, dynamic> toJson() => _$AppToJson(this);
}
