import 'package:flutter/material.dart';

class BookOfTheMonthModel {
  String title;
  String assetImagePath;
  String author;
  bool given;
  String summary;
  List<String> conversationStarters;

  BookOfTheMonthModel({
    @required this.title,
    @required this.assetImagePath,
    @required this.author,
    @required this.given,
    @required this.summary,
    @required this.conversationStarters,
  });
}
