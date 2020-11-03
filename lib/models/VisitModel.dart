import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class VisitModel {
  String id;
  DateTime created;
  DateTime modified;
  String title;
  int logCount;

  VisitModel({
    @required this.id,
    @required this.created,
    @required this.modified,
    @required this.title,
    @required this.logCount,
  });

  factory VisitModel.fromDocumentSnapshot({
    @required DocumentSnapshot ds,
  }) {
    Map<String, dynamic> data = ds.data;

    return VisitModel(
      id: data['id'],
      created: data['created'].toDate(),
      modified: data['modified'].toDate(),
      title: data['title'],
      logCount: data['logCount'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'created': created,
      'modified': modified,
      'title': title,
      'logCount': logCount,
    };
  }
}
