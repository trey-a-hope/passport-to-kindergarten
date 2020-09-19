import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:p/models/UserModel.dart';

class BookOfTheMonthState extends Equatable {
  const BookOfTheMonthState();
  @override
  List<Object> get props => [];
}

class LoadingState extends BookOfTheMonthState {}

class LoadedState extends BookOfTheMonthState {
  final UserModel user;

  LoadedState({@required this.user});

  @override
  List<Object> get props => [
        user,
      ];
}

class ErrorState extends BookOfTheMonthState {
  final dynamic error;

  ErrorState({
    @required this.error,
  });

  @override
  List<Object> get props => [
        error,
      ];
}
