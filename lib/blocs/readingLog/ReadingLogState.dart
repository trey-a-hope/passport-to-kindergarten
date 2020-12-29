import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:p/models/BookModel.dart';
import 'package:p/models/EntryModel.dart';
import 'package:p/models/UserModel.dart';

class ReadingLogState extends Equatable {
  const ReadingLogState();
  @override
  List<Object> get props => [];
}

class LoadingState extends ReadingLogState {}

class LoadedState extends ReadingLogState {
  final List<EntryModel> bookEntries;
  final UserModel currentUser;

  LoadedState({
    @required this.bookEntries,
    @required this.currentUser,
  });

  @override
  List<Object> get props => [
        bookEntries,
        currentUser,
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
