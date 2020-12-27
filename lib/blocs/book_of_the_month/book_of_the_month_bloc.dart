import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:p/models/UserModel.dart';
import 'package:p/services/AuthService.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:p/ServiceLocator.dart';
import 'package:p/constants.dart';
import 'package:p/models/BookModel.dart';
import 'package:p/services/BookService.dart';
import 'package:p/widgets/AppBarWidget.dart';
import 'package:p/widgets/SpinnerWidget.dart';
// import 'Bloc.dart' as BOOK_OF_THE_MONTH_BP;
import 'package:p/blocs/bookOfTheMonthDetails/Bloc.dart'
    as BOOK_OF_THE_MONTH_DETAILS_BP;

import '../../ServiceLocator.dart';

part 'book_of_the_month_event.dart';
part 'book_of_the_month_state.dart';
part 'book_of_the_month_page.dart';

class BookOfTheMonthBloc
    extends Bloc<BookOfTheMonthEvent, BookOfTheMonthState> {
  BookOfTheMonthBloc() : super(LoadingState());
  UserModel _currentUser;

  @override
  Stream<BookOfTheMonthState> mapEventToState(
    BookOfTheMonthEvent event,
  ) async* {
    if (event is LoadPageEvent) {
      yield LoadingState();

      try {
        _currentUser = await locator<AuthService>().getCurrentUser();

        List<BookModel> booksOfTheMonth =
            await locator<BookService>().retrieveBooksOfTheMonth();

        yield LoadedState(
          user: _currentUser,
          booksOfTheMonth: booksOfTheMonth,
        );
      } catch (error) {
        yield ErrorState(error: error);
      }
    }
  }
}
