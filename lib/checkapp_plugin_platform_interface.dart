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

  Future<void> requestOverlayPermission() {
    throw UnimplementedError(
        'requestOverlayPermission() has not been implemented.');
  }

  Future<void> requestUsagePermission() {
    throw UnimplementedError(
        'requestUsagePermission() has not been implemented.');
  }
}
