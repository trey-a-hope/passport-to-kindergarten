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

class ToggleProfileTypeEvent extends SignupEvent {
  ToggleProfileTypeEvent();

  List<Object> get props => [];
}

class Signup extends SignupEvent {
  final String email;
  final String password;
  final String firstName;
  final String lastName;
  final GlobalKey<FormState> formKey;
  final String school;

  Signup({
    @required this.email,
    @required this.password,
    @required this.firstName,
    @required this.lastName,
    @required this.formKey,
    @required this.school,
  });

  List<Object> get props => [
        email,
        password,
        firstName,
        lastName,
        formKey,
        school,
      ];
}
