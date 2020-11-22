import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:p/models/UserModel.dart';
import 'package:p/models/VisitModel.dart';

class VisitingLogState extends Equatable {
  const VisitingLogState();
  @override
  List<Object> get props => [];
}

class LoadingState extends VisitingLogState {}

class LoadedState extends VisitingLogState {
  final List<VisitModel> visits;
  final UserModel currentUser;

  LoadedState({
    @required this.visits,
    @required this.currentUser,
  });

  @override
  List<Object> get props => [
        visits,
        currentUser,
      ];
}

class ErrorState extends VisitingLogState {
  final dynamic error;

  ErrorState({
    @required this.error,
  });

  @override
  List<Object> get props => [
        error,
      ];
}
