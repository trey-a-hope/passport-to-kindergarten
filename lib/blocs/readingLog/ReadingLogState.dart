import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:p/models/BookModel.dart';
import 'package:p/models/UserModel.dart';
import 'package:p/models/LogModel.dart';

class ReadingLogState extends Equatable {
  const ReadingLogState();
  @override
  List<Object> get props => [];
}

class LoadingState extends ReadingLogState {}

class LoadedState extends ReadingLogState {
  final UserModel user;
  final List<BookModel> books;

  LoadedState({
    @required this.user,
    @required this.books,
  });

  @override
  List<Object> get props => [
        user,
        books,
      ];
}

class ErrorState extends ReadingLogState {
  final dynamic error;

  ErrorState({
    @required this.error,
  });

  @override
  List<Object> get props => [
        error,
      ];
}
