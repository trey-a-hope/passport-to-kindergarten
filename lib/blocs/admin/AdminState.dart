import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:p/models/UserModel.dart';

class AdminState extends Equatable {
  const AdminState();
  @override
  List<Object> get props => [];
}

class LoadingState extends AdminState {}

class TeacherLoadedState extends AdminState {
  final UserModel user;

  TeacherLoadedState({@required this.user});

  @override
  List<Object> get props => [
        user,
      ];
}

class SuperAdminLoadedState extends AdminState {
  final UserModel user;

  SuperAdminLoadedState({@required this.user});

  @override
  List<Object> get props => [
        user,
      ];
}

class ErrorState extends AdminState {
  final dynamic error;

  ErrorState({
    @required this.error,
  });

  @override
  List<Object> get props => [
        error,
      ];
}
