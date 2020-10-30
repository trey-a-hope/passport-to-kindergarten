import 'package:flutter/material.dart';

class BookOfTheMonthModel {
  String title;
  String assetImagePath;
  String author;
  bool given;

  BookOfTheMonthModel({
    @required this.title,
    @required this.assetImagePath,
    @required this.author,
    @required this.given,
  });
}
