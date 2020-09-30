import 'package:cloud_firestore/cloud_firestore.dart';
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
