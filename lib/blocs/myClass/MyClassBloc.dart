import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:excel/excel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:p/ServiceLocator.dart';
import 'package:p/models/EntryModel.dart';
import 'package:p/models/UserModel.dart';
import 'package:p/services/AuthService.dart';
import 'package:p/services/BookService.dart';
import 'package:p/services/LogService.dart';
import 'package:p/services/ReportService.dart';
import 'package:p/services/StampService.dart';
import 'package:p/services/UserService.dart';
import 'package:p/services/VisitService.dart';
import 'MyClassEvent.dart';
import 'MyClassState.dart';

abstract class MyClassBlocDelegate {
  void showMessage({@required String message});
  void clearAddTitleForm();
}

class MyClassBloc extends Bloc<MyClassEvent, MyClassState> {
  MyClassBloc() : super(null);
  MyClassBlocDelegate _myClassBlocDelegate;

  UserModel _currentUser;
  List<UserModel> _students;
  List<String> _visitsIDs;
  List<String> _booksOfTheMonthIDs;

  void setDelegate({@required MyClassBlocDelegate delegate}) {
    this._myClassBlocDelegate = delegate;
  }

  @override
  Stream<MyClassState> mapEventToState(MyClassEvent event) async* {
    if (event is LoadPageEvent) {
      yield LoadingState(text: 'Loading page...');

      try {
        _currentUser = await locator<AuthService>().getCurrentUser();

        _visitsIDs = (await locator<VisitService>().retrieveVisits())
            .map((visit) => visit.id)
            .toList();

        _booksOfTheMonthIDs =
            (await locator<BookService>().retrieveBooksOfTheMonth())
                .map((bookOfTheMonth) => bookOfTheMonth.id)
                .toList();

        Stream<QuerySnapshot> studentsStream = await locator<UserService>()
            .streamStudentsForTeacher(teacherUID: _currentUser.uid);

        studentsStream.listen(
          (QuerySnapshot event) {
            List<UserModel> students = event.docs
                .map((doc) => UserModel.fromDocumentSnapshot(ds: doc))
                .toList();

            add(StudentsUpdatedEvent(students: students));
          },
        );
      } catch (error) {
        yield ErrorState(error: error);
      }
    }

    if (event is StudentsUpdatedEvent) {
      try {
        _students = event.students;

        yield LoadedState(
          user: _currentUser,
          students: _students,
          visitsIDs: _visitsIDs,
          booksOfTheMonthIDs: _booksOfTheMonthIDs,
        );
      } catch (error) {
        yield ErrorState(error: error);
      }
    }

    if (event is GenerateClassReportEvent) {
      try {
        Excel excel = Excel.createExcel();

        excel.delete('Sheet1'); // automatically creates 1 empty sheet: Sheet1

        for (int i = 0; i < _students.length; i++) {
          final UserModel student = _students[i];

          yield LoadingState(
              text:
                  'Generating data for ${student.firstName} ${student.lastName}...');

          student.bookEntries = await locator<LogService>()
              .retrieveEntries(uid: student.uid, type: 'books');

          for (int bookCounter = 0;
              bookCounter < student.bookEntries.length;
              bookCounter++) {
            final EntryModel bookEntry = student.bookEntries[bookCounter];

            if (bookEntry.entryID == null) {
              throw ('${student.firstName} ${student.lastName} has a null book entry id.');
            }

            bookEntry.book = await locator<BookService>()
                .retrieveBook(bookID: bookEntry.entryID);
          }

          student.visitEntries = await locator<LogService>()
              .retrieveEntries(uid: student.uid, type: 'visits');

          for (int visitCounter = 0;
              visitCounter < student.visitEntries.length;
              visitCounter++) {
            final EntryModel visitEntry = student.visitEntries[visitCounter];

            if (visitEntry.entryID == null) {
              throw ('${student.firstName} ${student.lastName} has a null visit entry id.');
            }

            visitEntry.visit = await locator<VisitService>()
                .retrieveVisit(visitID: visitEntry.entryID);
          }

          student.stamps =
              await locator<StampService>().getStampsForUser(uid: student.uid);

          excel = await locator<ReportService>()
              .buildStudentReport(excel: excel, student: student);
        }

        locator<ReportService>().emailReport(excel: excel);

        yield LoadedState(
          user: _currentUser,
          students: _students,
          visitsIDs: _visitsIDs,
          booksOfTheMonthIDs: _booksOfTheMonthIDs,
        );
      } catch (error) {
        _myClassBlocDelegate.showMessage(message: error.toString());

        yield LoadedState(
          user: _currentUser,
          students: _students,
          visitsIDs: _visitsIDs,
          booksOfTheMonthIDs: _booksOfTheMonthIDs,
        );
      }
    }
  }
}
