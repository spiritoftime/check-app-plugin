import 'package:checkapp_plugin_example/shared/widgets/instruction.dart';
import 'package:flutter/material.dart';
import 'package:checkapp_plugin/checkapp_plugin.dart';

CheckappPlugin _checkappPlugin = CheckappPlugin();
List<Widget> instructionList = [
  Container(
    margin: const EdgeInsets.only(bottom: 8.0),
    child: Instruction(
      instructionNumber: '1',
      instruction: const Text("Enable Usage permission"),
      actionButton: ElevatedButton(
        onPressed: () async {
          await _checkappPlugin.requestUsagePermission();
        },
        child: const Text("Enable"),
      ),
    ),
  ),
  Container(
    margin: const EdgeInsets.only(bottom: 8.0),
    child: Instruction(
      instructionNumber: '2',
      instruction: const Text("Enable Overlay Permission"),
      actionButton: ElevatedButton(
        onPressed: () async {
          await _checkappPlugin.requestOverlayPermission();
        },
        child: const Text("Enable"),
      ),
    ),
  ),
  Container(
    margin: const EdgeInsets.only(bottom: 8.0),
    child: Instruction(
      instructionNumber: '3',
      instruction: const Text("Enable Notification Permission"),
      actionButton: ElevatedButton(
        onPressed: () async {
          await _checkappPlugin.requestNotificationPermission();
        },
        child: const Text("Enable"),
      ),
    ),
  ),
  Container(
    margin: const EdgeInsets.only(bottom: 8.0),
    child: Instruction(
      instructionNumber: '4',
      instruction: const Text(
          "Enable Open new windows while running in the background Permission"),
      actionButton: ElevatedButton(
        onPressed: () async {
          await _checkappPlugin.requestBackgroundPermission();
        },
        child: const Text("Enable"),
      ),
    ),
  ),
];
