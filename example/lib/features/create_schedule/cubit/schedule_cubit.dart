import 'package:checkapp_plugin_example/features/create_block/models/block/block.dart';
import 'package:checkapp_plugin_example/features/create_schedule/models/schedule/schedule.dart';
import 'package:checkapp_plugin_example/features/create_schedule/models/schedule_details/schedule_details.dart';
import 'package:checkapp_plugin_example/features/create_time/models/time/time.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

class ScheduleCubit extends Cubit<Schedule> {
  ScheduleCubit({Schedule? initialSchedule})
      : super(initialSchedule ??
            Schedule(
                wifi: [],
                location: [],
                scheduleDetails: ScheduleDetails(
                    isActive: false, scheduleName: '', iconName: ''),
                block: Block(
                    apps: [], websites: [], keywords: [], partialBlockers: []),
                time: Time(days: [], timings: [])));
  void update({required Schedule s}) {
    emit(s);
  }
}
