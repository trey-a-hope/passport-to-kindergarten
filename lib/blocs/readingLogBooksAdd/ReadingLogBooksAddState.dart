import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class ReadingLogBooksAddState extends Equatable {
  const ReadingLogBooksAddState();
  @override
  List<Object> get props => [];
}

class LoadingState extends ReadingLogBooksAddState {}

class LoadedState extends ReadingLogBooksAddState {
  final bool autoValidate;
  final GlobalKey<FormState> formKey;

  LoadedState({
    @required this.autoValidate,
    @required this.formKey,
  });

  @override
  List<Object> get props => [
        autoValidate,
        formKey,
      ];
}

class ErrorState extends ReadingLogBooksAddState {
  final dynamic error;

  ErrorState({
    @required this.error,
  });

  @override
  List<Object> get props => [
        error,
      ];
}
