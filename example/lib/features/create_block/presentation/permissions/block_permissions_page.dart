import 'package:checkapp_plugin/checkapp_plugin.dart';
import 'package:checkapp_plugin_example/features/create_block/presentation/permissions/widgets/number_permission.dart';
import 'package:checkapp_plugin_example/features/create_block/presentation/permissions/widgets/permission_explanation.dart';
import 'package:checkapp_plugin_example/features/create_block/presentation/utils.dart';
import 'package:checkapp_plugin_example/shared/widgets/lifecycle_handler.dart';

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

class BlockPermissionsPage extends StatefulWidget {
  final Map<String, dynamic> extra;

  const BlockPermissionsPage({super.key, required this.extra});

  @override
  State<BlockPermissionsPage> createState() => _BlockPermissionsPageState();
}

class _BlockPermissionsPageState extends State<BlockPermissionsPage> {
  List<bool> get blockPermissions => widget.extra['blockPermissions'];
  set blockPermissions(List<bool> value) =>
      widget.extra['blockPermissions'] = value;
  final CheckappPlugin checkappPlugin = CheckappPlugin();
    late final LifecycleEventHandler _lifecycleEventHandler;

  @override
  void initState() {
    super.initState();
    _lifecycleEventHandler  = LifecycleEventHandler(
        resumeCallBack: () async {
          List<bool> arePermissionsEnabled = await Future.wait([
            checkappPlugin.checkUsagePermission(),
            checkappPlugin.checkOverlayPermission(),
            checkappPlugin.checkNotificationPermission(),
            checkappPlugin.checkBackgroundPermission(),
          ]);
          setState(() {
            blockPermissions = arePermissionsEnabled;
          });
          if (mounted && arePermissionsEnabled.every((e) => e)) {
            context.goNamed('create-block', extra: widget.extra);
          }
        },
      );
    WidgetsBinding.instance.addObserver(
      _lifecycleEventHandler
    );
  }

  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance.removeObserver(
      _lifecycleEventHandler
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
                      NumberPermissions(blockPermissions: blockPermissions),
                      const Gap(16),
                      const Text(
                        "Please follow these instructions:",
                        style: TextStyle(color: Colors.grey, fontSize: 16.0),
                      ),
                      const Gap(8),
                      ListView(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        children:
                            instructionList(blockPermissions: blockPermissions)
                                .map((i) => i)
                                .toList(),
                      ),
                      const PermissionExplanation(),
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
