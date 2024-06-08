import 'package:checkapp_plugin_example/shared/widgets/instruction.dart';
import 'package:flutter/material.dart';
import 'package:checkapp_plugin/checkapp_plugin.dart';

CheckappPlugin _checkappPlugin = CheckappPlugin();
List<Widget> instructionList = [
  Container(
    margin: const EdgeInsets.only(bottom: 8.0),
    child:  Instruction(
      instructionNumber: '1',
      instruction: const Text("Enable Usage permission"),
      actionButton: ElevatedButton(
                onPressed: () async {
                  await _checkappPlugin.requestUsagePermission();
                },
                child: const Text("ENABLE Usage PERMISSION")),
    ),
  ),
  Container(
    margin: const EdgeInsets.only(bottom: 8.0),
    child: const Instruction(
      instructionNumber: '2',
      instruction: Text("Click App Permissions"),
    ),
  ),
  Container(
    margin: const EdgeInsets.only(bottom: 8.0),
    child: const Instruction(
      instructionNumber: '3',
      instruction: Text("Click Location Permission"),
    ),
  ),
  Container(
    margin: const EdgeInsets.only(bottom: 8.0),
    child: const Instruction(
      instructionNumber: '4',
      instruction: Text("Click enable all the time"),
    ),
  ),
  Container(
    margin: const EdgeInsets.only(bottom: 8.0),
    child: const Instruction(
      instructionNumber: '5',
      instruction: Text(
        "Note: Should you enable a schedule with location, you will have to enable GPS constantly",
        softWrap: true,
      ),
    ),
  ),
];
