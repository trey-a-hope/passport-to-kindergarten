import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

abstract class SignupState extends Equatable {
  @override
  List<Object> get props => [];
}

class TeacherState extends SignupState {
  final bool autoValidate;
  final GlobalKey<FormState> formKey;

  TeacherState({
    @required this.autoValidate,
    @required this.formKey,
  });

  @override
  List<Object> get props => [
        autoValidate,
        formKey,
      ];
}

class ParentState extends SignupState {
  final bool autoValidate;
  final GlobalKey<FormState> formKey;
  final DateTime selectedDate;

  ParentState({
    @required this.autoValidate,
    @required this.formKey,
    @required this.selectedDate,
  });

  @override
  List<Object> get props => [
        autoValidate,
        formKey,
        selectedDate,
      ];
}

class SigningIn extends SignupState {}
