import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:p/constants.dart';
import 'package:p/models/UserModel.dart';

abstract class SignupEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class LoadPageEvent extends SignupEvent {
  LoadPageEvent();

  List<Object> get props => [];
}

class ToggleProfileTypeEvent extends SignupEvent {
  final PROFILE_TYPE profileType;

  ToggleProfileTypeEvent({
    @required this.profileType,
  });

  List<Object> get props => [
        profileType,
      ];
}

class SelectDateEvent extends SignupEvent {
  final DateTime selectedDate;

  SelectDateEvent({
    @required this.selectedDate,
  });

  List<Object> get props => [
        selectedDate,
      ];
}

class SelectTeacherEvent extends SignupEvent {
  final UserModel selectedTeacher;

  SelectTeacherEvent({
    @required this.selectedTeacher,
  });

  List<Object> get props => [
        selectedTeacher,
      ];
}

class Signup extends SignupEvent {
  final String email;
  final String password;
  final String firstName;
  final String lastName;
  final GlobalKey<FormState> formKey;
  final String school;
  final String parentFirstName;
  final String parentLastName;
  final String superAdminSecretKey;

  Signup({
    @required this.email,
    @required this.password,
    @required this.firstName,
    @required this.lastName,
    @required this.formKey,
    @required this.school,
    @required this.parentFirstName,
    @required this.parentLastName,
    @required this.superAdminSecretKey,
  });

  List<Object> get props => [
        email,
        password,
        firstName,
        lastName,
        formKey,
        school,
        parentFirstName,
        parentLastName,
        superAdminSecretKey,
      ];
}
