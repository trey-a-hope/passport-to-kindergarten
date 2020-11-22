export 'EditProfileBloc.dart';
export 'EditProfileEvent.dart';
export 'EditProfileState.dart';
export 'EditProfilePage.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:p/models/UserModel.dart';

class EditProfileState extends Equatable {
  const EditProfileState();
  @override
  List<Object> get props => [];
}

class LoadingState extends EditProfileState {}

class SuperAdminLoadedState extends EditProfileState {
  final UserModel user;

  SuperAdminLoadedState({
    @required this.user,
  });

  @override
  List<Object> get props => [
        user,
      ];
}

class TeacherLoadedState extends EditProfileState {
  final UserModel user;

  TeacherLoadedState({
    @required this.user,
  });

  @override
  List<Object> get props => [
        user,
      ];
}

class ParentLoadedState extends EditProfileState {
  final UserModel user;

  ParentLoadedState({
    @required this.user,
  });

  @override
  List<Object> get props => [
        user,
      ];
}

class ErrorState extends EditProfileState {
  final dynamic error;

  ErrorState({
    @required this.error,
  });

  @override
  List<Object> get props => [
        error,
      ];
}
