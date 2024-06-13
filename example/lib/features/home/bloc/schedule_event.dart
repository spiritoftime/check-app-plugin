
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