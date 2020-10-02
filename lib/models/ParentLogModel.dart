import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ParentLogModel {
  String id;
  DateTime created;
  String title;
  int logCount;

  ParentLogModel({
    @required this.id,
    @required this.created,
    @required this.title,
    @required this.logCount,
  });

  factory ParentLogModel.fromDocumentSnapshot({
    @required DocumentSnapshot ds,
  }) {
    Map<String, dynamic> data = ds.data;

    return ParentLogModel(
      id: data['id'],
      created: data['created'].toDate(),
      title: data['title'],
      logCount: data['logCount'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'created': created,
      'title': title,
      'logCount': logCount,
    };
  }
}