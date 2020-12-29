import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:p/models/EntryModel.dart';

abstract class VisitingLogEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class LoadPageEvent extends VisitingLogEvent {
  LoadPageEvent();

  @override
  List<Object> get props => [];
}

class VisitsUpdatedEvent extends VisitingLogEvent {
  final List<EntryModel> visitEntries;

  VisitsUpdatedEvent({
    @required this.visitEntries,
  });

  @override
  List<Object> get props => [
        visitEntries,
      ];
}

class CreateVisitLogEvent extends VisitingLogEvent {
  final DateTime date;
  final String idOfEntry;
  final String visitName;

  CreateVisitLogEvent({
    @required this.date,
    @required this.idOfEntry,
    @required this.visitName,
  });

  @override
  List<Object> get props => [
        date,
        idOfEntry,
        visitName
      ];
}
