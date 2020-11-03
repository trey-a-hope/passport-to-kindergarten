import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

abstract class MyClassEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class LoadPageEvent extends MyClassEvent {
  LoadPageEvent();

  @override
  List<Object> get props => [];
}

class CreateBookForStudentEvent extends MyClassEvent {
  final String studentUID;
  final String title;
  final String author;

  CreateBookForStudentEvent({
    @required this.studentUID,
    @required this.title,
    @required this.author,
  });

  @override
  List<Object> get props => [
        title,
        author,
      ];
}
