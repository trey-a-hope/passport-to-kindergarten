import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:p/models/BookModel.dart';
import 'package:p/models/LogModel.dart';
import 'package:p/models/StampModel.dart';
import 'package:p/models/UserModel.dart';
import 'package:p/models/VisitModel.dart';

class MyClassState extends Equatable {
  const MyClassState();
  @override
  List<Object> get props => [];
}

class LoadingState extends MyClassState {}

class LoadedState extends MyClassState {
  final UserModel user;
  final List<UserModel> students;
  final List<BookModel> books;
  final List<VisitModel> selectedStudentVisits;
  final DateTime selectedDateForBookLogs;
  final Map<DateTime, List<LogModel>> events;
  final bool studentSelected;
  final List<StampModel> stamps;

  LoadedState({
    @required this.user,
    @required this.students,
    @required this.books,
    @required this.selectedStudentVisits,
    @required this.selectedDateForBookLogs,
    @required this.events,
    @required this.studentSelected,
    @required this.stamps,
  });

  @override
  List<Object> get props => [
        user,
        students,
        books,
        selectedStudentVisits,
        selectedDateForBookLogs,
        events,
        studentSelected,
        stamps,
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
