import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:p/models/BookModel.dart';
import 'Bloc.dart';

abstract class BookOfTheMonthDetailsDelegate {
  void showMessage({@required String message});
}

class BookOfTheMonthDetailsBloc
    extends Bloc<BookOfTheMonthDetailsEvent, BookOfTheMonthDetailsState> {
  BookOfTheMonthDetailsBloc({
    @required this.bookOfTheMonth,
  }) : super(null);

  final BookModel bookOfTheMonth;
  // BookOfTheMonthDetailsDelegate _bookOfTheMonthDetailsDelegate;

  // void setDelegate({@required BookOfTheMonthDetailsDelegate delegate}) {
  //   this._bookOfTheMonthDetailsDelegate = delegate;
  // }

  @override
  Stream<BookOfTheMonthDetailsState> mapEventToState(
      BookOfTheMonthDetailsEvent event) async* {
    if (event is LoadPageEvent) {
      yield LoadingState();

      try {
        yield LoadedState(
          bookOfTheMonth: bookOfTheMonth,
        );
      } catch (error) {
        yield ErrorState(error: error);
      }
    }
  }
}
