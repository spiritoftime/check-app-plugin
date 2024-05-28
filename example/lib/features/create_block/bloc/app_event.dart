
import 'package:checkapp_plugin_example/features/create_block/models/app.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';


@immutable
abstract class AppEvent extends Equatable {
  const AppEvent();

  @override
  List<Object> get props => [];
}

class GetApps extends AppEvent {}

class LoadApp extends AppEvent {
  final List<App> apps;

  const LoadApp({this.apps = const <App>[]});

  @override
  List<Object> get props => [apps];
}

// class AddTask extends TaskEvent {
//   final Task task;

//   const AddTask({required this.task});

//   @override
//   List<Object> get props => [task];
// }

// class UpdateTask extends TaskEvent {
//   final Task task;

//   const UpdateTask({required this.task});

//   @override
//   List<Object> get props => [task];
// }

// class DeleteTask extends TaskEvent {
//   final Task task;

//   const DeleteTask({required this.task});

//   @override
//   List<Object> get props => [task];
// }