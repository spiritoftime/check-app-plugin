
import 'package:checkapp_plugin_example/shared/widgets/grey_container.dart';
import 'package:checkapp_plugin_example/shared/widgets/hover_ink_well.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class AllDayTimingRow extends StatefulWidget {
  final bool isEnabled;
  final Function addTiming;
  final Function add24hTiming;
  const AllDayTimingRow({
    super.key,
    required this.addTiming,
    required this.add24hTiming,
    required this.isEnabled,
  });

  @override
  State<AllDayTimingRow> createState() => _AllDayTimingRowState();
}

class _AllDayTimingRowState extends State<AllDayTimingRow> {

  @override
  Widget build(BuildContext context) {

    return HoverInkWell(
      onTap: () {
        bool newState = !widget.isEnabled;

        if (newState) {
          widget.add24hTiming();
        } else {
          widget.addTiming();
        }
      },
      inkWellPadding: const EdgeInsets.all(0),
      child: GreyContainer(
        child: Row(
          children: [
            Icon(Icons.schedule,
                color: widget.isEnabled ? Colors.blue : Colors.grey, size: 30),
            const Gap(16),
            const Text(
              "All day long",
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
            const Spacer(),
            SizedBox(
              height: 30,
              child: FittedBox(
                fit: BoxFit.fill,
                child: Switch(
                    thumbColor: WidgetStateProperty.all(Colors.white),
                    activeColor: Colors.blue,
                    inactiveTrackColor: Colors.grey,
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    value: widget.isEnabled,
                    trackOutlineWidth: WidgetStateProperty.all(0),
                    onChanged: (bool isEnabled) {
                      if (isEnabled) {
                        widget.add24hTiming();
                      } else {
                        widget.addTiming();
                      }
                    }),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
