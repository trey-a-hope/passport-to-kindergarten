import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class LogModel {
  String id;
  DateTime created;
  String description;
  String bookTitle;

  LogModel({
    @required this.id,
    @required this.created,
    @required this.description,
    @required this.bookTitle,
  });

  factory LogModel.fromDocumentSnapshot({
    @required DocumentSnapshot ds,
  }) {
    Map<String, dynamic> data = ds.data;

    return LogModel(
      id: data['id'],
      created: data['created'].toDate(),
      description: data['description'],
      bookTitle: data['bookTitle'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'created': created,
      'description': description,
      'bookTitle': bookTitle,
    };
  }
}
