import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

abstract class ReadingLogAddEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class LoadPageEvent extends ReadingLogAddEvent {
  LoadPageEvent();

  @override
  List<Object> get props => [];
}

class SubmitEvent extends ReadingLogAddEvent {
  final String bookTitle;
  final String description;
  final GlobalKey<FormState> formKey;

  SubmitEvent({
    @required this.bookTitle,
    @required this.description,
    @required this.formKey,
  });

  @override
  List<Object> get props => [
        bookTitle,
        description,
        formKey,
      ];
}
