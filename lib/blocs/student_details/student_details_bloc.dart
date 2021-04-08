import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:excel/excel.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:getwidget/components/button/gf_button.dart';
import 'package:getwidget/shape/gf_button_shape.dart';
import 'package:getwidget/types/gf_button_type.dart';
import 'package:intl/intl.dart';
import 'package:maps_launcher/maps_launcher.dart';
import 'package:p/models/EntryModel.dart';
import 'package:p/models/LogModel.dart';
import 'package:p/models/StampModel.dart';
import 'package:p/models/UserModel.dart';
import 'package:flutter/material.dart';
import 'package:p/models/VisitModel.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:p/ServiceLocator.dart';
import 'package:p/constants.dart';
import 'package:p/models/BookModel.dart';
import 'package:p/services/BookService.dart';
import 'package:p/services/LogService.dart';
import 'package:p/services/ModalService.dart';
import 'package:p/services/ReportService.dart';
import 'package:p/services/StampService.dart';
import 'package:p/services/ValidatorService.dart';
import 'package:p/services/VisitService.dart';
import 'package:p/widgets/AppBarWidget.dart';
import 'package:p/widgets/FullWidthButtonWidget.dart';
import 'package:p/widgets/SpinnerWidget.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:url_launcher/url_launcher.dart';

part 'student_details_event.dart';
part 'student_details_state.dart';
part 'student_details_page.dart';

abstract class StudentDetailsBlocDelegate {
  void showMessage({@required String message});
  void clearAddTitleForm();
}

class StudentDetailsBloc
    extends Bloc<StudentDetailsEvent, StudentDetailsState> {
  StudentDetailsBloc({
    @required this.student,
    @required this.visitIDs,
    @required this.bookOfTheMonthIDs,
  }) : super(StudentDetailsInitialState());

  final UserModel student;
  final List<String> visitIDs;
  final List<String> bookOfTheMonthIDs;

  StudentDetailsBlocDelegate _studentDetailsBlocDelegate;

  void setDelegate({@required StudentDetailsBlocDelegate delegate}) {
    this._studentDetailsBlocDelegate = delegate;
  }

  @override
  Stream<StudentDetailsState> mapEventToState(
    StudentDetailsEvent event,
  ) async* {
    yield StudentDetailsLoadingState(
        text: 'Loading data for ${student.firstName} ${student.lastName}');

    if (event is StudentDetailsLoadPageEvent) {
      try {
        print('${student.firstName} ${student.lastName}');

        //Book Entries
        final List<EntryModel> bookEntries = await locator<LogService>()
            .retrieveEntries(uid: student.uid, type: 'books');

        final List<String> bookEntriesIDs =
            bookEntries.map((bookEntry) => bookEntry.entryID).toList();

        for (var i = 0; i < bookOfTheMonthIDs.length; i++) {
          if (!bookEntriesIDs.contains(bookOfTheMonthIDs[i])) {
            await locator<LogService>().createEntry(
              uid: student.uid,
              type: 'books',
              entry: EntryModel(
                id: null,
                entryID: bookOfTheMonthIDs[i],
                created: DateTime.now(),
                modified: DateTime.now(),
                logCount: 0,
              ),
            );
          }
        }

        for (var i = 0; i < bookEntries.length; i++) {
          final EntryModel bookEntry = bookEntries[i];

          if (bookEntry.entryID == null) {
            throw ('${student.firstName} ${student.lastName} has a null book entry id.');
          }

          final BookModel book = await locator<BookService>()
              .retrieveBook(bookID: bookEntry.entryID);

          bookEntry.book = book;

          final List<LogModel> logs = await locator<LogService>().retrieveLogs(
              uid: student.uid, type: 'books', idOfEntry: bookEntry.id);

          Map<DateTime, List<LogModel>> logEvents =
              Map<DateTime, List<LogModel>>();

          logs.forEach(
            (LogModel log) {
              DateTime dayKey = DateTime(
                log.created.year,
                log.created.month,
                log.created.day,
              );

              if (logEvents.containsKey(dayKey)) {
                if (!logEvents[dayKey].contains(log)) {
                  logEvents[dayKey].add(log);
                }
              } else {
                logEvents[dayKey] = [log];
              }
            },
          );

          bookEntry.logEvents = logEvents;
        }

        student.bookEntries = bookEntries;

        student.bookSortBy = 'recent';

        student.bookEntries.sort(
          (a, b) => b.modified.compareTo(a.modified),
        );

        final List<EntryModel> visitEntries = await locator<LogService>()
            .retrieveEntries(uid: student.uid, type: 'visits');

        final List<String> visitEntriesIDs =
            visitEntries.map((visitEntry) => visitEntry.entryID).toList();

        for (var i = 0; i < visitIDs.length; i++) {
          if (!visitEntriesIDs.contains(visitIDs[i])) {
            await locator<LogService>().createEntry(
              uid: student.uid,
              type: 'visits',
              entry: EntryModel(
                id: null,
                entryID: visitIDs[i],
                created: DateTime.now(),
                modified: DateTime.now(),
                logCount: 0,
              ),
            );
          }
        }

        for (var i = 0; i < visitEntries.length; i++) {
          final EntryModel visitEntry = visitEntries[i];

          if (visitEntry.entryID == null) {
            throw ('${student.firstName} ${student.lastName} has a null video entry id.');
          }

          final VisitModel visit = await locator<VisitService>()
              .retrieveVisit(visitID: visitEntry.entryID);

          visitEntry.visit = visit;

          final List<LogModel> logs = await locator<LogService>().retrieveLogs(
              uid: student.uid, type: 'visits', idOfEntry: visitEntry.id);

          Map<DateTime, List<LogModel>> logEvents =
              Map<DateTime, List<LogModel>>();

          logs.forEach(
            (LogModel log) {
              DateTime dayKey = DateTime(
                log.created.year,
                log.created.month,
                log.created.day,
              );

              if (logEvents.containsKey(dayKey)) {
                if (!logEvents[dayKey].contains(log)) {
                  logEvents[dayKey].add(log);
                }
              } else {
                logEvents[dayKey] = [log];
              }
            },
          );

          visitEntry.logEvents = logEvents;
        }

        student.visitEntries = visitEntries;

        student.visitSortBy = 'recent';

        student.visitEntries.sort(
          (a, b) => b.modified.compareTo(a.modified),
        );

        final List<StampModel> stamps =
            await locator<StampService>().getStampsForUser(uid: student.uid);

        student.stamps = stamps;

        yield StudentDetailsLoadedState(student: student);
      } catch (error) {
        yield StudentDetailsErrorState(error: error);
      }
    }

    if (event is CreateBookForStudentEvent) {
      final String studentUID = event.studentUID;
      final String title = event.title;
      final String author = event.author;
      final DateTime now = DateTime.now();

      try {
        await locator<BookService>().createBook(
          uid: studentUID,
          book: BookModel(
            author: author,
            title: title,
            created: now,
            modified: now,
            id: null,
            given: true,
            summary: null,
            conversationStarters: null,
            imgUrl: null,
            youtubeUrl: null,
          ),
        );

        _studentDetailsBlocDelegate.showMessage(
            message: 'Book added; reopen page to see results.');

        _studentDetailsBlocDelegate.clearAddTitleForm();

        yield StudentDetailsLoadedState(student: student);
      } catch (error) {
        yield StudentDetailsErrorState(error: error);
      }
    }

    if (event is CreateBookLogForStudentEvent) {
      final String studentUID = event.studentUID;
      final String idOfEntry = event.idOfEntry;
      final DateTime date = event.date;
      final bool totalLogLimitReached = event.totalLogLimitReached;

      try {
        final LogModel log = LogModel(
          created: date,
          id: null,
        );

        locator<LogService>().createLog(
          uid: studentUID,
          collection: 'books',
          idOfEntry: idOfEntry,
          log: log,
        );

        if (totalLogLimitReached) {
          await locator<StampService>().createStamp(
            uid: studentUID,
            stamp: StampModel(
              name: '15 Books Read',
              imgUrl: '$STAMP_15_BOOKS_READ',
              created: DateTime.now(),
              id: null,
            ),
          );
        }

        _studentDetailsBlocDelegate.showMessage(message: 'Log added!');
        yield StudentDetailsLoadedState(student: student);
      } catch (error) {
        yield StudentDetailsErrorState(error: error);
      }
    }

    if (event is CreateVisitLogForStudentEvent) {
      final String studentUID = event.studentUID;
      final String idOfEntry = event.idOfEntry;
      final DateTime date = event.date;
      final String name = event.visitName;

      try {
        final LogModel log = LogModel(
          created: date,
          id: null,
        );

        locator<LogService>().createLog(
          uid: studentUID,
          collection: 'visits',
          idOfEntry: idOfEntry,
          log: log,
        );

        String imgUrl;
        switch (name) {
          case 'Dayton Art Institute':
            imgUrl = STAMP_DAYTON_ART_INSTITUE;
            break;
          case 'Dayton Metro Library':
            imgUrl = STAMP_DAYTON_METRO_LIBRARY;
            break;
          case 'Five Rivers Metro Park':
            imgUrl = STAMP_FIVE_RIVERS_METROPARKS;
            break;
          case 'Boonshoft Museum of Discovery':
            imgUrl = STAMP_BOONSHOFT;
            break;
          default:
            imgUrl = STAMP_DAYTON_ART_INSTITUE;
            break;
        }

        await locator<StampService>().createStamp(
          uid: studentUID,
          stamp: StampModel(
            name: '15 Books Read',
            imgUrl: imgUrl,
            created: DateTime.now(),
            id: null,
          ),
        );

        _studentDetailsBlocDelegate.showMessage(message: 'Log added!');
        yield StudentDetailsLoadedState(student: student);
      } catch (error) {
        yield StudentDetailsErrorState(error: error);
      }
    }

    if (event is GenerateReportEvent) {
      try {
        Excel excel = Excel.createExcel();

        excel.delete('Sheet1'); // automatically creates 1 empty sheet: Sheet1

        yield StudentDetailsLoadingState(
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
        locator<ReportService>().emailReport(excel: excel);

        yield StudentDetailsLoadedState(student: student);
      } catch (error) {
        _studentDetailsBlocDelegate.showMessage(message: error.toString());
        yield StudentDetailsErrorState(error: error);
      }
    }
  }
}
