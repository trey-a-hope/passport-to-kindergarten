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
  final GlobalKey<FormState> formKey;

  SubmitEvent({
    @required this.description,
    @required this.formKey,
  });

  @override
  List<Object> get props => [
        description,
        formKey,
      ];
}
