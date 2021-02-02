import 'dart:async';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:excel/excel.dart';
import 'package:flutter_mailer/flutter_mailer.dart';
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
import 'package:p/services/StampService.dart';
import 'package:p/services/ValidatorService.dart';
import 'package:p/services/VisitService.dart';
import 'package:p/widgets/AppBarWidget.dart';
import 'package:p/widgets/FullWidthButtonWidget.dart';
import 'package:p/widgets/SpinnerWidget.dart';
import 'package:path_provider/path_provider.dart';
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
    yield StudentDetailsLoadingState();

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
        final Excel excel =
            Excel.createExcel(); // automatically creates 1 empty sheet: Sheet1
        excel.delete('Sheet1');

        final CellStyle labelCellStyle = CellStyle(bold: true);

        Sheet studentSheet = excel['${student.firstName} ${student.lastName}'];

        //Add 'Book Name' label header for column 0.
        Data bookNameLabelCell = studentSheet.cell(
          CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: 0),
        );
        bookNameLabelCell.value = 'Book Name';
        bookNameLabelCell.cellStyle = labelCellStyle;

        //Add 'Log Count' label header for column 1.
        Data bookLogCountLabelCell = studentSheet.cell(
          CellIndex.indexByColumnRow(columnIndex: 1, rowIndex: 0),
        );
        bookLogCountLabelCell.value = 'Log Count';
        bookLogCountLabelCell.cellStyle = labelCellStyle;

        //Iterate over books for student.
        for (int bookCounter = 0;
            bookCounter < student.bookEntries.length;
            bookCounter++) {
          final EntryModel bookEntry = student.bookEntries[bookCounter];

          //Add book title.
          Data bookTitleCell = studentSheet.cell(
            CellIndex.indexByColumnRow(
                columnIndex: 0, rowIndex: bookCounter + 1),
          );
          bookTitleCell.value = bookEntry.book.title;

          //Add log count.
          Data bookLogCountCell = studentSheet.cell(
            CellIndex.indexByColumnRow(
                columnIndex: 1, rowIndex: bookCounter + 1),
          );
          bookLogCountCell.value = bookEntry.logCount;
        }

        //Add 'Visit Name' label header for column 2.
        Data visitNameLabelCell = studentSheet.cell(
          CellIndex.indexByColumnRow(columnIndex: 2, rowIndex: 0),
        );
        visitNameLabelCell.value = 'Visit Name';
        visitNameLabelCell.cellStyle = labelCellStyle;

        //Add 'Log Count' label header for column 3.
        Data visitLogCountLabelCell = studentSheet.cell(
          CellIndex.indexByColumnRow(columnIndex: 3, rowIndex: 0),
        );
        visitLogCountLabelCell.value = 'Log Count';
        visitLogCountLabelCell.cellStyle = labelCellStyle;

        //Iterate over visits for student.
        for (int visitCounter = 0;
            visitCounter < student.visitEntries.length;
            visitCounter++) {
          final EntryModel visitEntry = student.visitEntries[visitCounter];

          if (visitEntry.entryID == null) {
            throw ('${student.firstName} ${student.lastName} has a null visit entry id.');
          }

          //Add visit title.
          Data visitTitleCell = studentSheet.cell(
            CellIndex.indexByColumnRow(
                columnIndex: 2, rowIndex: visitCounter + 1),
          );
          visitTitleCell.value = visitEntry.visit.title;

          //Add log count.
          Data visitLogCountCell = studentSheet.cell(
            CellIndex.indexByColumnRow(
                columnIndex: 3, rowIndex: visitCounter + 1),
          );
          visitLogCountCell.value = visitEntry.logCount;
        }

        //Add 'Stamp Name' label header for column 4.
        Data stampNameLabelCell = studentSheet.cell(
          CellIndex.indexByColumnRow(columnIndex: 4, rowIndex: 0),
        );
        stampNameLabelCell.value = 'Stamp Name';
        stampNameLabelCell.cellStyle = labelCellStyle;

        //Add 'Count' label header for column 5.
        Data stampCountLabelCell = studentSheet.cell(
          CellIndex.indexByColumnRow(columnIndex: 5, rowIndex: 0),
        );
        stampCountLabelCell.value = 'Count';
        stampCountLabelCell.cellStyle = labelCellStyle;

        //Iterate over stamps for student.
        for (int stampCounter = 0;
            stampCounter < student.stamps.length;
            stampCounter++) {
          final StampModel stamp = student.stamps[stampCounter];

          //Add stamp title.
          Data stampTitleCell = studentSheet.cell(
            CellIndex.indexByColumnRow(
                columnIndex: 4, rowIndex: stampCounter + 1),
          );
          stampTitleCell.value = stamp.name;

          //Add count.
          Data stampCountCell = studentSheet.cell(
            CellIndex.indexByColumnRow(
                columnIndex: 5, rowIndex: stampCounter + 1),
          );
          stampCountCell.value = 1;
        }

        final List<int> encoded = await excel.encode();

        Directory appDocDir = await getApplicationDocumentsDirectory();

        final String excelDocPath =
            '${appDocDir.path}/Class_Report_${DateFormat('yyyy-MM-dd hh:mm').format(DateTime.now())}.xlsx';
        File(excelDocPath)
          ..createSync(recursive: true)
          ..writeAsBytesSync(encoded);

        final MailOptions mailOptions = MailOptions(
          //body: 'This is a body.',
          subject: 'Generated Class Report',
          recipients: [],
          isHTML: false,
          //bccRecipients: ['other@example.com'],
          //ccRecipients: ['third@example.com'],
          attachments: [
            excelDocPath,
          ],
        );

        final MailerResponse response = await FlutterMailer.send(mailOptions);
        String platformResponse;
        switch (response) {
          case MailerResponse.saved:
            // ios only
            platformResponse = 'mail was saved to draft';
            break;
          case MailerResponse.sent:
            // ios only
            platformResponse = 'mail was sent';
            break;
          case MailerResponse.cancelled:
            // ios only
            platformResponse = 'mail was cancelled';
            break;
          case MailerResponse.android:
            platformResponse = 'intent was successful';
            break;
          default:
            platformResponse = 'unknown';
            break;
        }

        print(platformResponse);
        yield StudentDetailsLoadedState(student: student);
      } catch (error) {
        _studentDetailsBlocDelegate.showMessage(message: error.toString());

        yield StudentDetailsLoadedState(student: student);
      }
    }
  }
}
