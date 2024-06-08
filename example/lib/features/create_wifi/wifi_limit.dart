import 'package:checkapp_plugin/checkapp_plugin.dart';
import 'package:flutter/material.dart';

class WifiLimit extends StatelessWidget {
  final Map<String, dynamic> extra;
  final CheckappPlugin _checkappPlugin = CheckappPlugin();

  WifiLimit({super.key, required this.extra});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () async => await _checkappPlugin.getNearbyWifi(), child: const Text("Get Nearby Wifi"),
    );
  }
}
