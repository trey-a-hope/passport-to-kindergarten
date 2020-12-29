import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:p/models/EntryModel.dart';
import 'package:p/models/UserModel.dart';

class VisitingLogState extends Equatable {
  const VisitingLogState();
  @override
  List<Object> get props => [];
}

class LoadingState extends VisitingLogState {}

class LoadedState extends VisitingLogState {
  final List<EntryModel> visitEntries;
  final UserModel currentUser;

  LoadedState({
    @required this.visitEntries,
    @required this.currentUser,
  });

  @override
  List<Object> get props => [
        visitEntries,
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
