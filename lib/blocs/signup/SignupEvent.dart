import 'dart:io';

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

class TeacherSignupEvent extends SignupEvent {
  final String email;
  final String password;
  final String firstName;
  final String lastName;
  final String school;

  TeacherSignupEvent({
    @required this.email,
    @required this.password,
    @required this.firstName,
    @required this.lastName,
    @required this.school,
  });

  List<Object> get props => [
        email,
        password,
        firstName,
        lastName,
        school,
      ];
}

class ParentSignupEvent extends SignupEvent {
  final String email;
  final String password;
  final String firstName;
  final String lastName;
  final String firstParentFirstName;
  final String firstParentLastName;
  final String secondParentFirstName;
  final String secondParentLastName;

  ParentSignupEvent({
    @required this.email,
    @required this.password,
    @required this.firstName,
    @required this.lastName,
    @required this.firstParentFirstName,
    @required this.firstParentLastName,
    @required this.secondParentFirstName,
    @required this.secondParentLastName,
  });

  List<Object> get props => [
        email,
        password,
        firstName,
        lastName,
        firstParentFirstName,
        firstParentLastName,
        secondParentFirstName,
        secondParentLastName,
      ];
}

class SuperAdminSignupEvent extends SignupEvent {
  final String email;
  final String password;
  final String firstName;
  final String lastName;

  SuperAdminSignupEvent({
    @required this.email,
    @required this.password,
    @required this.firstName,
    @required this.lastName,
  });

  List<Object> get props => [
        email,
        password,
        firstName,
        lastName,
      ];
}

class UploadPictureEvent extends SignupEvent {
  final File image;

  UploadPictureEvent({
    @required this.image,
  });

  List<Object> get props => [
        image,
      ];
}
