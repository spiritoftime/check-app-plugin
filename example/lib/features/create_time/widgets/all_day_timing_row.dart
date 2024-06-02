import 'package:checkapp_plugin_example/shared/widgets/grey_container.dart';
import 'package:checkapp_plugin_example/shared/widgets/hover_ink_well.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class AllDayTimingRow extends StatefulWidget {
  const AllDayTimingRow({super.key});

  @override
  State<AllDayTimingRow> createState() => _AllDayTimingRowState();
}

class _AllDayTimingRowState extends State<AllDayTimingRow> {
  bool _isEnabled = false;
  @override
  Widget build(BuildContext context) {
    return HoverInkWell(
      onTap: () {
        setState(() {
          _isEnabled = !_isEnabled;
        });
      },
      inkWellPadding: const EdgeInsets.all(0),
      child: GreyContainer(
        child: Row(
          children: [
            const Icon(Icons.schedule, color: Colors.grey, size: 30),
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
                    value: _isEnabled,
                    trackOutlineWidth: WidgetStateProperty.all(0),
                    onChanged: (bool isEnabled) {}),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
