import 'package:checkapp_plugin/checkapp_plugin.dart';
import 'package:checkapp_plugin_example/features/create_block/cubit/cubit/block_cubit.dart';
import 'package:checkapp_plugin_example/features/create_block/presentation/permissions/widgets/number_permission.dart';
import 'package:checkapp_plugin_example/features/create_block/presentation/permissions/widgets/permission_explanation.dart';
import 'package:checkapp_plugin_example/features/create_block/presentation/utils.dart';
import 'package:checkapp_plugin_example/router/route_names.dart';
import 'package:checkapp_plugin_example/shared/widgets/lifecycle_handler.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

class AccessibilityPermissionsPage extends StatefulWidget {
  final Map<String, dynamic> extra;

  const AccessibilityPermissionsPage({super.key, required this.extra});

  @override
  State<AccessibilityPermissionsPage> createState() =>
      _AccessibilityPermissionsPageState();
}

class _AccessibilityPermissionsPageState
    extends State<AccessibilityPermissionsPage> {
  List<bool> get accessibilityPermissions =>
      widget.extra['accessibilityPermissions'];
  set accessibilityPermissions(List<bool> value) =>
      widget.extra['accessibilityPermissions'] = value;
  final CheckappPlugin checkappPlugin = CheckappPlugin();
  late final LifecycleEventHandler _lifecycleEventHandler;
  late BlockCubit blockCubit;

  @override
  void initState() {
    super.initState();
    blockCubit = widget.extra['blockCubit'] ?? BlockCubit();

    _lifecycleEventHandler = LifecycleEventHandler(
      resumeCallBack: () async {
        List<bool> arePermissionsEnabled = await Future.wait([
          checkappPlugin.checkAccessibilityPermission(),
          checkappPlugin.checkBatteryOptimizationDisabled(),
        ]);
        setState(() {
          accessibilityPermissions = arePermissionsEnabled;
        });
        if (mounted && arePermissionsEnabled.every((e) => e)) {
          if (widget.extra.containsKey('blockCubit')) {
            context.goNamed(RouteNames.confirmSchedule,
                extra: {...widget.extra, 'blockCubit': blockCubit});
          } else {
            context.goNamed(RouteNames.createBlockingConditions,
                extra: {...widget.extra, 'blockCubit': blockCubit});
          }
        }
      },
    );
    WidgetsBinding.instance.addObserver(_lifecycleEventHandler);
  }

  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance.removeObserver(_lifecycleEventHandler);
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
                      NumberPermissions(
                          blockPermissions: accessibilityPermissions),
                      const Gap(16),
                      const Text(
                        "Please follow these instructions:",
                        style: TextStyle(color: Colors.grey, fontSize: 16.0),
                      ),
                      const Gap(8),
                      ListView(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        children: accessibilityInstructionlist(
                                accessibilityPermissions:
                                    accessibilityPermissions)
                            .map((i) => i)
                            .toList(),
                      ),
                      const PermissionExplanation(
                        permissions: [
                          "Battery Optimization may prevent accessibility service from working properly",
                          "An accessibility service is needed to detect the url you type in your browsers, as well as to detect whether a YT short is opened",
                        ],
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
