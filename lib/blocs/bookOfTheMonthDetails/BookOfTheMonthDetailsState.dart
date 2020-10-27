import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:p/models/BookOfTheMonthModel.dart';
import 'package:p/models/UserModel.dart';

class BookOfTheMonthDetailsState extends Equatable {
  const BookOfTheMonthDetailsState();
  @override
  List<Object> get props => [];
}

class LoadingState extends BookOfTheMonthDetailsState {}

class LoadedState extends BookOfTheMonthDetailsState {
  final UserModel user;
  final BookOfTheMonthModel bookOfTheMonth;

  LoadedState({
    @required this.user,
    @required this.bookOfTheMonth,
  });

  @override
  List<Object> get props => [
        user,
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
