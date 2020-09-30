import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class BookModel {
  String id;
  DateTime created;
  String bookTitle;
  int logCount;

  BookModel({
    @required this.id,
    @required this.created,
    @required this.bookTitle,
    @required this.logCount,
  });

  factory BookModel.fromDocumentSnapshot({
    @required DocumentSnapshot ds,
  }) {
    Map<String, dynamic> data = ds.data;

    return BookModel(
      id: data['id'],
      created: data['created'].toDate(),
      bookTitle: data['bookTitle'],
      logCount: data['logCount'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'created': created,
      'bookTitle': bookTitle,
      'logCount': logCount,
    };
  }
}
