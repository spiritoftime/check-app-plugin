import 'package:bloc/bloc.dart';
import 'package:checkapp_plugin_example/features/create_time/models/day/day.dart';
import 'package:checkapp_plugin_example/features/create_time/models/time/time.dart';
import 'package:checkapp_plugin_example/features/create_time/models/timing/timing.dart';
import 'package:meta/meta.dart';


class TimeCubit extends Cubit<Time> {
  TimeCubit() : super(Time(days: [], timings: []));
    void updateTime(
      {List<Day>? days, List<Timing>? timings, }) {
    emit(state.copyWith(days: days, timings: timings));
  }
}
