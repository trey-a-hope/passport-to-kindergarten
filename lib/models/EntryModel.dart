import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:p/models/BookModel.dart';
import 'package:p/models/VisitModel.dart';

import 'LogModel.dart';

class EntryModel {
  String id;
  String entryID;
  DateTime created;
  DateTime modified;
  int logCount;

  Map<DateTime, List<LogModel>> logEvents;
  BookModel book;
  VisitModel visit;

  EntryModel({
    @required this.id,
    @required this.entryID,
    @required this.created,
    @required this.modified,
    @required this.logCount,
  });

  factory EntryModel.fromDocSnapshot({
    @required DocumentSnapshot ds,
  }) {
    Map<String, dynamic> data = ds.data;

    return EntryModel(
      id: data['id'],
      entryID: data['entryID'],
      created: data['created'].toDate(),
      modified: data['modified'].toDate(),
      logCount: data['logCount'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'entryID': entryID,
      'created': created,
      'modified': modified,
      'logCount': logCount,
    };
  }
}
