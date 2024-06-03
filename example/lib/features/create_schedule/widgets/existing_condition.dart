import 'package:checkapp_plugin_example/features/create_time/cubit/cubit/time_cubit.dart';
import 'package:checkapp_plugin_example/shared/widgets/grey_container.dart';
import 'package:checkapp_plugin_example/shared/widgets/hover_ink_well.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class ExistingCondition extends StatelessWidget {
  const ExistingCondition({
    super.key,
    required this.extra,
    required this.timeCubit,
    required this.conditionType,
    required this.onTap,
    required this.text1,
    required this.text2,
  });
  final String conditionType;
  final Map<String, dynamic> extra;
  final TimeCubit timeCubit;
  final Function() onTap;
  final String text1;
  final String text2;
  @override
  Widget build(BuildContext context) {
    return HoverInkWell(
      onTap: onTap,
      inkWellPadding: const EdgeInsets.all(0),
      child: GreyContainer(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Icon(Icons.schedule, color: Colors.blue, size: 24),
            const Gap(16),
            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(conditionType,
                      style: const TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                          fontWeight: FontWeight.bold)),
                  const Gap(4),
                  Text(
                    text1,
                    softWrap: true,
                  ),
                  const Gap(4),
                  Text(text2)
                ],
              ),
            ),
            const Icon(Icons.close, size: 24, color: Colors.grey),
          ],
        ),
      ),
    );
  }
}
