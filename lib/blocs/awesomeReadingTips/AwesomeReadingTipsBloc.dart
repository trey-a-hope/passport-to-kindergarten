import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:p/ServiceLocator.dart';
import 'package:p/models/UserModel.dart';
import 'package:p/services/AuthService.dart';

import 'Bloc.dart';

abstract class AwesomeReadingTipsBlocDelegate {
  void showMessage({@required String message});
}

class AwesomeReadingTipsBloc
    extends Bloc<AwesomeReadingTipsEvent, AwesomeReadingTipsState> {
  AwesomeReadingTipsBloc() : super(null);

  // AwesomeReadingTipsBlocDelegate _awesomeReadingTipsBlocDelegate;
  UserModel _currentUser;

  // void setDelegate({@required AwesomeReadingTipsBlocDelegate delegate}) {
  //   this._awesomeReadingTipsBlocDelegate = delegate;
  // }

  @override
  Stream<AwesomeReadingTipsState> mapEventToState(
      AwesomeReadingTipsEvent event) async* {
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
