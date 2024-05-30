part of 'schedule_bloc.dart';

@immutable
sealed class ScheduleEvent extends Equatable {
  const ScheduleEvent();

  @override
  List<Object> get props => [];
}

class AddSchedule extends ScheduleEvent {
  final Schedule schedule;

  const AddSchedule({required this.schedule});

  @override
  List<Object> get props => [Schedule];
}

class LoadSchedules extends ScheduleEvent {}
