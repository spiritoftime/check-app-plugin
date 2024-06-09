
import 'package:checkapp_plugin_example/shared/widgets/accordion_wrapper.dart';
import 'package:checkapp_plugin_example/shared/widgets/instruction.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class PermissionExplanation extends StatelessWidget {
  const PermissionExplanation({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return AccordionWrapper(
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
    );
  }
}
