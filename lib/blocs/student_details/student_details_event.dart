part of 'student_details_bloc.dart';

abstract class StudentDetailsEvent extends Equatable {
  const StudentDetailsEvent();

  @override
  List<Object> get props => [];
}

class StudentDetailsLoadPageEvent extends StudentDetailsEvent {
  StudentDetailsLoadPageEvent();

  @override
  List<Object> get props => [];
}

class CreateBookForStudentEvent extends StudentDetailsEvent {
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

class CreateBookLogForStudentEvent extends StudentDetailsEvent {
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

class CreateVisitLogForStudentEvent extends StudentDetailsEvent {
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

class GenerateReportEvent extends StudentDetailsEvent {
  GenerateReportEvent();

  @override
  List<Object> get props => [];
}
