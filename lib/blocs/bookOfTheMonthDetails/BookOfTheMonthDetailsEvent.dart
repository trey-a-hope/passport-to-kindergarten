import 'package:equatable/equatable.dart';

abstract class BookOfTheMonthDetailsEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class LoadPageEvent extends BookOfTheMonthDetailsEvent {
  LoadPageEvent();

  @override
  List<Object> get props => [];
}
