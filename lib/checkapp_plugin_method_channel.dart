import 'dart:convert';

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
  Future<void> requestOverlayPermission() async {
    final isPermissionEnabled =
        await methodChannel.invokeMethod<bool>(CHANNEL_OVERLAY_PERMISSION);
  }

  @override
  Future<void> requestUsagePermission() async {
    final isPermissionEnabled =
        await methodChannel.invokeMethod<bool>(CHANNEL_USAGE_PERMISSION);
  }

  @override
  Future<void> requestNotificationPermission() async {
    final isPermissionEnabled =
        await methodChannel.invokeMethod<bool>(REQUEST_NOTIFICATION_PERMISSION);
  }

  @override
  Future<void> requestBackgroundPermission() async {
    final isPermissionEnabled =
        await methodChannel.invokeMethod<bool>(REQUEST_BACKGROUND_PERMISSION);
  }

// TODO: to add isolate as it is taking too long
  @override
  Future<List<dynamic>> getLaunchableApplications() async {
    var launchableApplications = await methodChannel
        .invokeListMethod<Map<dynamic, dynamic>>(GET_LAUNCHABLE_APPLICATIONS);

    return launchableApplications ?? [];
  }
}
