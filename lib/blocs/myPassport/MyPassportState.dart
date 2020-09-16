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
  final UserModel childUser;
  final UserModel teacherUser;

  LoadedState({
    @required this.childUser,
    @required this.teacherUser,
  });

  @override
  List<Object> get props => [
        childUser,
        teacherUser,
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
