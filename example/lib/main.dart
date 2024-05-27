import 'package:checkapp_plugin_example/background_service/background_service.dart';
import 'package:checkapp_plugin_example/presentation/basic/basic_screen.dart';
import 'package:checkapp_plugin_example/presentation/overlay/presentation/screens/overlay_popup.dart';
import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:checkapp_plugin/checkapp_plugin.dart';
import 'package:checkapp_plugin_example/router/router.dart';
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // setUpServiceLocator();

  // overlayPopUp();
  // await initializeService();
    SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp,DeviceOrientation.portraitDown])
      .then((_) => runApp(MyApp()),
  );
}

// /
// / the name is required to be `overlayPopUp` and has `@pragma("vm:entry-point")`
// /
// needs to be at main.dart for some reason
@pragma("vm:entry-point")
void overlayPopUp() {
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: OverlayWidget(),
  ));
}


