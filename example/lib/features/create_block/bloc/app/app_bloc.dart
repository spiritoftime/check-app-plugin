import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:checkapp_plugin_example/features/create_block/bloc/app/app_event.dart';
import 'package:checkapp_plugin_example/features/create_block/bloc/app/app_state.dart';
import 'package:checkapp_plugin_example/features/create_block/repository/app_repository.dart';


class AppsBloc extends Bloc<AppEvent, AppsState> {
  final AppRepository _appRepository;

  AppsBloc(this._appRepository) : super(const AppsLoaded()) { // initializes state with AppsLoaded - empty list. AppsBloc(this._appRepository) means this.appRepository = _appRepository
    on<LoadApps>(_onLoadApp); // register events - on loadApp event call _onLoadApp
    // on<AddTask>(_onAddTask);
    // on<DeleteTask>(_onDeleteTask);
    // on<UpdateTask>(_onUpdateTask);
  }

  Future<void> _onLoadApp(LoadApps event, Emitter<AppsState> emit) async {
    emit(AppsLoading());
    try {
      final apps = await _appRepository.getApp();
      emit(AppsLoaded(apps: apps));
    } catch (e) {
      emit(AppsError(e.toString()));
      print(e.toString());
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