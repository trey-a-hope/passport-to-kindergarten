import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:p/models/ChildLogModel.dart';
import 'package:p/models/ParentLogModel.dart';
import 'package:p/models/UserModel.dart';
import 'package:p/models/LogModel.dart';

class ReadingLogLogsState extends Equatable {
  const ReadingLogLogsState();
  @override
  List<Object> get props => [];
}

class LoadingState extends ReadingLogLogsState {}

class LoadedState extends ReadingLogLogsState {
  final UserModel user;
  final List<ChildLogModel> logs;
  final ParentLogModel book;
  LoadedState({
    @required this.user,
    @required this.logs,
    @required this.book,
  });

  @override
  List<Object> get props => [
        user,
        logs,
        book,
      ];
}

class ErrorState extends ReadingLogLogsState {
  final dynamic error;

  ErrorState({
    @required this.error,
  });

  @override
  List<Object> get props => [
        error,
      ];
}
