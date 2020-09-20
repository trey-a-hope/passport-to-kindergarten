import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:p/models/UserModel.dart';

class AwesomeReadingTipsState extends Equatable {
  const AwesomeReadingTipsState();
  @override
  List<Object> get props => [];
}

class LoadingState extends AwesomeReadingTipsState {}

class LoadedState extends AwesomeReadingTipsState {
  final UserModel user;

  LoadedState({@required this.user});

  @override
  List<Object> get props => [
        user,
      ];
}

class ErrorState extends AwesomeReadingTipsState {
  final dynamic error;

  ErrorState({
    @required this.error,
  });

  @override
  List<Object> get props => [
        error,
      ];
}
