import 'package:checkapp_plugin_example/features/create_block/cubit/cubit/block_cubit.dart';
import 'package:checkapp_plugin_example/shared/widgets/grey_container.dart';
import 'package:checkapp_plugin_example/shared/widgets/hover_ink_well.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

class ExistingBlocks extends StatelessWidget {
  const ExistingBlocks({
    super.key,
    required this.extra,
    required this.blockCubit,
    required this.blockType,
    required this.widgets,
  });
  final List<Widget> Function() widgets;
  final Map<String, dynamic> extra;
  final BlockCubit blockCubit;
  final String blockType;
  @override
  Widget build(BuildContext context) {
    return HoverInkWell(
      onTap: () => context.pushNamed('create-block', extra: extra),
      inkWellPadding: const EdgeInsets.all(8),
      child: GreyContainer(
        child: Column(
          children: [
            Row(
              children: [
                Text(
                  blockType,
                  style: const TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                      fontWeight: FontWeight.bold),
                ),
                const Spacer(),
                const Icon(Icons.navigate_next)
              ],
            ),
            const Gap(16),
            ...widgets()
          ],
        ),
      ),
    );
  }
}
