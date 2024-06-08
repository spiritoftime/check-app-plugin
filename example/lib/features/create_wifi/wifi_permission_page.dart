import 'package:checkapp_plugin/checkapp_plugin.dart';
import 'package:checkapp_plugin_example/features/create_block/presentation/pages/block_permissions_page.dart';
import 'package:checkapp_plugin_example/features/create_wifi/utils.dart';
import 'package:checkapp_plugin_example/shared/widgets/accordion_wrapper.dart';
import 'package:checkapp_plugin_example/shared/widgets/instruction.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

class WifiPermissionPage extends StatelessWidget {
  // final _checkappPlugin = CheckappPlugin();
  final Map<String, dynamic> extra;

  const WifiPermissionPage({super.key, required this.extra});
  List<bool> get wifiPermissions => extra['wifiPermissionsEnabled'];

  // List<bool> wifiPermissionsEnabled =wifiPermissions?? [];

  // Future<List<bool>> checkWifiPermissions() async {
  //   wifiPermissionsEnabled = await Future.wait([
  //     _checkappPlugin.checkWifiPermission(),
  //     _checkappPlugin.checkAboveAPI33(),
  //     _checkappPlugin.checkLocationPermission()
  //   ]);
  //   return wifiPermissionsEnabled;
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      IconButton(
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                        style: const ButtonStyle(
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        onPressed: () => context.pop(),
                        icon: const Icon(Icons.arrow_back,
                            color: Colors.blue, size: 24),
                      ),
                      const Gap(16),
                      const Center(
                          child: Icon(Icons.settings,
                              size: 200, color: Colors.yellow)),
                      const Gap(16),
                      NumberPermissions(blockPermissions: wifiPermissions),
                      const Gap(16),
                      const Text(
                        "Please follow these instructions:",
                        style: TextStyle(color: Colors.grey, fontSize: 16.0),
                      ),
                      ListView(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        children: instructionList(
                                isLocationEnabled: wifiPermissions[2],
                                isWifiEnabled: wifiPermissions.first,
                                isAboveAPI33: wifiPermissions[1])
                            .map((i) => i)
                            .toList(),
                      ),
                      AccordionWrapper(
                        header: const Row(
                          children: [
                            Icon(Icons.quiz, color: Colors.blue, size: 24),
                            Gap(16),
                            Text("Why do i need to do so?")
                          ],
                        ),
                        content: Column(
                          children: [
                            Container(
                                margin: const EdgeInsets.only(bottom: 8),
                                child: const Instruction(
                                  instructionNumber: '1',
                                  instruction: Text(
                                      "Location Permission is needed to grab nearby wifi. However, you do not need to enable GPS for this to work."),
                                )),
                            Container(
                              margin: const EdgeInsets.only(bottom: 8),
                              child: const Instruction(
                                instructionNumber: '2',
                                instruction: Text(
                                    "Latest Android Versions require us to request for wifi permission"),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
