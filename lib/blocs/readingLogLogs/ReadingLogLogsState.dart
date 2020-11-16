import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:p/models/BookModel.dart';
import 'package:p/models/LogModel.dart';

class ReadingLogLogsState extends Equatable {
  const ReadingLogLogsState();
  @override
  List<Object> get props => [];
}

class LoadingState extends ReadingLogLogsState {}

class LoadedState extends ReadingLogLogsState {
  final BookModel book;
  final Map<DateTime, List<LogModel>> events;
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
