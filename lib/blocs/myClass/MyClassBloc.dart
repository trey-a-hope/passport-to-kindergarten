import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_mailer/flutter_mailer.dart';
import 'package:intl/intl.dart';
import 'package:p/ServiceLocator.dart';
import 'package:p/constants.dart';
import 'package:p/models/BookModel.dart';
import 'package:p/models/LogModel.dart';
import 'package:p/models/StampModel.dart';
import 'package:p/models/UserModel.dart';
import 'package:p/models/VisitModel.dart';
import 'package:p/services/AuthService.dart';
import 'package:p/services/StampService.dart';
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
      // _students = event.students;

      // for (int studentCount = 0;
      //     studentCount < _students.length;
      //     studentCount++) {
      //   final UserModel student = _students[studentCount];

      //   final List<BookModel> books =
      //       await locator<LogService>().getBooksForUser(uid: student.uid);
      //   student.books = books;

      //   student.bookSortBy = 'recent';

      //   books.sort(
      //     (a, b) => b.modified.compareTo(a.modified),
      //   );

      //   for (int bookCount = 0; bookCount < books.length; bookCount++) {
      //     final BookModel book = books[bookCount];
      //     final List<LogModel> logs = await locator<LogService>().getLogs(
      //         uid: student.uid, collection: 'books', documentID: book.id);

      //     Map<DateTime, List<LogModel>> logEvents =
      //         Map<DateTime, List<LogModel>>();

      //     logs.forEach(
      //       (LogModel log) {
      //         DateTime dayKey = DateTime(
      //           log.created.year,
      //           log.created.month,
      //           log.created.day,
      //         );

      //         if (logEvents.containsKey(dayKey)) {
      //           if (!logEvents[dayKey].contains(log)) {
      //             logEvents[dayKey].add(log);
      //           }
      //         } else {
      //           logEvents[dayKey] = [log];
      //         }
      //       },
      //     );

      //     // book.logEvents = logEvents;
      //   }

      //   final List<VisitModel> visits =
      //       await locator<LogService>().getVisitsForUser(uid: student.uid);
      //   student.visits = visits;

      //   student.visitSortBy = 'recent';

      //   visits.sort(
      //     (a, b) => b.modified.compareTo(a.modified),
      //   );

      //   for (int visitCount = 0; visitCount < visits.length; visitCount++) {
      //     final VisitModel visit = visits[visitCount];
      //     final List<LogModel> logs = await locator<LogService>().getLogs(
      //         uid: student.uid, collection: 'visits', documentID: visit.id);

      //     Map<DateTime, List<LogModel>> logEvents =
      //         Map<DateTime, List<LogModel>>();

      //     logs.forEach(
      //       (LogModel log) {
      //         DateTime dayKey = DateTime(
      //           log.created.year,
      //           log.created.month,
      //           log.created.day,
      //         );

      //         if (logEvents.containsKey(dayKey)) {
      //           if (!logEvents[dayKey].contains(log)) {
      //             logEvents[dayKey].add(log);
      //           }
      //         } else {
      //           logEvents[dayKey] = [log];
      //         }
      //       },
      //     );

      //     visit.logEvents = logEvents;
      //   }

      //   final List<StampModel> stamps =
      //       await locator<UserService>().getStampsForUser(uid: student.uid);
      //   student.stamps = stamps;
      // }

      // yield LoadedState(
      //   user: _currentUser,
      //   students: _students,
      //   studentSelected: _studentSelected,
      // );
    }

    if (event is CreateBookForStudentEvent) {
      final String studentUID = event.studentUID;
      final String title = event.title;
      final String author = event.author;
      final DateTime now = DateTime.now();

      try {
        // await locator<LogService>().createBookForUser(
        //   uid: studentUID,
        //   book: BookModel(
        //     author: author,
        //     title: title,
        //     logCount: 0,
        //     created: now,
        //     modified: now,
        //     id: null,
        //     given: true,
        //     summary: null,
        //     conversationStarters: null,
        //     assetImagePath: null,
        //   ),
        // );

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

        // locator<LogService>().createLog(
        //   uid: studentUID,
        //   collection: 'books',
        //   documentID: bookID,
        //   log: log,
        // );//todo:

        if (totalLogLimitReached) {
          // await locator<UserService>().createStamp(
          //   uid: studentUID,
          //   stamp: StampModel(
          //     name: '15 Books Read',
          //     assetImagePath: ASSET_p2k20_app_stamp_15_books_read,
          //     created: DateTime.now(),
          //     id: null,
          //   ),
          // );//todo:
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

        // locator<LogService>().createLog(
        //   uid: studentUID,
        //   collection: 'visits',
        //   documentID: visitID,
        //   log: log,
        // );

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
              bookCounter < student.books.length;
              bookCounter++) {
            final BookModel book = student.books[bookCounter];

            //Add book title.
            Data bookTitleCell = studentSheet.cell(
              CellIndex.indexByColumnRow(
                  columnIndex: 0, rowIndex: bookCounter + 1),
            );
            bookTitleCell.value = book.title;

            //Add log count.
            Data bookLogCountCell = studentSheet.cell(
              CellIndex.indexByColumnRow(
                  columnIndex: 1, rowIndex: bookCounter + 1),
            );
            // bookLogCountCell.value = book.logCount;//todo
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
              visitCounter < student.visits.length;
              visitCounter++) {
            final VisitModel visit = student.visits[visitCounter];

            //Add visit title.
            Data visitTitleCell = studentSheet.cell(
              CellIndex.indexByColumnRow(
                  columnIndex: 2, rowIndex: visitCounter + 1),
            );
            visitTitleCell.value = visit.title;

            //Add log count.
            Data visitLogCountCell = studentSheet.cell(
              CellIndex.indexByColumnRow(
                  columnIndex: 3, rowIndex: visitCounter + 1),
            );
            // visitLogCountCell.value = visit.logCount;//todo:
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
          recipients: ['a@a.com'],
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

        // for (var table in openExcel.tables.keys) {
        //   print(table); //sheet Name
        //   print(excel.tables[table].maxCols);
        //   print(excel.tables[table].maxRows);
        //   for (var row in excel.tables[table].rows) {
        //     print("$row");
        //   }
        // }

        // _myClassBlocDelegate.showMessage(
        //     message: 'Report generated, go to the files app on your phone.');

        // yield LoadedState(
        //   user: _currentUser,
        //   students: _students,
        //   studentSelected: _studentSelected,
        // );
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
