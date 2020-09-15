import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:p/models/UserModel.dart';

abstract class MyPassportState extends Equatable {
  @override
  List<Object> get props => [];
}

class LoadingState extends MyPassportState {
  LoadingState();

  @override
  List<Object> get props => [];
}

class LoadedState extends MyPassportState {
  final UserModel user;

  LoadedState({
    @required this.user,
  });

  @override
  List<Object> get props => [
        user,
      ];
}

class ErrorState extends MyPassportState {
  final dynamic error;

  ErrorState({
    @required this.error,
  });

  @override
  List<Object> get props => [
        error,
      ];
}
