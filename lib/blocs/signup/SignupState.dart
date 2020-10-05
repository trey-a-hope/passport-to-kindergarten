import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

abstract class SignupState extends Equatable {
  @override
  List<Object> get props => [];
}

class TeacherState extends SignupState {
  TeacherState();

  @override
  List<Object> get props => [];
}

class ParentState extends SignupState {
  final DateTime selectedDate;

  ParentState({
    @required this.selectedDate,
  });

  @override
  List<Object> get props => [
        selectedDate,
      ];
}

class SuperAdminState extends SignupState {
  SuperAdminState();

  @override
  List<Object> get props => [];
}

class SigningIn extends SignupState {}
