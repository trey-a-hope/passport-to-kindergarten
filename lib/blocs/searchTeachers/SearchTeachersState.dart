import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:p/models/UserModel.dart';

abstract class SearchTeachersState extends Equatable {
  const SearchTeachersState();

  @override
  List<Object> get props => [];
}

class SearchTeachersStateNoResults extends SearchTeachersState {}

class SearchTeachersStateStart extends SearchTeachersState {}

class SearchTeachersStateLoading extends SearchTeachersState {}

class SearchTeachersStateFoundResults extends SearchTeachersState {
  final List<UserModel> teachers;

  const SearchTeachersStateFoundResults({
    @required this.teachers,
  });

  @override
  List<Object> get props => [teachers];

  @override
  String toString() =>
      'SearchTeachersStateSuccess { items: ${teachers.length} }';
}

class SearchTeachersStateError extends SearchTeachersState {
  final dynamic error;

  const SearchTeachersStateError({
    @required this.error,
  });

  @override
  List<Object> get props => [error];
}
