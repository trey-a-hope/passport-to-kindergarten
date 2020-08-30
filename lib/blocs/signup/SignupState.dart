import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class SignupState extends Equatable {
  @override
  List<Object> get props => [];
}

class SignupNotStarted extends SignupState {
  final bool autoValidate;
  final GlobalKey<FormState> formKey;

  SignupNotStarted({
    @required this.autoValidate,
    @required this.formKey,
  });

  @override
  List<Object> get props => [
        autoValidate,
        formKey,
      ];
}

class SigningIn extends SignupState {}
