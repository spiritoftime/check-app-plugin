


import 'package:checkapp_plugin_example/features/create_block/bloc/schedule/bloc/schedule_bloc.dart';
import 'package:checkapp_plugin_example/repository/database_repository/database_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SchedulesBloc extends Bloc<ScheduleEvent, ScheduleState> {
  final DatabaseRepository _databaseRepository;

  SchedulesBloc(this._databaseRepository) : super( SchedulesLoaded()) { 
    on<LoadSchedules>(_onLoadSchedule); 
    // on<AddTask>(_onAddTask);
    // on<DeleteTask>(_onDeleteTask);
    // on<UpdateTask>(_onUpdateTask);
  }

  Future<void> _onLoadSchedule(LoadSchedules event, Emitter<ScheduleState> emit) async {
    emit(SchedulesLoading());
    try {
      final schedules = await _databaseRepository.schedules();
      emit(SchedulesLoaded(schedules: schedules));
    } catch (e) {
    
      emit(ScheduleError(e.toString()));
    }
  }
  
  // void _onAddTask(AddTask event, Emitter<TasksState> emit) {
  //   final state = this.state;
  //   if (state is TasksLoaded) {
  //     emit(TasksLoaded(tasks: List.from(state.tasks)..add(event.task)));
  //   }
  // }

  // void _onDeleteTask(DeleteTask event, Emitter<TasksState> emit) {
  //   final state = this.state;
  //   if (state is TasksLoaded) {
  //     List<Task> tasks = state.tasks.where((task) {
  //       return task.id != event.task.id;
  //     }).toList();
  //     emit(TasksLoaded(tasks: tasks));
  //   }
  // }

  // void _onUpdateTask(UpdateTask event, Emitter<TasksState> emit) {
  //   final state = this.state;
  //   if (state is TasksLoaded) {
  //     List<Task> tasks = (state.tasks.map((task) {
  //       return task.id == event.task.id ? event.task : task;
  //     })).toList();
  //     emit(TasksLoaded(tasks: tasks));
  //   }
  // }
}