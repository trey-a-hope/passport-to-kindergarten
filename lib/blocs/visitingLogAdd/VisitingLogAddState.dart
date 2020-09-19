import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:p/models/UserModel.dart';

class VisitingLogAddState extends Equatable {
  const VisitingLogAddState();
  @override
  List<Object> get props => [];
}

class LoadingState extends VisitingLogAddState {}

class LoadedState extends VisitingLogAddState {
  final bool autoValidate;
  final GlobalKey<FormState> formKey;
  final UserModel user;

  LoadedState({
    @required this.user,
    @required this.autoValidate,
    @required this.formKey,
  });

  @override
  List<Object> get props => [
        user,
        autoValidate,
        formKey,
      ];
}

class ErrorState extends VisitingLogAddState {
  final dynamic error;

  ErrorState({
    @required this.error,
  });

  @override
  List<Object> get props => [
        error,
      ];
}
