import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class ReadingLogBooksAddState extends Equatable {
  const ReadingLogBooksAddState();
  @override
  List<Object> get props => [];
}

class LoadingState extends ReadingLogBooksAddState {}

class LoadedState extends ReadingLogBooksAddState {
  LoadedState();

  @override
  List<Object> get props => [];
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
