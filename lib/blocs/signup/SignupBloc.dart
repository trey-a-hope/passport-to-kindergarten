import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:p/models/UserModel.dart';
import 'package:p/services/AuthService.dart';
import 'package:p/services/UserService.dart';
import 'dart:async';
import '../../ServiceLocator.dart';
import '../../constants.dart';
import 'SignupEvent.dart';
import 'SignupState.dart';

abstract class SignupBlocDelegate {
  void navigateHome();
  void showMessage({@required String message});
}

class SignupBloc extends Bloc<SignupEvent, SignupState> {
  SignupBloc() : super(null);
  SignupBlocDelegate _signupBlocDelegate;

  void setDelegate({
    @required SignupBlocDelegate delegate,
  }) {
    this._signupBlocDelegate = delegate;
  }

  @override
  Stream<SignupState> mapEventToState(SignupEvent event) async* {
    if (event is LoadPageEvent) {
      yield SignupNotStarted(
        autoValidate: false,
        formKey: GlobalKey<FormState>(),
      );
    }

    if (event is Signup) {
      final String email = event.email;
      final String password = event.password;
      final GlobalKey<FormState> formKey = event.formKey;

      try {
        if (formKey.currentState.validate()) {
          yield SigningIn();

          AuthResult authResult =
              await locator<AuthService>().createUserWithEmailAndPassword(
            email: email,
            password: password,
          );

          final FirebaseUser firebaseUser = authResult.user;

          UserModel user = UserModel(
            imgUrl: DUMMY_PROFILE_PHOTO_URL,
            isAdmin: false,
            email: email,
            fcmToken: '',
            created: DateTime.now(),
            uid: firebaseUser.uid,
            firstName: '',
            lastName: '',
          );

          await locator<UserService>().createUser(user: user);

          _signupBlocDelegate.navigateHome();
        }
      } catch (error) {
        _signupBlocDelegate.showMessage(message: error.toString());

        yield SignupNotStarted(
          autoValidate: true,
          formKey: event.formKey,
        );
      }
    }
  }
}
