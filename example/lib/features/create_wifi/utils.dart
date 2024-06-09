import 'package:checkapp_plugin/checkapp_plugin.dart';
import 'package:checkapp_plugin_example/shared/widgets/instruction.dart';
import 'package:flutter/material.dart';

CheckappPlugin _checkappPlugin = CheckappPlugin();

List<Widget> instructionList({required wifiPermissions}) => [
      Container(
        margin: const EdgeInsets.only(bottom: 8.0),
        child: Instruction(
          instructionNumber: '1',
          instruction: const Text("Enable Location permission"),
          actionButton: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: !wifiPermissions[1] ? Colors.blue : Colors.grey,
            ),
            onPressed: () async {
              await _checkappPlugin.requestLocationPermission();
            },
            child: const Text("Enable", style: TextStyle(color: Colors.white)),
          ),
        ),
      ),
      Container(
        margin: const EdgeInsets.only(bottom: 8.0),
        child: Instruction(
          instructionNumber: '2',
          instruction: const Text("Enable Location Services"),
          actionButton: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: !wifiPermissions[0] ? Colors.blue : Colors.grey,
            ),
            onPressed: () async {
              await _checkappPlugin.requestEnableGPS();
            },
            child: const Text("Enable", style: TextStyle(color: Colors.white)),
          ),
        ),
      )
    ];
