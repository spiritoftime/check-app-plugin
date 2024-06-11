import 'dart:async';

import 'package:checkapp_plugin/checkapp_plugin.dart';
import 'package:checkapp_plugin_example/features/overlay/usecases/overlay_usecase.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_background_service_android/flutter_background_service_android.dart';

Future<void> initializeService() async {
  final service = FlutterBackgroundService();
  await service.configure(
      iosConfiguration: IosConfiguration(),
      androidConfiguration: AndroidConfiguration(
          onStart: onStart, isForegroundMode: true, autoStart: false));

  await service.startService();
}

@pragma('vm:entry-point')
void onStart(ServiceInstance service) async {
  final _checkAppPlugin = CheckappPlugin();

  if (service is AndroidServiceInstance) {
    service.on('setAsForeground').listen((event) {
      service.setAsForegroundService();
    });

    service.on('setAsBackground').listen((event) {
      service.setAsBackgroundService();
    });
    service.on('stopService').listen((event) {
      service.stopSelf();
    });

    Timer.periodic(const Duration(seconds: 1), (timer) async {
      try {
        print("---------------------------------------------");
        bool shouldShowPopUp =
            await _checkAppPlugin.detectForbiddenApp() ?? false;
        print("shouldShowPopUp: $shouldShowPopUp");
        if (shouldShowPopUp) await OverlayUsecase().openOverlayPopUp();
      } on PlatformException catch (e) {
        debugPrint("Error: '${e.message}'.");
      }
    });
  }
}
