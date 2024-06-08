import 'package:checkapp_plugin/checkapp_plugin.dart';
import 'package:checkapp_plugin_example/shared/widgets/instruction.dart';
import 'package:flutter/material.dart';

CheckappPlugin _checkappPlugin = CheckappPlugin();

List<Widget> instructionList(
        {required bool isLocationEnabled,
        required bool isWifiEnabled,
        required isAboveAPI33}) =>
    [
      Container(
        margin: const EdgeInsets.only(bottom: 8.0),
        child: Instruction(
          instructionNumber: '1',
          instruction: const Text("Enable Location permission"),
          actionButton: ElevatedButton(
            onPressed: () async {
              await _checkappPlugin.requestLocationPermission();
            },
            child: const Text("Enable"),
          ),
        ),
      ),
      isAboveAPI33
          ? Container(
              margin: const EdgeInsets.only(bottom: 8.0),
              child: Instruction(
                instructionNumber: '2',
                instruction: const Text("Enable Wifi permission"),
                actionButton: ElevatedButton(
                  onPressed: () async {
                    await _checkappPlugin.requestWifiPermission();
                  },
                  child: const Text("Enable"),
                ),
              ),
            )
          : Container(),
    ];
