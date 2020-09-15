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
  void clearForm();
}

class SignupBloc extends Bloc<SignupEvent, SignupState> {
  SignupBloc() : super(null);
  SignupBlocDelegate _signupBlocDelegate;
  bool _isTeacher = true;
  DateTime _selectedDate = DateTime.now();
  UserModel _selectedTeacher;

  void setDelegate({
    @required SignupBlocDelegate delegate,
  }) {
    this._signupBlocDelegate = delegate;
  }

  @override
  Stream<SignupState> mapEventToState(SignupEvent event) async* {
    if (event is LoadPageEvent) {
      yield TeacherState(
        autoValidate: false,
        formKey: GlobalKey<FormState>(),
      );
    }

    if (event is ToggleProfileTypeEvent) {
      _signupBlocDelegate.clearForm();
      _isTeacher = !_isTeacher;
      if (_isTeacher) {
        yield TeacherState(
          autoValidate: false,
          formKey: GlobalKey<FormState>(),
        );
      } else {
        yield ParentState(
          autoValidate: false,
          formKey: GlobalKey<FormState>(),
          selectedDate: _selectedDate,
        );
      }
    }

    if (event is SelectDateEvent) {
      this._selectedDate = event.selectedDate;
    }

    if (event is SelectTeacherEvent) {
      this._selectedTeacher = event.selectedTeacher;
    }

    if (event is Signup) {
      UserModel user;
      final String email = event.email;
      final String password = event.password;
      final String firstName = event.firstName;
      final String lastName = event.lastName;
      final GlobalKey<FormState> formKey = event.formKey;

      if (formKey.currentState.validate()) {
        yield SigningIn();

        try {
          AuthResult authResult =
              await locator<AuthService>().createUserWithEmailAndPassword(
            email: email,
            password: password,
          );

          final FirebaseUser firebaseUser = authResult.user;

          if (_isTeacher) {
            final String school = event.school;

            user = UserModel(
              imgUrl: DUMMY_PROFILE_PHOTO_URL,
              isAdmin: false,
              email: email,
              fcmToken: null,
              created: DateTime.now(),
              uid: firebaseUser.uid,
              firstName: firstName,
              lastName: lastName,
              profileType: PROFILE_TYPE.TEACHER.name,
              school: school,
              teacherID: null,
              parentFirstName: null,
              parentLastName: null,
            );
          } else {
            final String parentFirstName = event.parentFirstName;
            final String parentLastName = event.parentLastName;

            user = UserModel(
              imgUrl: DUMMY_PROFILE_PHOTO_URL,
              isAdmin: false,
              email: email,
              fcmToken: null,
              created: DateTime.now(),
              uid: firebaseUser.uid,
              firstName: firstName,
              lastName: lastName,
              profileType: PROFILE_TYPE.PARENT.name,
              school: null,
              teacherID: _selectedTeacher.uid, //use selected teacher
              parentFirstName: parentFirstName,
              parentLastName: parentLastName,
            );
          }
          await locator<UserService>().createUser(user: user);

          _signupBlocDelegate.navigateHome();
        } catch (error) {
          _signupBlocDelegate.showMessage(message: error.toString());

          yield _isTeacher
              ? TeacherState(
                  autoValidate: true,
                  formKey: event.formKey,
                )
              : ParentState(
                  autoValidate: true,
                  formKey: event.formKey,
                  selectedDate: _selectedDate,
                );
        }
      }
    }
  }
}
