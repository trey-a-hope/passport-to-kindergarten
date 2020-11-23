import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:p/models/BookModel.dart';
import 'package:p/models/VisitModel.dart';

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
  final List<VisitModel> visits;

  VisitsUpdatedEvent({
    @required this.visits,
  });

  @override
  List<Object> get props => [
        visits,
      ];
}

class CreateVisitLogEvent extends VisitingLogEvent {
  final String visitID;
  final DateTime date;
  final String visitName;

  CreateVisitLogEvent({
    @required this.visitID,
    @required this.date,
    @required this.visitName,
  });

  @override
  List<Object> get props => [
        visitID,
        date,
        visitName,
      ];
}
