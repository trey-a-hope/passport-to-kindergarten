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
  final String idOfEntry;
  final DateTime date;
  final bool totalLogLimitReached;

  CreateBookLogForStudentEvent({
    @required this.studentUID,
    @required this.idOfEntry,
    @required this.date,
    @required this.totalLogLimitReached,
  });

  @override
  List<Object> get props => [
        studentUID,
        idOfEntry,
        date,
        totalLogLimitReached,
      ];
}

class CreateVisitLogForStudentEvent extends MyClassEvent {
  final String studentUID;
  final String idOfEntry;
  final String visitName;
  final DateTime date;

  CreateVisitLogForStudentEvent({
    @required this.studentUID,
    @required this.idOfEntry,
    @required this.visitName,
    @required this.date,
  });

  @override
  List<Object> get props => [
        studentUID,
        idOfEntry,
        visitName,
        date,
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

class GenerateClassReportEvent extends MyClassEvent {
  GenerateClassReportEvent();

  @override
  List<Object> get props => [];
}
