

import 'package:checkapp_plugin_example/features/create_schedule/models/schedule/schedule.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

@immutable
abstract class ScheduleState extends Equatable {
  const ScheduleState();

  @override
  List<Object> get props => [];
}

class SchedulesLoading extends ScheduleState {}

class SchedulesLoaded extends ScheduleState {
  final List<Schedule> schedules;

  const SchedulesLoaded({this.schedules = const <Schedule>[]});

  @override
  List<Object> get props => [schedules];
}

class ScheduleError extends ScheduleState {
  final String? message;
  const ScheduleError(this.message);
}

