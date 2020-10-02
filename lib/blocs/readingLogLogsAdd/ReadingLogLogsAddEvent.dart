import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:p/models/ParentLogModel.dart';

abstract class ReadingLogLogsAddEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class LoadPageEvent extends ReadingLogLogsAddEvent {
  LoadPageEvent();

  @override
  List<Object> get props => [];
}

class SubmitEvent extends ReadingLogLogsAddEvent {
  final GlobalKey<FormState> formKey;
  final String notes;

  SubmitEvent({
    @required this.formKey,
    @required this.notes,
  });

  List<Object> get props => [
        formKey,
      ];
}