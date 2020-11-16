import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:p/models/BookModel.dart';

class ReadingLogBooksState extends Equatable {
  const ReadingLogBooksState();
  @override
  List<Object> get props => [];
}

class LoadingState extends ReadingLogBooksState {}

class LoadedState extends ReadingLogBooksState {
  final List<BookModel> books;
  final String sortBy;

  LoadedState({
    //@required this.user,
    @required this.books,
    @required this.sortBy,
  });

  @override
  List<Object> get props => [
        //user,
        books,
        sortBy,
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
