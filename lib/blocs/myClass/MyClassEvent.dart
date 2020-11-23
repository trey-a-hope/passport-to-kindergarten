import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:p/models/UserModel.dart';

abstract class MyClassEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class LoadPageEvent extends MyClassEvent {
  LoadPageEvent();

  @override
  List<Object> get props => [];
}

class CreateBookForStudentEvent extends MyClassEvent {
  final String studentUID;
  final String title;
  final String author;

  CreateBookForStudentEvent({
    @required this.studentUID,
    @required this.title,
    @required this.author,
  });

  @override
  List<Object> get props => [
        title,
        author,
      ];
}

class CreateBookLogForStudentEvent extends MyClassEvent {
  final String studentUID;
  final String bookID;
  final DateTime date;
  final bool totalLogLimitReached;

  CreateBookLogForStudentEvent({
    @required this.studentUID,
    @required this.bookID,
    @required this.date,
    @required this.totalLogLimitReached,
  });

  @override
  List<Object> get props => [
        studentUID,
        bookID,
        date,
        totalLogLimitReached,
      ];
}

class CreateVisitLogForStudentEvent extends MyClassEvent {
  final String studentUID;
  final String visitID;
  final String visitName;
  final DateTime date;

  CreateVisitLogForStudentEvent({
    @required this.studentUID,
    @required this.visitID,
    @required this.visitName,
    @required this.date,
  });

  @override
  List<Object> get props => [
        studentUID,
        visitID,
        visitName,
        date,
      ];
}

class GetBooksForStudentEvent extends MyClassEvent {
  final String studentUID;

  GetBooksForStudentEvent({
    @required this.studentUID,
  });

  @override
  List<Object> get props => [
        studentUID,
      ];
}

class SelectDateForBookEvent extends MyClassEvent {
  final String studentUID;
  final String bookID;
  final DateTime selectedDate;

  SelectDateForBookEvent({
    @required this.studentUID,
    @required this.bookID,
    @required this.selectedDate,
  });

  @override
  List<Object> get props => [
        studentUID,
        bookID,
        selectedDate,
      ];
}

class StudentSelectedEvent extends MyClassEvent {
  final bool studentSelected;

  StudentSelectedEvent({
    @required this.studentSelected,
  });

  @override
  List<Object> get props => [
        studentSelected,
      ];
}

class StudentsUpdatedEvent extends MyClassEvent {
  final List<UserModel> students;

  StudentsUpdatedEvent({
    @required this.students,
  });

  @override
  List<Object> get props => [
        students,
      ];
}
