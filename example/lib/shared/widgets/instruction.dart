import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class Instruction extends StatelessWidget {
  final String instructionNumber;
  final Text instruction;
  const Instruction({
    super.key,
    required this.instructionNumber,
    required this.instruction,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          decoration:
              const BoxDecoration(shape: BoxShape.circle, color: Colors.blue),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(instructionNumber),
          ),
        ),
        const Gap(16),
        instruction
      ],
    );
  }
}
