import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'SplashEvent.dart';
import 'SplashState.dart';

abstract class SplashDelegate {
  void showMessage({@required String message});
}

class SplashBloc extends Bloc<SplashEvent, SplashState> {
  SplashBloc() : super(null);

  SplashDelegate _splashDelegate;

  void setDelegate({@required SplashDelegate delegate}) {
    this._splashDelegate = delegate;
  }

  @override
  Stream<SplashState> mapEventToState(SplashEvent event) async* {
    if (event is LoadPageEvent) {
      yield DefaultState();
    }
  }
}
