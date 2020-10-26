import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:p/models/ChildLogModel.dart';
import 'package:p/models/UserModel.dart';

class VisitingLogLogState extends Equatable {
  const VisitingLogLogState();
  @override
  List<Object> get props => [];
}

class LoadingState extends VisitingLogLogState {}

class LoadedState extends VisitingLogLogState {
  final String title;
  final UserModel user;
  final Map<DateTime, List<ChildLogModel>> events;
  final DateTime dateKey;
  final DateTime initialSelectedDay;

  LoadedState({
    @required this.title,
    @required this.user,
    @required this.events,
    @required this.dateKey,
    @required this.initialSelectedDay,
  });

  @override
  List<Object> get props => [
        title,
        user,
        events,
        dateKey,
        initialSelectedDay,
      ];
}

class ErrorState extends VisitingLogLogState {
  final dynamic error;

  ErrorState({
    @required this.error,
  });

  @override
  List<Object> get props => [
        error,
      ];
}
