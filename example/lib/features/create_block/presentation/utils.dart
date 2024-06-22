import 'package:checkapp_plugin_example/shared/widgets/instruction.dart';
import 'package:flutter/material.dart';
import 'package:checkapp_plugin/checkapp_plugin.dart';

CheckappPlugin _checkappPlugin = CheckappPlugin();
List<Widget> accessibilityInstructionlist({required List<bool> accessibilityPermissions})=>[
        Container(
        margin: const EdgeInsets.only(bottom: 8.0),
        child: Instruction(
          instructionNumber: '1',
          instruction: const Text("Enable accessibility permission"),
          actionButton: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: !accessibilityPermissions[0] ? Colors.blue : Colors.grey,
            ),
            onPressed: () async {
              await _checkappPlugin.requestAccessibilityPermission();
            },
            child:  Text("Enable",
                style: TextStyle(
                    color:
                        accessibilityPermissions[0] ? Colors.white70 : Colors.white),),
          ),
        ),
      ),
];

List<Widget> blockInstructionList({required List<bool> blockPermissions}) => [
      Container(
        margin: const EdgeInsets.only(bottom: 8.0),
        child: Instruction(
          instructionNumber: '1',
          instruction: const Text("Enable Usage permission"),
          actionButton: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: !blockPermissions[0] ? Colors.blue : Colors.grey,
            ),
            onPressed: () async {
              await _checkappPlugin.requestUsagePermission();
            },
            child:  Text("Enable",
                style: TextStyle(
                    color:
                        blockPermissions[0] ? Colors.white70 : Colors.white),),
          ),
        ),
      ),
      Container(
        margin: const EdgeInsets.only(bottom: 8.0),
        child: Instruction(
          instructionNumber: '2',
          instruction: const Text("Enable Overlay Permission"),
          actionButton: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: !blockPermissions[1] ? Colors.blue : Colors.grey,
            ),
            onPressed: () async {
              await _checkappPlugin.requestOverlayPermission();
            },
            child:  Text("Enable", style: TextStyle(color: blockPermissions[1] ? Colors.white70 : Colors.white)),
          ),
        ),
      ),
      Container(
        margin: const EdgeInsets.only(bottom: 8.0),
        child: Instruction(
          instructionNumber: '3',
          instruction: const Text("Enable Notification Permission"),
          actionButton: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: !blockPermissions[2] ? Colors.blue : Colors.grey,
            ),
            onPressed: () async {
              await _checkappPlugin.requestNotificationPermission();
            },
            child:  Text("Enable", style: TextStyle(color: blockPermissions[2] ? Colors.white70 : Colors.white)),
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
            style: ElevatedButton.styleFrom(
              backgroundColor: !blockPermissions[3] ? Colors.blue : Colors.grey,
            ),
            onPressed: () async {
              await _checkappPlugin.requestBackgroundPermission();
            },
            child:  Text("Enable", style: TextStyle(color:blockPermissions[3] ? Colors.white70 : Colors.white)),
          ),
        ),
      ),
    ];
