import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'HomeEvent.dart';
import 'HomeState.dart';

abstract class HomeDelegate {
  void showMessage({@required String message});
}

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc() : super(null);

  HomeDelegate _homeDelegate;

  void setDelegate({@required HomeDelegate delegate}) {
    this._homeDelegate = delegate;
  }

  @override
  Stream<HomeState> mapEventToState(HomeEvent event) async* {
    if (event is LoadPageEvent) {
      yield DefaultState();
    }
  }
}
