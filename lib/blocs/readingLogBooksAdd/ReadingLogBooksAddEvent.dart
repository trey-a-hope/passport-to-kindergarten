import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:p/models/ParentLogModel.dart';

abstract class ReadingLogBooksAddEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class LoadPageEvent extends ReadingLogBooksAddEvent {
  
  LoadPageEvent();

  @override
  List<Object> get props => [];
}

class SubmitEvent extends ReadingLogBooksAddEvent {
  final String bookTitle;
  final GlobalKey<FormState> formKey;

  SubmitEvent({
    @required this.bookTitle,
    @required this.formKey,
  });

  List<Object> get props => [
        bookTitle,
        formKey,
      ];
}
