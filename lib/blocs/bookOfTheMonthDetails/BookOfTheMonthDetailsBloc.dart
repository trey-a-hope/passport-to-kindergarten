import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:p/ServiceLocator.dart';
import 'package:p/models/UserModel.dart';
import 'package:p/services/AuthService.dart';

import 'Bloc.dart';

abstract class BookOfTheMonthDetailsDelegate {
  void showMessage({@required String message});
}

class BookOfTheMonthDetailsBloc
    extends Bloc<BookOfTheMonthDetailsEvent, BookOfTheMonthDetailsState> {
  BookOfTheMonthDetailsBloc() : super(null);

  BookOfTheMonthDetailsDelegate _bookOfTheMonthDetailsDelegate;
  UserModel _currentUser;

  void setDelegate({@required BookOfTheMonthDetailsDelegate delegate}) {
    this._bookOfTheMonthDetailsDelegate = delegate;
  }

  @override
  Stream<BookOfTheMonthDetailsState> mapEventToState(
      BookOfTheMonthDetailsEvent event) async* {
    if (event is LoadPageEvent) {
      yield LoadingState();

      try {
        _currentUser = await locator<AuthService>().getCurrentUser();
        yield LoadedState(user: _currentUser);
      } catch (error) {
        yield ErrorState(error: error);
      }
    }
  }
}
