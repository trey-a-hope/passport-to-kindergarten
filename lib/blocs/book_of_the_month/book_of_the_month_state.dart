part of 'book_of_the_month_bloc.dart';

abstract class BookOfTheMonthState extends Equatable {
  const BookOfTheMonthState();

  @override
  List<Object> get props => [];
}

class LoadingState extends BookOfTheMonthState {}

class LoadedState extends BookOfTheMonthState {
  final UserModel user;
  final List<BookModel> booksOfTheMonth;

  LoadedState({
    @required this.user,
    @required this.booksOfTheMonth,
  });

  @override
  List<Object> get props => [
        user,
        booksOfTheMonth
      ];
}

class ErrorState extends BookOfTheMonthState {
  final dynamic error;

  ErrorState({
    @required this.error,
  });

  @override
  List<Object> get props => [
        error,
      ];
}
