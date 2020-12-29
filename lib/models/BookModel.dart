import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class BookModel {
  String id;
  DateTime created;
  DateTime modified;
  String title;
  String author;
  String imgUrl;
  bool given;
  String summary;
  List<String> conversationStarters;
  String youtubeUrl;

  // Map<DateTime, List<LogModel>> logEvents;

  BookModel({
    @required this.id,
    @required this.created,
    @required this.modified,
    @required this.title,
    @required this.author,
    @required this.imgUrl,
    @required this.given,
    @required this.summary,
    @required this.conversationStarters,
    @required this.youtubeUrl,
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
      imgUrl: data['imgUrl'],
      given: data['given'],
      summary: data['summary'],
      conversationStarters: data['conversationStarters'] == null
          ? []
          : List.from(
              data['conversationStarters'],
            ),
      youtubeUrl: data['youtubeUrl'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'created': created,
      'modified': modified,
      'title': title,
      'author': author,
      'imgUrl': imgUrl,
      'given': given,
      'summary': summary,
      'conversationStarters': conversationStarters,
      'youtubeUrl': youtubeUrl,
    };
  }
}
