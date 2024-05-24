
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
}
