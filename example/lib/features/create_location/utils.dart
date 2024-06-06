import 'package:checkapp_plugin_example/shared/widgets/instruction.dart';
import 'package:flutter/material.dart';

List<Widget> instructionList = [
  Container(
    margin: const EdgeInsets.only(bottom: 8.0),
    child: const Instruction(
      instructionNumber: '1',
      instruction: Text("Tap the permissions button below"),
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
];
