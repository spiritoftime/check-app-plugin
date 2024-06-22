import 'package:checkapp_plugin/checkapp_plugin_constants.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'checkapp_plugin_platform_interface.dart';

/// An implementation of [CheckappPluginPlatform] that uses method channels.
class MethodChannelCheckappPlugin extends CheckappPluginPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel(FLUTTER_CHANNEL_NAME);

  @override
  Future<String?> getPlatformVersion() async {
    final version =
        await methodChannel.invokeMethod<String>(GET_PLATFORM_VERSION);
    return version;
  }

  @override
  Future<bool?> detectForbiddenApp() async {
    final shouldShowPopUp =
        await methodChannel.invokeMethod<bool>(CHANNEL_DETECT_METHOD);
    return shouldShowPopUp;
  }

  @override
  Future<bool> checkOverlayPermission() async {
    final isPermissionEnabled =
        await methodChannel.invokeMethod<bool>(CHECK_OVERLAY_PERMISSION);
    return isPermissionEnabled ?? false;
  }

  @override
  Future<void> requestOverlayPermission() async {
    await methodChannel.invokeMethod<void>(REQUEST_OVERLAY_PERMISSION);
  }

  @override
  Future<bool> checkUsagePermission() async {
    final isPermissionEnabled =
        await methodChannel.invokeMethod<int>(CHECK_USAGE_PERMISSION);
    return isPermissionEnabled == 0 ? true : false;
  }

  @override
  Future<void> requestUsagePermission() async {
    await methodChannel.invokeMethod<bool>(REQUEST_USAGE_PERMISSION);
  }

  @override
  Future<bool> checkNotificationPermission() async {
    final isPermissionEnabled =
        await methodChannel.invokeMethod<bool>(CHECK_NOTIFICATION_PERMISSION);
    return isPermissionEnabled ?? false;
  }

  @override
  Future<void> requestNotificationPermission() async {
    await methodChannel.invokeMethod<void>(REQUEST_NOTIFICATION_PERMISSION);
  }

  @override
  Future<bool> checkAccessibilityPermission() async {
    final isPermissionEnabled =
        await methodChannel.invokeMethod<bool>(CHECK_ACCESSIBILITY_PERMISSION);
    return isPermissionEnabled ?? false;
  }

  @override
  Future<void> requestAccessibilityPermission() async {
    await methodChannel.invokeMethod<void>(REQUEST_ACCESSIBILITY_PERMISSION);
  }

  @override
  Future<bool> checkBackgroundPermission() async {
    final isPermissionEnabled =
        await methodChannel.invokeMethod<bool>(CHECK_BACKGROUND_PERMISSION);
    return isPermissionEnabled ?? false;
  }

  @override
  Future<void> requestBackgroundPermission() async {
    await methodChannel.invokeMethod<bool>(REQUEST_BACKGROUND_PERMISSION);
  }

// TODO: to add isolate as it is taking too long
  @override
  Future<List<Map<String, dynamic>>> getLaunchableApplications() async {
    var launchableApplications = await methodChannel
        .invokeListMethod<Map<dynamic, dynamic>>(GET_LAUNCHABLE_APPLICATIONS);

    final castedData = launchableApplications
            ?.map((item) => Map<String, dynamic>.from(item))
            .toList() ??
        <Map<String, dynamic>>[];

    return castedData;
  }

  @override
  Future<List<Map<String, dynamic>>> getNearbyWifi() async {
    var launchableApplications = await methodChannel
        .invokeListMethod<Map<dynamic, dynamic>>(GET_NEARBY_WIFI);

    final castedData = launchableApplications
            ?.map((item) => Map<String, dynamic>.from(item))
            .toList() ??
        <Map<String, dynamic>>[];

    return castedData;
  }

  @override
  Future<void> requestLocationPermission() async {
    await methodChannel.invokeMethod<void>(REQUEST_LOCATION_PERMISSION);
  }

  @override
  Future<void> reQueryActiveSchedules() async {
    await methodChannel.invokeMethod<void>(REQUERY_ACTIVE_SCHEDULES);
  }

  @override
  Future<bool> checkLocationPermission() async {
    bool? isPermissionEnabled =
        await methodChannel.invokeMethod<bool>(CHECK_LOCATION_PERMISSION);
    return isPermissionEnabled ?? false;
  }

  @override
  Future<bool> checkGPSEnabled() async {
    bool? isPermissionEnabled =
        await methodChannel.invokeMethod<bool>(CHECK_GPS_ENABLED);
    return isPermissionEnabled ?? false;
  }

  @override
  Future<void> requestEnableGPS() async {
    await methodChannel.invokeMethod<void>(REQUEST_ENABLE_GPS);
  }

  @override
  Future<bool> checkBatteryOptimizationDisabled() async {
    bool? isPermissionEnabled = await methodChannel
        .invokeMethod<bool>(CHECK_BATTERY_OPTIMIZATION_PERMISSION);
    return isPermissionEnabled ?? false;
  }

  @override
  Future<void> requestDisableBatteryOptimization() async {
    await methodChannel
        .invokeMethod<void>(REQUEST_BATTERY_OPTIMIZATION_PERMISSION);
  }
}
