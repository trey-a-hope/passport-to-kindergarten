import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:p/models/EntryModel.dart';

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
  final List<EntryModel> bookEntries;

  BooksUpdatedEvent({
    @required this.bookEntries,
  });

  @override
  List<Object> get props => [
        bookEntries,
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
  final DateTime date;
  final bool totalLogLimitReached;
  final String idOfEntry;

  CreateBookLogEvent({
    @required this.date,
    @required this.totalLogLimitReached,
    @required this.idOfEntry,
  });

  @override
  List<Object> get props => [
        date,
        totalLogLimitReached,
        idOfEntry,
      ];
}
