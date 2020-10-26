import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

abstract class VisitingLogLogsAddEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class LoadPageEvent extends VisitingLogLogsAddEvent {
  LoadPageEvent();

  @override
  List<Object> get props => [];
}

class SubmitEvent extends VisitingLogLogsAddEvent {
  final String description;

  SubmitEvent({
    @required this.description,
  });

  @override
  List<Object> get props => [
        description,
      ];
}
