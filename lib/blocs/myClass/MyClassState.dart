import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:p/models/UserModel.dart';

class MyClassState extends Equatable {
  const MyClassState();
  @override
  List<Object> get props => [];
}

class LoadingState extends MyClassState {}

class LoadedState extends MyClassState {
  final UserModel user;

  LoadedState({@required this.user});

  @override
  List<Object> get props => [
        user,
      ];
}

class ErrorState extends MyClassState {
  final dynamic error;

  ErrorState({
    @required this.error,
  });

  @override
  List<Object> get props => [
        error,
      ];
}
