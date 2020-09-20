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

class SetTextFieldsEvent extends EditProfileEvent {
  final UserModel user;

  SetTextFieldsEvent({@required this.user});

  @override
  List<Object> get props => [];
}

class SubmitEvent extends EditProfileEvent {
  SubmitEvent();

  List<Object> get props => [];
}
