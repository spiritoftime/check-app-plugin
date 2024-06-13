part of 'schedule_bloc.dart';

@immutable
sealed class ScheduleState extends Equatable {
  const ScheduleState();

  @override
  List<Object> get props => [];
}

final class ScheduleInitial extends ScheduleState {}

class SchedulesLoading extends ScheduleState {}

class SchedulesLoaded extends ScheduleState {
  final List<Schedule> schedules;

  const SchedulesLoaded({this.schedules = const <Schedule>[]});
}

class ScheduleError extends ScheduleState {
  final String? message;
  const ScheduleError(this.message);
}
