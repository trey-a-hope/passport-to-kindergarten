import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:p/models/ChildLogModel.dart';
import 'package:p/models/UserModel.dart';

class VisitingLogVisitsState extends Equatable {
  const VisitingLogVisitsState();
  @override
  List<Object> get props => [];
}

class LoadingState extends VisitingLogVisitsState {}

class LoadedState extends VisitingLogVisitsState {
  final UserModel user;
  final List<ChildLogModel> logs;

  LoadedState({
    @required this.user,
    @required this.logs,
  });

  @override
  List<Object> get props => [
        user,
        logs,
      ];
}

class ErrorState extends VisitingLogVisitsState {
  final dynamic error;

  ErrorState({
    @required this.error,
  });

  @override
  List<Object> get props => [
        error,
      ];
}