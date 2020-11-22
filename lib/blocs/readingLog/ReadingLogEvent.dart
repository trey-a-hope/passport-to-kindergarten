import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:p/models/BookModel.dart';

abstract class ReadingLogEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class LoadPageEvent extends ReadingLogEvent {
  LoadPageEvent();

  @override
  List<Object> get props => [];
}

class BooksUpdatedEvent extends ReadingLogEvent {
  final List<BookModel> books;

  BooksUpdatedEvent({
    @required this.books,
  });

  @override
  List<Object> get props => [
        books,
      ];
}

class CreateBookEvent extends ReadingLogEvent {
  final String title;
  final String author;

  CreateBookEvent({
    @required this.title,
    @required this.author,
  });

  @override
  List<Object> get props => [
        title,
        author,
      ];
}

class CreateBookLogEvent extends ReadingLogEvent {
  final String bookID;
  final DateTime date;

  CreateBookLogEvent({
    @required this.bookID,
    @required this.date,
  });

  @override
  List<Object> get props => [
        bookID,
        date,
      ];
}
