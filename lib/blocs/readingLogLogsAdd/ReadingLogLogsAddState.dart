import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:p/models/BookModel.dart';

class ReadingLogLogsAddState extends Equatable {
  const ReadingLogLogsAddState();
  @override
  List<Object> get props => [];
}

class LoadingState extends ReadingLogLogsAddState {}

class LoadedState extends ReadingLogLogsAddState {
  final bool autoValidate;
  final GlobalKey<FormState> formKey;
  final BookModel book;

  LoadedState({
    @required this.autoValidate,
    @required this.formKey,
    @required this.book,
  });

  @override
  List<Object> get props => [
        autoValidate,
        formKey,
        book,
      ];
}

class ErrorState extends ReadingLogLogsAddState {
  final dynamic error;

  ErrorState({
    @required this.error,
  });

  @override
  List<Object> get props => [
        error,
      ];
}
