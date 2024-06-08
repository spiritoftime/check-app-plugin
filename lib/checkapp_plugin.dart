import 'checkapp_plugin_platform_interface.dart';

class CheckappPlugin {
  Future<String?> getPlatformVersion() {
    return CheckappPluginPlatform.instance.getPlatformVersion();
  }

  Future<bool?> detectForbiddenApp() {
    return CheckappPluginPlatform.instance.detectForbiddenApp();
  }
  Future<bool> checkOverlayPermission() {
    return CheckappPluginPlatform.instance.checkOverlayPermission();
  }
  Future<void> requestOverlayPermission() {
    return CheckappPluginPlatform.instance.requestOverlayPermission();
  }
  Future<bool> checkUsagePermission() {
    return CheckappPluginPlatform.instance.checkUsagePermission();
  }
  Future<void> requestUsagePermission() {
    return CheckappPluginPlatform.instance.requestUsagePermission();
  }
  Future<bool> checkNotificationPermission() {
    return CheckappPluginPlatform.instance.checkNotificationPermission();
  }
  Future<void> requestNotificationPermission() {
    return CheckappPluginPlatform.instance.requestNotificationPermission();
  }
  Future<bool> checkBackgroundPermission() {
    return CheckappPluginPlatform.instance.checkBackgroundPermission();
  }
  Future<void> requestBackgroundPermission() {
    return CheckappPluginPlatform.instance.requestBackgroundPermission();
  }

  Future<List<Map<String,dynamic>>> getLaunchableApplications() {
    return CheckappPluginPlatform.instance.getLaunchableApplications();
  }

  Future<void> requestLocationPermission() {
    return CheckappPluginPlatform.instance.requestLocationPermission();
  }

  Future<bool> checkLocationPermission() {
    return CheckappPluginPlatform.instance.checkLocationPermission();
  }
}
