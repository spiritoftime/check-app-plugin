
import 'package:checkapp_plugin_example/shared/widgets/accordion_wrapper.dart';
import 'package:checkapp_plugin_example/shared/widgets/instruction.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class PermissionExplanation extends StatelessWidget {
  final List<String> permissions;

  const PermissionExplanation({
    super.key,
    required this.permissions,
  });

  @override
  Widget build(BuildContext context) {
    return AccordionWrapper(
      header: const Row(
        children: [
          Icon(Icons.help, color: Colors.blue, size: 24),
          SizedBox(width: 16),
          Text("Why do I need to do so?"),
        ],
      ),
      content: Column(
        children: permissions.map((permission) {
          return Container(
            margin: const EdgeInsets.only(bottom: 8),
            child: Instruction(
              instructionNumber: '${permissions.indexOf(permission) + 1}',
              instruction: Text(permission),
            ),
          );
        }).toList(),
      ),
    );
  }
}