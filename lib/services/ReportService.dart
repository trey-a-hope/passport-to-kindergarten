import 'dart:io';

import 'package:excel/excel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:intl/intl.dart';
import 'package:p/models/EntryModel.dart';
import 'package:p/models/StampModel.dart';
import 'package:p/models/UserModel.dart';
import 'package:path_provider/path_provider.dart';

abstract class IReportService {
  Future<Excel> buildStudentReport({
    @required Excel excel,
    @required UserModel student,
  });
  Future<void> emailReport({
    @required Excel excel,
  });
}

class ReportService extends IReportService {
  final CellStyle labelCellStyle = CellStyle(bold: true);

  @override
  Future<void> emailReport({
    @required Excel excel,
  }) async {
    final List<int> encoded = await excel.encode();

    Directory appDocDir = await getApplicationDocumentsDirectory();

    final String excelDocPath =
        '${appDocDir.path}/Class_Report_${DateFormat('yyyy-MM-dd hh:mm').format(DateTime.now())}.xlsx';
    File(excelDocPath)
      ..createSync(recursive: true)
      ..writeAsBytesSync(encoded);

    final Email email = Email(
      body: '',
      subject: 'Generated Class Report',
      recipients: [],
      attachmentPaths: [excelDocPath],
      isHTML: false,
    );

    return FlutterEmailSender.send(email).then((value) {
      return;
    }).catchError((error) {
      throw Exception(error.toString());
    }).whenComplete(
      () => print('done!'),
    );
  }

  @override
  Future<Excel> buildStudentReport({
    @required Excel excel,
    @required UserModel student,
  }) async {
    try {
      print('${student.firstName} ${student.lastName}');

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
          CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: bookCounter + 1),
        );
        bookTitleCell.value = bookEntry.book.title;

        //Add log count.
        Data bookLogCountCell = studentSheet.cell(
          CellIndex.indexByColumnRow(columnIndex: 1, rowIndex: bookCounter + 1),
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

      return excel;
    } catch (error) {
      throw Exception(
        error.toString(),
      );
    }
  }
}
