import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:p/ServiceLocator.dart';
import 'package:p/constants.dart';
import 'package:p/models/BookModel.dart';
import 'package:p/models/LogModel.dart';
import 'package:p/models/StampModel.dart';
import 'package:p/models/UserModel.dart';
import 'package:p/models/VisitModel.dart';
import 'package:p/services/AuthService.dart';
import 'package:p/services/LogService.dart';
import 'package:p/services/UserService.dart';
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

        final List<BookModel> books =
            await locator<LogService>().getBooksForUser(uid: student.uid);
        student.books = books;

        student.bookSortBy = 'recent';

        books.sort(
          (a, b) => b.modified.compareTo(a.modified),
        );

        for (int bookCount = 0; bookCount < books.length; bookCount++) {
          final BookModel book = books[bookCount];
          final List<LogModel> logs = await locator<LogService>().getLogs(
              uid: student.uid, collection: 'books', documentID: book.id);

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

          book.logEvents = logEvents;
        }

        final List<VisitModel> visits =
            await locator<LogService>().getVisitsForUser(uid: student.uid);
        student.visits = visits;

        student.visitSortBy = 'recent';

        visits.sort(
          (a, b) => b.modified.compareTo(a.modified),
        );

        for (int visitCount = 0; visitCount < visits.length; visitCount++) {
          final VisitModel visit = visits[visitCount];
          final List<LogModel> logs = await locator<LogService>().getLogs(
              uid: student.uid, collection: 'visits', documentID: visit.id);

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

          visit.logEvents = logEvents;
        }

        final List<StampModel> stamps =
            await locator<UserService>().getStampsForUser(uid: student.uid);
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
        await locator<LogService>().createBookForUser(
          uid: studentUID,
          book: BookModel(
            author: author,
            title: title,
            logCount: 0,
            created: now,
            modified: now,
            id: null,
            given: true,
            summary: null,
            conversationStarters: null,
            assetImagePath: null,
          ),
        );

        _myClassBlocDelegate.showMessage(message: 'Book added!');

        _myClassBlocDelegate.clearAddTitleForm();
      } catch (error) {
        yield ErrorState(error: error);
      }
    }

    if (event is CreateBookLogForStudentEvent) {
      final String studentUID = event.studentUID;
      final String bookID = event.bookID;
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
          documentID: bookID,
          log: log,
        );

        if (totalLogLimitReached) {
          await locator<UserService>().createStamp(
            uid: studentUID,
            stamp: StampModel(
              name: '15 Books Read',
              assetImagePath: ASSET_p2k20_app_stamp_15_books_read,
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
      final String visitID = event.visitID;
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
          documentID: visitID,
          log: log,
        );

        String assetImagePath;
        switch (name) {
          case 'Dayton Art Institute':
            assetImagePath = ASSET_stamp_dayton_art_institute;
            break;
          case 'Dayton Metro Library':
            assetImagePath = ASSET_dayton_metro_library_logo;
            break;
          case 'Five Rivers Metro Park':
            assetImagePath = ASSET_five_rivers_metroparks_logo;
            break;
          case 'Boonshoft Museum of Discovery':
            assetImagePath = ASSET_boonshoft_logo;
            break;
          default:
            assetImagePath = ASSET_stamp_dayton_art_institute;
            break;
        }

        await locator<UserService>().createStamp(
          uid: studentUID,
          stamp: StampModel(
            name: '15 Books Read',
            assetImagePath: assetImagePath,
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
        yield LoadingState();
        final Excel excel =
            Excel.createExcel(); // automatically creates 1 empty sheet: Sheet1

        /* 
      * sheetObject.updateCell(cell, value, { CellStyle (Optional)});
      * sheetObject created by calling - // Sheet sheetObject = excel['SheetName'];
      * cell can be identified with Cell Address or by 2D array having row and column Index;
      * Cell Style options are optional
      */

        Sheet sheetObject = excel['SheetName'];

        CellStyle cellStyle = CellStyle(
            backgroundColorHex: "#1AFF1A",
            fontFamily: getFontFamily(FontFamily.Calibri));

        cellStyle.underline = Underline.Single; // or Underline.Double

        var cell = sheetObject.cell(CellIndex.indexByString("A1"));
        cell.value = 8; // dynamic values support provided;
        cell.cellStyle = cellStyle;

        // printing cell-type
        print("CellType: " + cell.cellType.toString());

        ///
        /// Inserting and removing column and rows

        // insert column at index = 8
        sheetObject.insertColumn(8);

        // remove column at index = 18
        sheetObject.removeColumn(18);

        // insert row at index = 82
        sheetObject.removeRow(82);

        // remove row at index = 80
        sheetObject.removeRow(80);

        final List<int> encoded = await excel.encode();

        Directory appDocDir = await getApplicationDocumentsDirectory();

        File(
            "${appDocDir.path}/Class_Report_${DateFormat('yyyy-MM-dd hh:mm').format(DateTime.now())}.xlsx")
          ..createSync(recursive: true)
          ..writeAsBytesSync(encoded);

        // for (int i = 0; i < _students.length; i++) {
        //   final UserModel student = _students[i];

        //   print(student.firstName);
        // }
        _myClassBlocDelegate.showMessage(
            message: 'Report generated, go to the files app on your phone.');

        yield LoadedState(
          user: _currentUser,
          students: _students,
          studentSelected: _studentSelected,
        );
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
