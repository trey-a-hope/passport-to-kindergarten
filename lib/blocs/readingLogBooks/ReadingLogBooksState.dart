import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:p/models/ParentLogModel.dart';
import 'package:p/models/UserModel.dart';
import 'package:p/models/LogModel.dart';

class ReadingLogBooksState extends Equatable {
  const ReadingLogBooksState();
  @override
  List<Object> get props => [];
}

class LoadingState extends ReadingLogBooksState {}

class LoadedState extends ReadingLogBooksState {
  final UserModel user;
  final List<ParentLogModel> books;

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

class ErrorState extends ReadingLogBooksState {
  final dynamic error;

  ErrorState({
    @required this.error,
  });

  @override
  List<Object> get props => [
        error,
      ];
}
