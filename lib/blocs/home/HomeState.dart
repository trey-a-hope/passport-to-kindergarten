import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:p/models/UserModel.dart';

class HomeState extends Equatable {
  const HomeState();
  @override
  List<Object> get props => [];
}

class LoadingState extends HomeState {}

class LoadedState extends HomeState {
  final UserModel user;

  LoadedState({@required this.user});

  @override
  List<Object> get props => [
        user,
      ];
}

class ErrorState extends HomeState {
  final dynamic error;

  ErrorState({
    @required this.error,
  });

  @override
  List<Object> get props => [
        error,
      ];
}
