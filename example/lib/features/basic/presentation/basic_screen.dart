// import 'package:checkapp_plugin/checkapp_plugin.dart';
// import 'package:flutter/material.dart';
// // import 'package:flutter_background_service/flutter_background_service.dart';

// class BasicScreen extends StatelessWidget {
//   final _checkAppPlugin = CheckappPlugin();

//   BasicScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: Scaffold(
//         appBar: AppBar(title: const Text("Doomscroll Detector")),
//         body: Center(
//             child: Column(
//           children: [
//             const Text("Monitor Facebook App Usage"),
//             ElevatedButton(
//                 onPressed: () async {
//                   await _checkAppPlugin.requestUsagePermission();
//                 },
//                 child: const Text("ENABLE Usage PERMISSION")),
//             ElevatedButton(
//                 onPressed: () async {
//                   await _checkAppPlugin.requestOverlayPermission();
//                 },
//                 child: const Text("ENABLE Overlay PERMISSION")),
//             ElevatedButton(
//                 onPressed: () async {
//                   await _checkAppPlugin.requestNotificationPermission();
//                 },
//                 child: const Text("ENABLE Notification PERMISSION")),
//             ElevatedButton(
//                 onPressed: () async {
//                   await _checkAppPlugin.requestBackgroundPermission();
//                 },
//                 child: const Text("ENABLE Background PERMISSION")),
//             ElevatedButton(
//                 onPressed: () async {
//                   // final service = FlutterBackgroundService();
//                   // var isRunning = await service.isRunning();
//                   // if (isRunning) {
//                   //   service.invoke("stopService");
//                   // }
//                 },
//                 child: const Text("Stop Service"))
//           ],
//         )),
//       ),
//     );
//   }
// }
