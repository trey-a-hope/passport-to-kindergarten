import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:p/models/ChildLogModel.dart';

abstract class VisitingLogVisitsEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class LoadPageEvent extends VisitingLogVisitsEvent {
  LoadPageEvent();

  @override
  List<Object> get props => [];
}

class LogsUpdatedEvent extends VisitingLogVisitsEvent {
  final List<ChildLogModel> logs;

  LogsUpdatedEvent({
    @required this.logs,
  });

  @override
  List<Object> get props => [
        logs,
      ];
}
