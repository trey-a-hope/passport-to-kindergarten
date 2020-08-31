import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:p/ServiceLocator.dart';
import 'package:p/models/UserModel.dart';
import 'package:p/services/UserService.dart';
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
