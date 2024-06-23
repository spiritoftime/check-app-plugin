import 'package:checkapp_plugin_example/features/create_block/cubit/cubit/block_cubit.dart';
import 'package:checkapp_plugin_example/features/create_block/models/partial_blocker/partial_blocker.dart';
import 'package:checkapp_plugin_example/features/create_block/presentation/widgets/custom_checkbox_group.dart';
import 'package:checkapp_plugin_example/features/create_block/presentation/widgets/partial_blocking_row.dart';
import 'package:flutter/material.dart';

class PartialBlockingScreen extends StatefulWidget {
  final BlockCubit blockCubit;

  const PartialBlockingScreen({super.key, required this.blockCubit});

  @override
  State<PartialBlockingScreen> createState() => _PartialBlockingScreenState();
}

class _PartialBlockingScreenState extends State<PartialBlockingScreen> {
  void _onPartialBlockingCheckBoxChanged(selectedValues) {
    widget.blockCubit.updateBlock(partialBlockers: selectedValues);
  }

  @override
  Widget build(BuildContext context) {
    List<PartialBlocker> partialBlockers = const [
      PartialBlocker(
          appName: "Youtube",
          feature: "Shorts",
          imagePath: 'assets/images/yt_logo.png', packageName: 'com.google.android.youtube'),

    ];

    return SingleChildScrollView(
      physics: const ScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomCheckboxGroup(
              onChanged: _onPartialBlockingCheckBoxChanged,
              name: 'partialblockers',
              items: partialBlockers,
              content: (partialBlocker) => PartialBlockingRow(
                    imageSize: 70,
                    partialBlocker: partialBlocker,
                    key: Key(partialBlocker.feature),
                  ),
              initialValue: widget.blockCubit.state.partialBlockers
                  .map((p) => PartialBlocker(
                      appName: p.appName,
                      feature: p.feature,
                      imagePath: p.imagePath,
                      packageName: p.packageName))
                  .toList())
        ],
      ),
    );
  }
}
