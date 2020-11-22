import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:p/models/LogModel.dart';

abstract class ReadingLogLogsEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class LoadPageEvent extends ReadingLogLogsEvent {
  LoadPageEvent();

  @override
  List<Object> get props => [];
}

class LogsUpdatedEvent extends ReadingLogLogsEvent {
  final List<LogModel> logs;

  LogsUpdatedEvent({
    @required this.logs,
  });

  @override
  List<Object> get props => [
        logs,
      ];
}

class OnDaySelectedEvent extends ReadingLogLogsEvent {
  final DateTime selectedDay;

  OnDaySelectedEvent({
    @required this.selectedDay,
  });

  @override
  List<Object> get props => [
        selectedDay,
      ];
}
