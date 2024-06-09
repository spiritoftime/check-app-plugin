import 'package:checkapp_plugin/checkapp_plugin.dart';
import 'package:checkapp_plugin_example/features/create_block/presentation/pages/block_permissions_page.dart';
import 'package:checkapp_plugin_example/features/create_wifi/utils.dart';
import 'package:checkapp_plugin_example/shared/widgets/accordion_wrapper.dart';
import 'package:checkapp_plugin_example/shared/widgets/instruction.dart';
import 'package:checkapp_plugin_example/shared/widgets/lifecycle_handler.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

class WifiPermissionPage extends StatefulWidget {
  final Map<String, dynamic> extra;

  const WifiPermissionPage({super.key, required this.extra});

  @override
  State<WifiPermissionPage> createState() => _WifiPermissionPageState();
}

class _WifiPermissionPageState extends State<WifiPermissionPage> {
  List<bool> get wifiPermissions => widget.extra['wifiPermissionsEnabled'];
  final _checkappPlugin = CheckappPlugin();
  set wifiPermissions(List<bool> value) =>
      widget.extra['wifiPermissionsEnabled'] = value;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(
      LifecycleEventHandler(
        resumeCallBack: () async {
          List<bool> wifiPermissionsEnabled = await Future.wait([
            _checkappPlugin.checkGPSEnabled(),
            _checkappPlugin.checkLocationPermission()
          ]);
          setState(() {
            wifiPermissions = wifiPermissionsEnabled;
          });
          if (mounted &&
              wifiPermissionsEnabled.first &&
              wifiPermissionsEnabled[1]) {
            context.goNamed('create-wifi', extra: widget.extra);
          }
        },
      ),
    );
  }

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
                        children:
                            instructionList(wifiPermissions: wifiPermissions)
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
                                    "Location Permission and GPS is needed to grab nearby wifi."),
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
