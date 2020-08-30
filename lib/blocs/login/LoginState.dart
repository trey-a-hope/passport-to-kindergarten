import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class LoginState extends Equatable {
  @override
  List<Object> get props => [];
}

class LoginNotStarted extends LoginState {
  final bool autoValidate;
  final GlobalKey<FormState> formKey;

  LoginNotStarted({
    @required this.autoValidate,
    @required this.formKey,
  });

  @override
  List<Object> get props => [
        autoValidate,
        formKey,
      ];
}

class LoggingIn extends LoginState {}
