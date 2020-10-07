import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:p/models/ChildLogModel.dart';
import 'package:p/models/ParentLogModel.dart';

class ReadingLogLogsState extends Equatable {
  const ReadingLogLogsState();
  @override
  List<Object> get props => [];
}

class LoadingState extends ReadingLogLogsState {}

class LoadedState extends ReadingLogLogsState {
  final ParentLogModel book;
  final Map<DateTime, List<ChildLogModel>> events;
  final DateTime dateKey;
  final DateTime initialSelectedDay;

  LoadedState({
    @required this.book,
    @required this.events,
    @required this.dateKey,
    @required this.initialSelectedDay,
  });

  @override
  List<Object> get props => [
        book,
        events,
        dateKey,
        initialSelectedDay,
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
