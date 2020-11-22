import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class LogModel {
  String id;
  DateTime created;

  LogModel({
    @required this.id,
    @required this.created,
  });

  factory LogModel.fromDocumentSnapshot({
    @required DocumentSnapshot ds,
  }) {
    Map<String, dynamic> data = ds.data;

    return LogModel(
      id: data['id'],
      created: data['created'].toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'created': created,
    };
  }
}
