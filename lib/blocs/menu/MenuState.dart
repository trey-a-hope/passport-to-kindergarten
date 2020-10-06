import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:p/models/UserModel.dart';

class MenuState extends Equatable {
  const MenuState();
  @override
  List<Object> get props => [];
}

class LoadingState extends MenuState {}

class LoadedState extends MenuState {
  final UserModel user;

  LoadedState({@required this.user});

  @override
  List<Object> get props => [
        user,
      ];
}

class ParentState extends MenuState {
  final UserModel user;
  final String greetingMessage;

  ParentState({
    @required this.user,
    @required this.greetingMessage,
  });

  @override
  List<Object> get props => [
        user,
        greetingMessage,
      ];
}

class TeacherState extends MenuState {
  final UserModel user;
  final String greetingMessage;

  TeacherState({
    @required this.user,
    @required this.greetingMessage,
  });

  @override
  List<Object> get props => [
        user,
        greetingMessage,
      ];
}

class SuperAdminState extends MenuState {
  final UserModel user;
  final String greetingMessage;

  SuperAdminState({
    @required this.user,
    @required this.greetingMessage,
  });

  @override
  List<Object> get props => [
        user,
        greetingMessage,
      ];
}

class ErrorState extends MenuState {
  final dynamic error;

  ErrorState({
    @required this.error,
  });

  @override
  List<Object> get props => [
        error,
      ];
}
