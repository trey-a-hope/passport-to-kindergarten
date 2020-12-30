import 'dart:async';
import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:excel/excel.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_mailer/flutter_mailer.dart';
import 'package:intl/intl.dart';
import 'package:p/ServiceLocator.dart';
import 'package:p/blocs/myClass/Bloc.dart';
import 'package:p/constants.dart';
import 'package:p/models/BookModel.dart';
import 'package:p/models/VisitModel.dart';
import 'package:p/models/EntryModel.dart';
import 'package:p/models/StampModel.dart';
import 'package:p/models/UserModel.dart';
import 'package:p/services/BookService.dart';
import 'package:p/services/LogService.dart';
import 'package:p/services/ModalService.dart';
import 'package:p/services/StampService.dart';
import 'package:p/services/UserService.dart';
import 'package:p/services/VisitService.dart';
import 'package:p/widgets/SpinnerWidget.dart';
import 'package:path_provider/path_provider.dart';

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
      yield LoadingState();

      try {
       _booksOfTheMonth =
            await locator<BookService>().retrieveBooksOfTheMonth();

        final List<UserModel> teachers =
            await locator<UserService>().retrieveTeachers();

        _teacherStudentMap =
            Map<UserModel, List<UserModel>>();

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
      final UserModel teacher = event.teacher;
      final List<UserModel> students = event.students;

      try {
        yield LoadingState();

        final Excel excel =
            Excel.createExcel(); // automatically creates 1 empty sheet: Sheet1
        excel.delete('Sheet1');

        final CellStyle labelCellStyle = CellStyle(bold: true);

        for (int i = 0; i < students.length; i++) {
          final UserModel student = students[i];

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

          //Fetch book entries.
          final List<EntryModel> bookEntries = await locator<LogService>()
              .retrieveEntries(uid: student.uid, type: 'books');

          for (int bookEntryCount = 0;
              bookEntryCount < bookEntries.length;
              bookEntryCount++) {
            final EntryModel bookEntry = bookEntries[bookEntryCount];

            //Fetch book for the entry.
            final BookModel book = await locator<BookService>()
                .retrieveBook(bookID: bookEntry.entryID);
            bookEntry.book = book;
          }

          student.bookEntries = bookEntries;

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

          //Fetch visit entries.
          final List<EntryModel> visitEntries = await locator<LogService>()
              .retrieveEntries(uid: student.uid, type: 'visits');

          for (int visitEntryCount = 0;
              visitEntryCount < visitEntries.length;
              visitEntryCount++) {
            final EntryModel visitEntry = visitEntries[visitEntryCount];

            //Fetch visit for the entry.
            final VisitModel visit = await locator<VisitService>()
                .retrieveVisit(visitID: visitEntry.entryID);
            visitEntry.visit = visit;
          }

          student.visitEntries = visitEntries;

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

          List<StampModel> stamps =
              await locator<StampService>().getStampsForUser(uid: student.uid);
          student.stamps = stamps;

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
            '${appDocDir.path}/Class_Report_For_${teacher.firstName}_${teacher.lastName}_${DateFormat('yyyy-MM-dd hh:mm').format(DateTime.now())}.xlsx';

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
