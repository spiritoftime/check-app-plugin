import 'package:checkapp_plugin_example/features/create_block/models/partial_blocker/partial_blocker.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class PartialBlockingRow extends StatelessWidget {
final PartialBlocker partialBlocker;
final double imageSize;
  const PartialBlockingRow({super.key, required this.partialBlocker, required this.imageSize});

  @override
  Widget build(BuildContext context) {
    return   Padding(
      padding: const EdgeInsets.symmetric(horizontal:8.0,vertical: 2.0),
      child: Row(
        children: [
         Image.asset(
            partialBlocker.imagePath,
            width: imageSize,
            height: imageSize,
          ),
          const Gap(12),
          Expanded(
            child: Text(
              partialBlocker.feature,
              softWrap: true,
              maxLines: 3,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }
}