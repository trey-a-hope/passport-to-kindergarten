import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:p/models/ChildLogModel.dart';

abstract class VisitingLogLogsEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class LoadPageEvent extends VisitingLogLogsEvent {
  LoadPageEvent();

  @override
  List<Object> get props => [];
}

class LogsUpdatedEvent extends VisitingLogLogsEvent {
  final List<ChildLogModel> logs;

  LogsUpdatedEvent({
    @required this.logs,
  });

  @override
  List<Object> get props => [
        logs,
      ];
}

class OnDaySelectedEvent extends VisitingLogLogsEvent {
  final DateTime selectedDay;

  OnDaySelectedEvent({
    @required this.selectedDay,
  });

  @override
  List<Object> get props => [
        selectedDay,
      ];
}
