
import 'package:json_annotation/json_annotation.dart';
part 'app.g.dart';

@JsonSerializable()
class App {
  String packageName;
  String iconBase64String;
  String appName;

  App({
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
        packageName: packageName ?? this.packageName,
        iconBase64String: iconBase64String ?? this.iconBase64String,
        appName: appName ?? this.appName,
        );
  }

  factory App.fromJson(Map<String, dynamic> json) => _$AppFromJson(json);
  Map<String, dynamic> toJson() => _$AppToJson(this);
}
