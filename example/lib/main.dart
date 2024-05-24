import 'package:checkapp_plugin_example/background_service/background_service.dart';
import 'package:checkapp_plugin_example/overlay/presentation/screens/overlay_popup.dart';
import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:checkapp_plugin/checkapp_plugin.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // setUpServiceLocator();

  overlayPopUp();
  // await initializeService();
  runApp(MyApp());
}

///
/// the name is required to be `overlayPopUp` and has `@pragma("vm:entry-point")`
///
// needs to be at main.dart for some reason
@pragma("vm:entry-point")
void overlayPopUp() {
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: OverlayWidget(),
  ));
}

class MyApp extends StatelessWidget {
  final _checkAppPlugin = CheckappPlugin();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text("Doomscroll Detector")),
        body: Center(
            child: Column(
          children: [
            const Text("Monitor Facebook App Usage"),
            ElevatedButton(
                onPressed: () async {
                  await _checkAppPlugin.getPlatformVersion();
                },
                child: const Text("ENABLE Usage PERMISSION")),
            ElevatedButton(
                onPressed: () async {
                  await _checkAppPlugin.requestOverlayPermission();
                },
                child: const Text("ENABLE Overlay PERMISSION")),
            ElevatedButton(
                onPressed: () async {
                  await _checkAppPlugin.requestNotificationPermission();
                },
                child: const Text("ENABLE Notification PERMISSION"))
          ],
        )),
      ),
    );
  }
}
