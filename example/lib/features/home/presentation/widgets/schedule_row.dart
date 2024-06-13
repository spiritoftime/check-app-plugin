import 'package:checkapp_plugin_example/features/create_schedule/models/schedule/schedule.dart';
import 'package:checkapp_plugin_example/features/create_schedule/widgets/icon_selection.dart';
import 'package:checkapp_plugin_example/shared/widgets/hover_ink_well.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';


class ScheduleRow extends StatelessWidget {
  final Schedule schedule;
  const ScheduleRow({
    super.key, required this.schedule,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin:
          const EdgeInsets.only(bottom: 8),
      child: HoverInkWell(
        onTap: () {},
        inkWellPadding:
            const EdgeInsets.all(0),
        borderColor: const Color(0xff21222D),
        child: Padding(
          padding: const EdgeInsets.symmetric(
              horizontal: 16.0),
          child: Row(
            children: [
              CircleAvatar(
                radius: 15,
                backgroundColor:
                    Colors.purple[100],
                child: Icon(
                    icons[schedule.scheduleDetails
                        .iconName],
                    size: 24,
                    color: Colors.blue),
              ),
              const Gap(16),
              Expanded(
                child: Text(
                  schedule.scheduleDetails
                      .scheduleName,
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16),
                ),
              ),
              ElevatedButton(
                style:
                    ElevatedButton.styleFrom(
                        splashFactory: NoSplash
                            .splashFactory,
                        elevation: 0,
                        padding:
                            const EdgeInsets
                                .all(0),
                        backgroundColor:
                            Colors
                                .transparent),
                onPressed: () {
                  // context.goNamed(
                  //     'create-block',
                  //     extra: <String,
                  //         dynamic>{
                  //       'schedule': s
                  //     });
                },
                child: const Text(
                  "...",
                  style: TextStyle(
                      color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

//  to demo routing
