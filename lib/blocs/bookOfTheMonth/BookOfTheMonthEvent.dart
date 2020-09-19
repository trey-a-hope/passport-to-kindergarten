import 'package:equatable/equatable.dart';

abstract class BookOfTheMonthEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class LoadPageEvent extends BookOfTheMonthEvent {
  LoadPageEvent();

  @override
  List<Object> get props => [];
}
