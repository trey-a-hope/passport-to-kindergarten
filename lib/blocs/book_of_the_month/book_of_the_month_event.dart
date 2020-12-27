part of 'book_of_the_month_bloc.dart';

abstract class BookOfTheMonthEvent extends Equatable {
  const BookOfTheMonthEvent();

  @override
  List<Object> get props => [];
}

class LoadPageEvent extends BookOfTheMonthEvent {
  LoadPageEvent();

  @override
  List<Object> get props => [];
}
