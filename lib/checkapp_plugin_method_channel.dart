// ignore_for_file: constant_identifier_names

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'checkapp_plugin_platform_interface.dart';

const String FLUTTER_CHANNEL_NAME = "com.doomscroll.checkapp";
const String CHANNEL_DETECT_METHOD = "DETECT_APP";
const String CHANNEL_OVERLAY_PERMISSION = "REQUEST_OVERLAY_PERMISSION";
const String CHANNEL_USAGE_PERMISSION = "REQUEST_USAGE_PERMISSION";
const String GET_PLATFORM_VERSION = "getPlatformVersion";
const String REQUEST_NOTIFICATION_PERMISSION =
    "REQUEST_NOTIFICATION_PERMISSION";
    const  String REQUEST_BACKGROUND_PERMISSION = "REQUEST_BACKGROUND_PERMISSION";

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
  
}
