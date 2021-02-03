import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:p/models/UserModel.dart';

class MyClassState extends Equatable {
  const MyClassState();
  @override
  List<Object> get props => [];
}

class LoadingState extends MyClassState {
  final String text;

  const LoadingState({
    @required this.text,
  });
  
  @override
  List<Object> get props => [
        text,
      ];
}

class LoadedState extends MyClassState {
  final UserModel user;
  final List<UserModel> students;
  final List<String> visitsIDs;
  final List<String> booksOfTheMonthIDs;

  LoadedState({
    @required this.user,
    @required this.students,
    @required this.visitsIDs,
    @required this.booksOfTheMonthIDs,
  });

  @override
  List<Object> get props => [
        user,
        students,
        visitsIDs,
        booksOfTheMonthIDs,
      ];
}

class ErrorState extends MyClassState {
  final dynamic error;

  ErrorState({
    @required this.error,
  });

  @override
  List<Object> get props => [
        error,
      ];
}
