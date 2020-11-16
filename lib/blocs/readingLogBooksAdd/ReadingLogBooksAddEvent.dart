import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

abstract class ReadingLogBooksAddEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class LoadPageEvent extends ReadingLogBooksAddEvent {
  LoadPageEvent();

  @override
  List<Object> get props => [];
}

class SubmitEvent extends ReadingLogBooksAddEvent {
  final String author;
  final String bookTitle;

  SubmitEvent({
    @required this.author,
    @required this.bookTitle,
  });

  List<Object> get props => [
        author,
        bookTitle,
      ];
}
