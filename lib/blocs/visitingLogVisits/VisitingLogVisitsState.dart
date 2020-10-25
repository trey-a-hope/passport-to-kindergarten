import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:p/models/ParentLogModel.dart';
import 'package:p/models/UserModel.dart';
import 'package:p/models/LogModel.dart';

class VisitingLogVisitsState extends Equatable {
  const VisitingLogVisitsState();
  @override
  List<Object> get props => [];
}

class LoadingState extends VisitingLogVisitsState {}

class LoadedState extends VisitingLogVisitsState {
  final UserModel user;
  final List<ParentLogModel> visitLogs;

  LoadedState({
    @required this.user,
    @required this.visitLogs,
  });

  @override
  List<Object> get props => [
        user,
        visitLogs,
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
