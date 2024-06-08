import 'package:checkapp_plugin_example/features/create_block/presentation/utils.dart';
import 'package:checkapp_plugin_example/shared/widgets/accordion_wrapper.dart';
import 'package:checkapp_plugin_example/shared/widgets/instruction.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

class BlockPermissionsPage extends StatelessWidget {
  final Map<String, dynamic> extra;

  const BlockPermissionsPage({super.key, required this.extra});
  List<bool> get blockPermissions => extra['blockPermissions'];

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
                        children: instructionList.map((i) => i).toList(),
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
                                      "Usage Permission is required to monitor your app usage"),
                                )),
                            Container(
                              margin: const EdgeInsets.only(bottom: 8),
                              child: const Instruction(
                                instructionNumber: '2',
                                instruction: Text(
                                    "Overlay permission is needed to display the overlay when we exit a forbidden app"),
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.only(bottom: 8),
                              child: const Instruction(
                                instructionNumber: '3',
                                instruction: Text(
                                    "Notification permission is needed to prompt you to enable needed settings (eg. gps for location tracking) or to notify you that Doomscroll is running in the foreground."),
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.only(bottom: 8),
                              child: const Instruction(
                                instructionNumber: '4',
                                instruction: Text(
                                    "Background permission is needed to actually be able to run this app in the background to check if forbidden apps are running based on your schedule."),
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

class NumberPermissions extends StatelessWidget {
  const NumberPermissions({
    super.key,
    required this.blockPermissions,
  });

  final List<bool> blockPermissions;

  @override
  Widget build(BuildContext context) {
    return Text(
      "${blockPermissions.length} Permission${blockPermissions.length > 1 ? 's' : ''} Missing",
      style: const TextStyle(
          color: Colors.red, fontWeight: FontWeight.bold, fontSize: 30.0),
    );
  }
}
