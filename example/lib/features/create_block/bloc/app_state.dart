

import 'package:checkapp_plugin_example/features/create_block/models/app.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

@immutable
abstract class AppsState extends Equatable {
  const AppsState();

  @override
  List<Object> get props => [];
}

class AppsLoading extends AppsState {}

class AppsLoaded extends AppsState {
  final List<App> apps;

  const AppsLoaded({this.apps = const <App>[]});

  @override
  List<Object> get props => [apps];
}

class AppsError extends AppsState {
  final String? message;
  const AppsError(this.message);
}