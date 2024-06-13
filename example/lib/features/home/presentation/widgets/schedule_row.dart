import 'package:checkapp_plugin_example/features/create_schedule/models/schedule/schedule.dart';
import 'package:checkapp_plugin_example/features/create_schedule/widgets/icon_selection.dart';
import 'package:checkapp_plugin_example/shared/widgets/dropdown_screen.dart';
import 'package:checkapp_plugin_example/shared/widgets/hover_ink_well.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class ScheduleRow extends StatelessWidget {
  final Schedule schedule;
  const ScheduleRow({
    super.key,
    required this.schedule,
  });
  static const List<String> dropdownValue = ['Toggle Active', 'Edit', 'Delete'];
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Row(
          children: [
            CircleAvatar(
              radius: 15,
              backgroundColor: Colors.purple[100],
              child: Icon(icons[schedule.scheduleDetails.iconName],
                  size: 24, color: Colors.blue),
            ),
            const Gap(16),
            Expanded(
              child: Text(
                schedule.scheduleDetails.scheduleName,
                style: const TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),
            SizedBox(
              height: 30,
              child: FittedBox(
                fit: BoxFit.fill,
                child: Switch(
                    thumbColor: WidgetStateProperty.all(Colors.white),
                    activeColor: Colors.blue,
                    inactiveTrackColor: Colors.grey,
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    value: schedule.scheduleDetails.isActive,
                    trackOutlineWidth: WidgetStateProperty.all(0),
                    onChanged: (bool isEnabled) {
                      // toggle active/ go to edit route/ go to delete route
                    }),
              ),
            ),
            const ActionButton()
            // Flexible(fit: FlexFit.loose, child: const ActionButton())
            // ElevatedButton(
            //   style: ElevatedButton.styleFrom(
            //       splashFactory: NoSplash.splashFactory,
            //       elevation: 0,
            //       padding: const EdgeInsets.all(0),
            //       backgroundColor: Colors.transparent),
            //   onPressed: () {
            //     // context.goNamed(
            //     //     'create-block',
            //     //     extra: <String,
            //     //         dynamic>{
            //     //       'schedule': s
            //     //     });
            //   },
            //   child: const Text(
            //     "...",
            //     style: TextStyle(color: Colors.white),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}

//  to demo routing
