import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:p/models/LogModel.dart';

abstract class ReadingLogEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class LoadPageEvent extends ReadingLogEvent {
  LoadPageEvent();

  @override
  List<Object> get props => [];
}

class ReadLogsUpdatedEvent extends ReadingLogEvent {
  final List<LogModel> readLogs;

  ReadLogsUpdatedEvent({
    @required this.readLogs,
  });

  @override
  List<Object> get props => [
        readLogs,
      ];
}
