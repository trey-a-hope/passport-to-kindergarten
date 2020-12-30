import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_mailer/flutter_mailer.dart';
import 'package:intl/intl.dart';
import 'package:p/ServiceLocator.dart';
import 'package:p/constants.dart';
import 'package:p/models/BookModel.dart';
import 'package:p/models/EntryModel.dart';
import 'package:p/models/LogModel.dart';
import 'package:p/models/StampModel.dart';
import 'package:p/models/UserModel.dart';
import 'package:p/models/VisitModel.dart';
import 'package:p/services/AuthService.dart';
import 'package:p/services/BookService.dart';
import 'package:p/services/LogService.dart';
import 'package:p/services/StampService.dart';
import 'package:p/services/UserService.dart';
import 'package:p/services/VisitService.dart';
import 'package:path_provider/path_provider.dart';
import 'MyClassEvent.dart';
import 'MyClassState.dart';
import 'package:excel/excel.dart';

abstract class MyClassBlocDelegate {
  void showMessage({@required String message});
  void clearAddTitleForm();
}

class MyClassBloc extends Bloc<MyClassEvent, MyClassState> {
  MyClassBloc() : super(null);

  MyClassBlocDelegate _myClassBlocDelegate;
  UserModel _currentUser;
  List<UserModel> _students;
  bool _studentSelected = false;

  void setDelegate({@required MyClassBlocDelegate delegate}) {
    this._myClassBlocDelegate = delegate;
  }

  @override
  Stream<MyClassState> mapEventToState(MyClassEvent event) async* {
    if (event is LoadPageEvent) {
      yield LoadingState();

      try {
        _currentUser = await locator<AuthService>().getCurrentUser();

        Stream<QuerySnapshot> studentsStream = await locator<UserService>()
            .streamStudentsForTeacher(teacherUID: _currentUser.uid);

        studentsStream.listen(
          (QuerySnapshot event) {
            List<UserModel> students = event.documents
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
      _students = event.students;

      for (int studentCount = 0;
          studentCount < _students.length;
          studentCount++) {
        final UserModel student = _students[studentCount];

        //Book Entries
        final List<EntryModel> bookEntries = await locator<LogService>()
            .retrieveEntries(uid: student.uid, type: 'books');

        for (var i = 0; i < bookEntries.length; i++) {
          final EntryModel bookEntry = bookEntries[i];

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

        //Visit Entries
        final List<EntryModel> visitEntries = await locator<LogService>()
            .retrieveEntries(uid: student.uid, type: 'visits');

        for (var i = 0; i < visitEntries.length; i++) {
          final EntryModel visitEntry = visitEntries[i];

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
      }

      yield LoadedState(
        user: _currentUser,
        students: _students,
        studentSelected: _studentSelected,
      );
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

        _myClassBlocDelegate.showMessage(message: 'Book added; reopen page to see results.');

        _myClassBlocDelegate.clearAddTitleForm();
      } catch (error) {
        yield ErrorState(error: error);
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

        _myClassBlocDelegate.showMessage(message: 'Log added!');
      } catch (error) {
        yield ErrorState(error: error);
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

        _myClassBlocDelegate.showMessage(message: 'Log added!');
      } catch (error) {
        yield ErrorState(error: error);
      }
    }

    if (event is StudentSelectedEvent) {
      _studentSelected = event.studentSelected;

      yield LoadedState(
        user: _currentUser,
        students: _students,
        studentSelected: _studentSelected,
      );
    }

    if (event is GenerateReportEvent) {
      try {
        final Excel excel =
            Excel.createExcel(); // automatically creates 1 empty sheet: Sheet1
        excel.delete('Sheet1');

        final CellStyle labelCellStyle = CellStyle(bold: true);

        for (int i = 0; i < _students.length; i++) {
          final UserModel student = _students[i];

          Sheet studentSheet =
              excel['${student.firstName} ${student.lastName}'];

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

      } catch (error) {
        _myClassBlocDelegate.showMessage(message: error.toString());

        yield LoadedState(
          user: _currentUser,
          students: _students,
          studentSelected: _studentSelected,
        );
      }
    }
  }
}
