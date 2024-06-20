import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'checkapp_plugin_method_channel.dart';

abstract class CheckappPluginPlatform extends PlatformInterface {
  /// Constructs a CheckappPluginPlatform.
  CheckappPluginPlatform() : super(token: _token);

  static final Object _token = Object();

  static CheckappPluginPlatform _instance = MethodChannelCheckappPlugin();

  /// The default instance of [CheckappPluginPlatform] to use.
  ///
  /// Defaults to [MethodChannelCheckappPlugin].
  static CheckappPluginPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [CheckappPluginPlatform] when
  /// they register themselves.
  static set instance(CheckappPluginPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }

  Future<bool?> detectForbiddenApp() {
    throw UnimplementedError('detectForbiddenApp() has not been implemented.');
  }

  Future<bool> checkOverlayPermission() {
    throw UnimplementedError(
        'checkOverlayPermission() has not been implemented.');
  }

  Future<void> requestOverlayPermission() {
    throw UnimplementedError(
        'requestOverlayPermission() has not been implemented.');
  }

  Future<bool> checkUsagePermission() {
    throw UnimplementedError(
        'checkUsagePermission() has not been implemented.');
  }

  Future<void> requestUsagePermission() {
    throw UnimplementedError(
        'requestUsagePermission() has not been implemented.');
  }

  Future<bool> checkNotificationPermission() {
    throw UnimplementedError(
        'checkNotificationPermission() has not been implemented.');
  }

  Future<void> requestNotificationPermission() {
    throw UnimplementedError(
        'requestNotificationPermission() has not been implemented.');
  }

  Future<bool> checkBackgroundPermission() {
    throw UnimplementedError(
        'checkBackgroundPermission() has not been implemented.');
  }

  Future<void> requestBackgroundPermission() {
    throw UnimplementedError(
        'requestBackgroundPermission() has not been implemented.');
  }

  Future<List<Map<String, dynamic>>> getLaunchableApplications() {
    throw UnimplementedError(
        'getLaunchableApplications() has not been implemented.');
  }

  Future<void> requestLocationPermission() {
    throw UnimplementedError(
        'requestLocationPermission() has not been implemented.');
  }

  Future<bool> checkLocationPermission() {
    throw UnimplementedError(
        'checkLocationPermission() has not been implemented.');
  }

   Future<List<Map<String, dynamic>>> getNearbyWifi() {
    throw UnimplementedError('getNearbyWifi() has not been implemented.');
  }

   Future<bool> checkGPSEnabled() {
    throw UnimplementedError('checkGPSEnabled() has not been implemented.');
  }

  Future<void> requestEnableGPS() {
    throw UnimplementedError(
        'requestEnableGPS() has not been implemented.');
  }
  
    Future<void> reQueryActiveSchedules() {
    throw UnimplementedError(
        'reQueryActiveSchedules() has not been implemented.');
  }

      Future<void> requestAccessibilityPermission() {
    throw UnimplementedError(
        'requestAccessibilityPermission() has not been implemented.');
  }

        Future<bool> checkAccessibilityPermission() {
    throw UnimplementedError(
        'checkAccessibilityPermission() has not been implemented.');
  }
}
