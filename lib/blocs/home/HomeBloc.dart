import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:p/ServiceLocator.dart';
import 'package:p/models/UserModel.dart';
import 'package:p/services/AuthService.dart';

import 'HomeEvent.dart';
import 'HomeState.dart';

abstract class HomeDelegate {
  void showMessage({@required String message});
}

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc() : super(null);

  HomeDelegate _homeDelegate;
  UserModel _currentUser;

  void setDelegate({@required HomeDelegate delegate}) {
    this._homeDelegate = delegate;
  }

  @override
  Stream<HomeState> mapEventToState(HomeEvent event) async* {
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
