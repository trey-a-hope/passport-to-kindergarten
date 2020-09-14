import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:p/services/AuthService.dart';
import 'dart:async';

import '../../ServiceLocator.dart';
import 'LoginEvent.dart';
import 'LoginState.dart';

abstract class LoginBlocDelegate {
  void showMessage({@required String message});
}

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc() : super(null);
  LoginBlocDelegate _loginBlocDelegate;

  void setDelegate({
    @required LoginBlocDelegate delegate,
  }) {
    this._loginBlocDelegate = delegate;
  }

  @override
  Stream<LoginState> mapEventToState(LoginEvent event) async* {
    if (event is LoadPageEvent) {
      yield LoginNotStarted(
        autoValidate: false,
        formKey: GlobalKey<FormState>(),
      );
    }

    if (event is Login) {
      final String email = event.email;
      final String password = event.password;

      yield LoggingIn();
      try {
        await locator<AuthService>()
            .signInWithEmailAndPassword(email: email, password: password);
      } catch (error) {
        _loginBlocDelegate.showMessage(message: error.message);

        yield LoginNotStarted(
          autoValidate: true,
          formKey: event.formKey,
        );
      }
    }
  }
}
