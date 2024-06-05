import 'package:flutter_test/flutter_test.dart';
import 'package:checkapp_plugin/checkapp_plugin.dart';
import 'package:checkapp_plugin/checkapp_plugin_platform_interface.dart';
import 'package:checkapp_plugin/checkapp_plugin_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockCheckappPluginPlatform
    with MockPlatformInterfaceMixin
    implements CheckappPluginPlatform {
  @override
  Future<String?> getPlatformVersion() => Future.value('42');

  @override
  Future<bool?> detectForbiddenApp() {
    // TODO: implement detectForbiddenApp
    throw UnimplementedError();
  }

  @override
  Future<void> requestOverlayPermission() {
    // TODO: implement requestOverlayPermission
    throw UnimplementedError();
  }

  @override
  Future<void> requestUsagePermission() {
    // TODO: implement requestUsagePermission
    throw UnimplementedError();
  }

  @override
  Future<void> requestNotificationPermission() {
    // TODO: implement requestNotificationPermission
    throw UnimplementedError();
  }

  @override
  Future<void> requestBackgroundPermission() {
    // TODO: implement requestBackgroundPermission
    throw UnimplementedError();
  }

  @override
  Future<List<dynamic>> getLaunchableApplications() {
    // TODO: implement getLaunchableApplications
    throw UnimplementedError();
  }
  
  @override
  Future<bool> checkLocationPermission() {
    // TODO: implement checkLocationPermission
    throw UnimplementedError();
  }
  
  @override
  Future<void> requestLocationPermission() {
    // TODO: implement requestLocationPermission
    throw UnimplementedError();
  }
}

void main() {
  final CheckappPluginPlatform initialPlatform =
      CheckappPluginPlatform.instance;

  test('$MethodChannelCheckappPlugin is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelCheckappPlugin>());
  });

  test('getPlatformVersion', () async {
    CheckappPlugin checkappPlugin = CheckappPlugin();
    MockCheckappPluginPlatform fakePlatform = MockCheckappPluginPlatform();
    CheckappPluginPlatform.instance = fakePlatform;

    expect(await checkappPlugin.getPlatformVersion(), '42');
  });
}
