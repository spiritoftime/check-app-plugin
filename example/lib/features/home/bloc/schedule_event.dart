
import 'package:checkapp_plugin_example/features/create_schedule/models/schedule/schedule.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';


@immutable
abstract class ScheduleEvent extends Equatable {
  const ScheduleEvent();

  @override
  List<Object> get props => [];
}


class LoadSchedules extends ScheduleEvent {

}

class UpdateSchedule extends ScheduleEvent {
final Schedule schedule;

  const UpdateSchedule(this.schedule );

  @override
  List<Object> get props => [schedule];
}
class AddSchedule extends ScheduleEvent{
  final Schedule schedule;

  const AddSchedule(this.schedule);

  @override
  List<Object> get props => [schedule];
}
class DeleteSchedule extends ScheduleEvent{
  final int scheduleId;
  const DeleteSchedule(this.scheduleId);
    @override
  List<Object> get props => [scheduleId];
}