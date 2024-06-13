

import 'package:checkapp_plugin_example/features/create_block/models/app/app.dart';
import 'package:checkapp_plugin_example/features/create_schedule/models/schedule/schedule.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

@immutable
abstract class ScheduleState extends Equatable {
  const ScheduleState();

  @override
  List<Object> get props => [];
}

class ScheduleLoading extends ScheduleState {}

class ScheduleLoaded extends ScheduleState {
  final List<Schedule> schedules;

  const ScheduleLoaded({this.schedules = const <Schedule>[]});

  @override
  List<Object> get props => [schedules];
}

class ScheduleError extends ScheduleState {
  final String? message;
  const ScheduleError(this.message);
}