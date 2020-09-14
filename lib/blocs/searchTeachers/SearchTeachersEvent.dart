import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

abstract class SearchTeachersEvent extends Equatable {
  const SearchTeachersEvent();
}

class LoadPageEvent extends SearchTeachersEvent {
  const LoadPageEvent();

  @override
  List<Object> get props => [];
}

class TextChangedEvent extends SearchTeachersEvent {
  final String text;

  const TextChangedEvent({@required this.text});

  @override
  List<Object> get props => [text];

  @override
  String toString() => 'TextChanged { text: $text }';
}
