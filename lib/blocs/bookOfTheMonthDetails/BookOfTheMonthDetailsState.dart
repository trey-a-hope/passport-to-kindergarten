import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:p/models/BookModel.dart';

class BookOfTheMonthDetailsState extends Equatable {
  const BookOfTheMonthDetailsState();
  @override
  List<Object> get props => [];
}

class LoadingState extends BookOfTheMonthDetailsState {}

class LoadedState extends BookOfTheMonthDetailsState {
  final BookModel bookOfTheMonth;

  LoadedState({
    @required this.bookOfTheMonth,
  });

  @override
  List<Object> get props => [
        bookOfTheMonth,
      ];
}

class ErrorState extends BookOfTheMonthDetailsState {
  final dynamic error;

  ErrorState({
    @required this.error,
  });

  @override
  List<Object> get props => [
        error,
      ];
}
