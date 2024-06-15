import 'package:checkapp_plugin_example/features/create_schedule/models/schedule/schedule.dart';
import 'package:checkapp_plugin_example/features/home/bloc/schedule_event.dart';
import 'package:checkapp_plugin_example/features/home/bloc/schedule_state.dart';
import 'package:checkapp_plugin_example/repository/database_repository/database_repository.dart';
import 'package:checkapp_plugin_example/shared/helper_functions/helper_functions.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SchedulesBloc extends Bloc<ScheduleEvent, ScheduleState> {
  final DatabaseRepository _databaseRepository;

  SchedulesBloc(this._databaseRepository) : super(const SchedulesLoaded()) {
    on<LoadSchedules>(_onLoadSchedule);
    on<AddSchedule>(_onAddSchedule);
    on<DeleteSchedule>(_onDeleteSchedule);
    // on<DeleteTask>(_onDeleteTask);
    on<UpdateSchedule>(_onUpdateSchedule);
  }

  Future<void> _onLoadSchedule(
      LoadSchedules event, Emitter<ScheduleState> emit) async {
    emit(SchedulesLoading());
    try {
      final schedules = await _databaseRepository.schedules();
      emit(SchedulesLoaded(schedules: schedules));
    } catch (e) {
      emit(ScheduleError(e.toString()));
    }
  }

  void _onUpdateSchedule(
      UpdateSchedule event, Emitter<ScheduleState> emit) async {
    try {
      await DatabaseRepository().updateSchedule(s: event.schedule);
    } catch (e) {
      emit(ScheduleError(e.toString()));
    }
  }
}

void _onAddSchedule(AddSchedule event, Emitter<ScheduleState> emit) async {
  try {
    await DatabaseRepository().insertSchedule(event.schedule);
  } catch (e) {
    emit(ScheduleError(e.toString()));
  }
}

void _onDeleteSchedule(
    DeleteSchedule event, Emitter<ScheduleState> emit) async {
  try {
    await DatabaseRepository().deleteSchedule(
      scheduleId: event.scheduleId,
    );
  } catch (e) {
    emit(ScheduleError(e.toString()));
  }
}

  // void _onUpdateTask(UpdateTask event, Emitter<TasksState> emit) {
  //   final state = this.state;
  //   if (state is TasksLoaded) {
  //     List<Task> tasks = (state.tasks.map((task) {
  //       return task.id == event.task.id ? event.task : task;
  //     })).toList();
  //     emit(TasksLoaded(tasks: tasks));
  //   }
  // }
