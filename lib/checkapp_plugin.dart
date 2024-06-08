import 'checkapp_plugin_platform_interface.dart';

class CheckappPlugin {
  Future<String?> getPlatformVersion() {
    return CheckappPluginPlatform.instance.getPlatformVersion();
  }

  Future<bool?> detectForbiddenApp() {
    return CheckappPluginPlatform.instance.detectForbiddenApp();
  }

  Future<void> requestOverlayPermission() {
    return CheckappPluginPlatform.instance.requestOverlayPermission();
  }

  Future<void> requestUsagePermission() {
    return CheckappPluginPlatform.instance.requestUsagePermission();
  }

  Future<void> requestNotificationPermission() {
    return CheckappPluginPlatform.instance.requestNotificationPermission();
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
