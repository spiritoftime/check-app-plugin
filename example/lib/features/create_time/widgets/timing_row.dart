import 'package:checkapp_plugin_example/shared/widgets/grey_container.dart';
import 'package:checkapp_plugin_example/shared/widgets/hover_ink_well.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class TimingRow extends StatefulWidget {
  const TimingRow({super.key});

  @override
  State<TimingRow> createState() => _TimingRowState();
}

class _TimingRowState extends State<TimingRow> {
  final String _timing = "5:00pm - 7:00pm";
  @override
  Widget build(BuildContext context) {
    return HoverInkWell(
      inkWellPadding: const EdgeInsets.all(0),
      onTap: () {}, // open the timing picker
      child: GreyContainer(
        // height: 64,
        child: Row(
          children: [
            const Icon(Icons.schedule, color: Colors.grey, size: 24),
            const Gap(16),
            Text(
              _timing,
              style: const TextStyle(color: Colors.white, fontSize: 16),
            ),
            const Spacer(),
            const Icon(Icons.close, color: Colors.blue, size: 24),
          ],
        ),
      ),
    );
  }
}
