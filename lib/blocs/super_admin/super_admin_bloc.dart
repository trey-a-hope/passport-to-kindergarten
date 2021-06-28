import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:excel/excel.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:p/ServiceLocator.dart';
import 'package:p/constants.dart';
import 'package:p/models/BookModel.dart';
import 'package:p/models/EntryModel.dart';
import 'package:p/models/UserModel.dart';
import 'package:p/services/BookService.dart';
import 'package:p/services/LogService.dart';
import 'package:p/services/ModalService.dart';
import 'package:p/services/ReportService.dart';
import 'package:p/services/StampService.dart';
import 'package:p/services/UserService.dart';
import 'package:p/services/VisitService.dart';
import 'package:p/widgets/SpinnerWidget.dart';

part 'super_admin_event.dart';
part 'super_admin_state.dart';
part 'super_admin_view.dart';

class SuperAdminBloc extends Bloc<SuperAdminEvent, SuperAdminState> {
  SuperAdminBloc() : super(SuperAdminInitial());

  List<BookModel> _booksOfTheMonth;
  Map<UserModel, List<UserModel>> _teacherStudentMap;

  @override
  Stream<SuperAdminState> mapEventToState(
    SuperAdminEvent event,
  ) async* {
    if (event is LoadPageEvent) {
      yield LoadingState(text: 'Loading page...');

      try {
        _booksOfTheMonth =
            await locator<BookService>().retrieveBooksOfTheMonth();

        final List<UserModel> teachers =
            await locator<UserService>().retrieveTeachers();

        _teacherStudentMap = Map<UserModel, List<UserModel>>();

        for (int i = 0; i < teachers.length; i++) {
          final UserModel teacher = teachers[i];

          final List<UserModel> students = await locator<UserService>()
              .retrieveStudentsForTeacher(uid: teacher.uid);

          _teacherStudentMap[teacher] = students;
        }

        yield LoadedState(
          booksOfTheMonth: _booksOfTheMonth,
          teacherStudentMap: _teacherStudentMap,
        );
      } catch (error) {
        yield ErrorState(error: error);
      }
    }

    if (event is UpdateBookGivenEvent) {
      final String bookID = event.bookID;
      final bool given = event.given;

      try {
        await locator<BookService>().updateBook(
          bookID: bookID,
          data: {'given': given},
        );
      } catch (error) {
        yield ErrorState(error: error);
      }
    }

    if (event is GenerateReportEvent) {
      // final UserModel teacher = event.teacher;
      final List<UserModel> students = event.students;
      try {
        Excel excel = Excel.createExcel();

        excel.delete('Sheet1'); // automatically creates 1 empty sheet: Sheet1

        for (int i = 0; i < students.length; i++) {
          final UserModel student = students[i];

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
          booksOfTheMonth: _booksOfTheMonth,
          teacherStudentMap: _teacherStudentMap,
        );
      } catch (error) {
        yield ErrorState(error: error);

        print(error.toString());
      }
    }
  }
}
