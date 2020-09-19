import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:p/models/UserModel.dart';

class BookOfTheMonthDetailsState extends Equatable {
  const BookOfTheMonthDetailsState();
  @override
  List<Object> get props => [];
}

class LoadingState extends BookOfTheMonthDetailsState {}

class LoadedState extends BookOfTheMonthDetailsState {
  final UserModel user;

  LoadedState({@required this.user});

  @override
  List<Object> get props => [
        user,
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
