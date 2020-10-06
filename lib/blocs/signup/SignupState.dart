import 'dart:io';

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
  final File image;

  ParentState({
    @required this.selectedDate,
    @required this.image,
  });

  @override
  List<Object> get props => [
        selectedDate,
        image,
      ];
}

class SuperAdminState extends SignupState {
  SuperAdminState();

  @override
  List<Object> get props => [];
}

class SigningIn extends SignupState {}
