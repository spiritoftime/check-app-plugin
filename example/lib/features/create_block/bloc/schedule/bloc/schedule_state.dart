part of 'schedule_bloc.dart';

@immutable
sealed class ScheduleState {}

final class ScheduleInitial extends ScheduleState {}
class ScheduleLoading extends ScheduleState {}

class ScheduleLoaded extends ScheduleState {
  final List<Schedule> Schedules;

   ScheduleLoaded({this.Schedules = const <Schedule>[]});

  @override
  List<Object> get props => [Schedule];
}

class ScheduleError extends ScheduleState {
  final String? message;
   ScheduleError(this.message);
}