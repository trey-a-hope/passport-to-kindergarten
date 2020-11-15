import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:p/models/UserModel.dart';

abstract class EditProfileEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class LoadPageEvent extends EditProfileEvent {
  LoadPageEvent();

  @override
  List<Object> get props => [];
}

class TeacherSetTextFieldsEvent extends EditProfileEvent {
  final UserModel user;

  TeacherSetTextFieldsEvent({@required this.user});

  @override
  List<Object> get props => [];
}

class TeacherSubmitEvent extends EditProfileEvent {
  final String firstName;
  final String lastName;
  final String school;

  TeacherSubmitEvent({
    @required this.firstName,
    @required this.lastName,
    @required this.school,
  });

  @override
  List<Object> get props => [
        firstName,
        lastName,
        school,
      ];
}

class ParentSetTextFieldsEvent extends EditProfileEvent {
  final UserModel user;

  ParentSetTextFieldsEvent({
    @required this.user,
  });

  @override
  List<Object> get props => [
        user,
      ];
}

class ParentSubmitEvent extends EditProfileEvent {
  final String firstName;
  final String lastName;
  final String primaryParentFirstName;
  final String primaryParentLastName;
  final String secondaryParentFirstName;
  final String secondaryParentLastName;

  ParentSubmitEvent({
    @required this.firstName,
    @required this.lastName,
    @required this.primaryParentFirstName,
    @required this.primaryParentLastName,
    @required this.secondaryParentFirstName,
    @required this.secondaryParentLastName,
  });

  @override
  List<Object> get props => [
        firstName,
        lastName,
        primaryParentFirstName,
        primaryParentLastName,
        secondaryParentFirstName,
        secondaryParentLastName,
      ];
}

class SuperAdminSetTextFieldsEvent extends EditProfileEvent {
  final UserModel user;

  SuperAdminSetTextFieldsEvent({@required this.user});

  @override
  List<Object> get props => [];
}

class SuperAdminSubmitEvent extends EditProfileEvent {
  final String firstName;
  final String lastName;

  SuperAdminSubmitEvent({
    @required this.firstName,
    @required this.lastName,
  });

  @override
  List<Object> get props => [
        firstName,
        lastName,
      ];
}

class UpdateChildDOBEvent extends EditProfileEvent {
  final DateTime childDOB;
  UpdateChildDOBEvent({@required this.childDOB});

  List<Object> get props => [
        childDOB,
      ];
}

class UploadPictureEvent extends EditProfileEvent {
  final File image;

  UploadPictureEvent({
    @required this.image,
  });

  List<Object> get props => [
        image,
      ];
}
