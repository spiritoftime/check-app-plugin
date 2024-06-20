import 'package:checkapp_plugin/checkapp_plugin.dart';
import 'package:flutter/material.dart';

class StrictBlockScreen extends StatelessWidget {
  StrictBlockScreen({super.key});
  final _checkAppPlugin = CheckappPlugin();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FutureBuilder<bool>(
              future: _checkAppPlugin.checkAccessibilityPermission(),
              builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
                if (snapshot.hasData) {
                  return Text(
                      "Accessibility Permission: ${snapshot.data.toString()}");
                } else if (snapshot.hasError) {
                  return Text("Error: ${snapshot.error.toString()}");
                } else {
                  return const Text("Loading...");
                }
              },
            ),
            ElevatedButton(
                onPressed: () async {
                  await _checkAppPlugin.requestAccessibilityPermission();
                },
                child: const Text("ENABLE Accessibility PERMISSION"))
          ],
        ),
      ),
    );
  }
}
