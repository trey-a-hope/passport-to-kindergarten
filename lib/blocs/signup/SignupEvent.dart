import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

abstract class SignupEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class LoadPageEvent extends SignupEvent {
  LoadPageEvent();

  List<Object> get props => [];
}

class Signup extends SignupEvent {
  final String email;
  final String password;
  final GlobalKey<FormState> formKey;

  Signup({
    @required this.email,
    @required this.password,
    @required this.formKey,
  });

  List<Object> get props => [
        email,
        password,
        formKey,
      ];
}
