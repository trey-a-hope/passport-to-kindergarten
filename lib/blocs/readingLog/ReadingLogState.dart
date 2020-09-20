import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:p/models/UserModel.dart';
import 'package:p/models/LogModel.dart';

class ReadingLogState extends Equatable {
  const ReadingLogState();
  @override
  List<Object> get props => [];
}

class LoadingState extends ReadingLogState {}

class LoadedState extends ReadingLogState {
  final UserModel user;
  final List<LogModel> readLogs;

  LoadedState({
    @required this.user,
    @required this.readLogs,
  });

  @override
  List<Object> get props => [
        user,
        readLogs,
      ];
}

class ErrorState extends ReadingLogState {
  final dynamic error;

  ErrorState({
    @required this.error,
  });

  @override
  List<Object> get props => [
        error,
      ];
}
