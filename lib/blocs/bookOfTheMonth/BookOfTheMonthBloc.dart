import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:p/ServiceLocator.dart';
import 'package:p/blocs/bookOfTheMonth/Bloc.dart';
import 'package:p/models/UserModel.dart';
import 'package:p/services/AuthService.dart';

abstract class BookOfTheMonthDelegate {
  void showMessage({@required String message});
}

class BookOfTheMonthBloc
    extends Bloc<BookOfTheMonthEvent, BookOfTheMonthState> {
  BookOfTheMonthBloc() : super(null);

  BookOfTheMonthDelegate _bookOfTheMonthDelegate;
  UserModel _currentUser;

  void setDelegate({@required BookOfTheMonthDelegate delegate}) {
    this._bookOfTheMonthDelegate = delegate;
  }

  @override
  Stream<BookOfTheMonthState> mapEventToState(
      BookOfTheMonthEvent event) async* {
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
