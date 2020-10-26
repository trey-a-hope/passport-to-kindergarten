import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:p/models/UserModel.dart';

class VisitingLogLogsAddState extends Equatable {
  const VisitingLogLogsAddState();
  @override
  List<Object> get props => [];
}

class LoadingState extends VisitingLogLogsAddState {}

class LoadedState extends VisitingLogLogsAddState {
  final String title;
  final UserModel user;

  LoadedState({
    @required this.title,
    @required this.user,
  });

  @override
  List<Object> get props => [
        title,
        user,
      ];
}

class ErrorState extends VisitingLogLogsAddState {
  final dynamic error;

  ErrorState({
    @required this.error,
  });

  @override
  List<Object> get props => [
        error,
      ];
}
