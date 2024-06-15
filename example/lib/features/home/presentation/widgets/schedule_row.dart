import 'package:checkapp_plugin_example/features/create_schedule/models/schedule/schedule.dart';
import 'package:checkapp_plugin_example/features/create_schedule/widgets/icon_selection.dart';
import 'package:checkapp_plugin_example/repository/database_repository/database_repository.dart';
import 'package:checkapp_plugin_example/features/home/presentation/widgets/action_button.dart';
import 'package:checkapp_plugin_example/shared/widgets/hover_ink_well.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class ScheduleRow extends StatefulWidget {
  final Schedule schedule;
  const ScheduleRow({
    super.key,
    required this.schedule,
  });
  static const List<String> dropdownValue = ['Toggle Active', 'Edit', 'Delete'];

  @override
  State<ScheduleRow> createState() => _ScheduleRowState();
}

class _ScheduleRowState extends State<ScheduleRow> {
  late bool _isEnabled;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _isEnabled = widget.schedule.scheduleDetails.isActive;
  }

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
              child: Icon(icons[widget.schedule.scheduleDetails.iconName],
                  size: 24, color: Colors.blue),
            ),
            const Gap(16),
            Expanded(
              child: Text(
                widget.schedule.scheduleDetails.scheduleName,
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
                    value: _isEnabled,
                    trackOutlineWidth: WidgetStateProperty.all(0),
                    onChanged: (bool isEnabled) {
                      // toggle active/ go to edit route/ go to delete route
                      setState(() {
                        _isEnabled = isEnabled;
                      });
                      DatabaseRepository().updateSchedule(data: {
                        'id': widget.schedule.id,
                        'isActive': isEnabled ? 1 : 0
                      }, tableName: 'schedules', model: widget.schedule);
                    }),
              ),
            ),
            ActionButton(
              s: widget.schedule,
            )
          ],
        ),
      ),
    );
  }
}

//  to demo routing
