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
    Map<String, dynamic> data = ds.data();

    return LogModel(
      id: data['id'],
      created: data['created'].toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    //Add 12 hours to date to prevent UTC issues when saving to database, (it subtracts 4 hours from 12am, giving the wrong date)
    created = created.add(Duration(hours: 12));

    return {
      'id': id,
      'created': created,
    };
  }
}
