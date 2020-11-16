import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class BookModel {
  String id;
  DateTime created;
  DateTime modified;
  String title;
  String author;
  int logCount;
  String assetImagePath;
  bool given;
  String summary;
  List<String> conversationStarters;

  BookModel({
    @required this.id,
    @required this.created,
    @required this.modified,
    @required this.title,
    @required this.author,
    @required this.logCount,
    this.assetImagePath,
    this.given,
    this.summary,
    this.conversationStarters,
  });

  factory BookModel.fromDocumentSnapshot({
    @required DocumentSnapshot ds,
  }) {
    Map<String, dynamic> data = ds.data;

    return BookModel(
      id: data['id'],
      created: data['created'].toDate(),
      modified: data['modified'].toDate(),
      title: data['title'],
      author: data['author'],
      logCount: data['logCount'],
      assetImagePath: data['assetImagePath'],
      // given: data['given'],
      // summary: data['summary'],
      // conversationStarters: data['conversationStarters'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'created': created,
      'modified': modified,
      'title': title,
      'author': author,
      'logCount': logCount,
      'assetImagePath': assetImagePath,
      'given': given,
      'summary': summary,
      'conversationStarters': conversationStarters,
    };
  }
}
