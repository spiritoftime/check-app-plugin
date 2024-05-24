// ignore_for_file: constant_identifier_names

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'checkapp_plugin_platform_interface.dart';




const String FLUTTER_CHANNEL_NAME = "com.doomscroll.checkapp";
const String CHANNEL_DETECT_METHOD = "DETECT_APP";
const String CHANNEL_OVERLAY_PERMISSION = "REQUEST_OVERLAY_PERMISSION";
const String CHANNEL_USAGE_PERMISSION = "REQUEST_USAGE_PERMISSION";
const String GET_PLATFORM_VERSION = "getPlatformVersion";

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
  Future<bool?> requestOverlayPermission() async {
    final shouldShowPopUp =
        await methodChannel.invokeMethod<bool>(CHANNEL_OVERLAY_PERMISSION);
    return shouldShowPopUp;
  }

  @override
  Future<bool?> requestUsagePermission() async {
    final shouldShowPopUp =
        await methodChannel.invokeMethod<bool>(CHANNEL_USAGE_PERMISSION);
    return shouldShowPopUp;
  }
}
