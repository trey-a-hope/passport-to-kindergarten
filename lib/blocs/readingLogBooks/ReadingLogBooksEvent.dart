import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:p/models/ParentLogModel.dart';

abstract class ReadingLogBooksEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class LoadPageEvent extends ReadingLogBooksEvent {
  LoadPageEvent();

  @override
  List<Object> get props => [];
}

class BooksUpdatedEvent extends ReadingLogBooksEvent {
  final List<ParentLogModel> books;

  BooksUpdatedEvent({
    @required this.books,
  });

  @override
  List<Object> get props => [
        books,
      ];
}

class UpdateSortEvent extends ReadingLogBooksEvent {
  final String sortBy;

  UpdateSortEvent({
    @required this.sortBy,
  });

  @override
  List<Object> get props => [
        sortBy,
      ];
}
