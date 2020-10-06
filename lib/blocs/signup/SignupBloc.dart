import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:p/constants.dart';
import 'package:p/models/UserModel.dart';
import 'package:p/services/AuthService.dart';
import 'package:p/services/StorageService.dart';
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

  PROFILE_TYPE _profile_type = PROFILE_TYPE.SUPER_ADMIN;
  static DateTime now = DateTime.now();
  DateTime _selectedDate = DateTime(now.year - 2);
  File image;
  UserModel _selectedTeacher;

  void setDelegate({
    @required SignupBlocDelegate delegate,
  }) {
    this._signupBlocDelegate = delegate;
  }

  @override
  Stream<SignupState> mapEventToState(SignupEvent event) async* {
    if (event is LoadPageEvent) {
      yield TeacherState();
    }

    if (event is ToggleProfileTypeEvent) {
      _signupBlocDelegate.clearForm();

      _profile_type = event.profileType;

      switch (_profile_type) {
        case PROFILE_TYPE.TEACHER:
          yield TeacherState();
          break;
        case PROFILE_TYPE.PARENT:
          yield ParentState(
            selectedDate: _selectedDate,
            image: image,
          );
          break;
        case PROFILE_TYPE.SUPER_ADMIN:
          yield SuperAdminState();
      }
    }

    if (event is SelectDateEvent) {
      this._selectedDate = event.selectedDate;
    }

    if (event is SelectTeacherEvent) {
      this._selectedTeacher = event.selectedTeacher;
    }

    if (event is TeacherSignupEvent) {
      UserModel newTeacher;

      final String email = event.email;
      final String password = event.password;
      final String firstName = event.firstName;
      final String lastName = event.lastName;
      final String school = event.school;

      try {
        yield SigningIn();

        AuthResult authResult =
            await locator<AuthService>().createUserWithEmailAndPassword(
          email: email,
          password: password,
        );

        final FirebaseUser firebaseUser = authResult.user;

        newTeacher = UserModel(
          imgUrl: DUMMY_PROFILE_PHOTO_URL,
          email: email,
          fcmToken: null,
          created: DateTime.now(),
          uid: firebaseUser.uid,
          firstName: firstName,
          lastName: lastName,
          profileType: PROFILE_TYPE.TEACHER.name,
          school: school,
          teacherID: null,
          dob: _selectedDate,
        );

        await locator<UserService>().createUser(user: newTeacher);

        _signupBlocDelegate.navigateHome();
      } catch (error) {
        _signupBlocDelegate.showMessage(message: error.toString());

        yield TeacherState();
      }
    }

    if (event is ParentSignupEvent) {
      UserModel newParent;

      final String email = event.email;
      final String password = event.password;
      final String firstName = event.firstName;
      final String lastName = event.lastName;
      final String firstParentFirstName = event.firstParentFirstName;
      final String firstParentLastName = event.firstParentLastName;
      final String secondParentFirstName = event.secondParentFirstName;
      final String secondParentLastName = event.secondParentLastName;

      try {
        yield SigningIn();

        AuthResult authResult =
            await locator<AuthService>().createUserWithEmailAndPassword(
          email: email,
          password: password,
        );

        final String firebaseUserUID = authResult.user.uid;

        final String imgUrl = await locator<StorageService>().uploadImage(
            file: image, path: 'Images/Users/$firebaseUserUID/Profile');

        newParent = UserModel(
          imgUrl: imgUrl,
          email: email,
          fcmToken: null,
          created: DateTime.now(),
          uid: firebaseUserUID,
          firstName: firstName,
          lastName: lastName,
          profileType: PROFILE_TYPE.PARENT.name,
          school: null,
          teacherID: '${IDK_TEACHER_MODEL.uid}',
          dob: _selectedDate,
        );

        await locator<UserService>().createUser(user: newParent);
        locator<UserService>().createParentInfo(
          uid: newParent.uid,
          firstParentFirstName: firstParentFirstName,
          firstParentLastName: firstParentLastName,
          secondParentFirstName: secondParentFirstName,
          secondParentLastName: secondParentLastName,
        );

        _signupBlocDelegate.navigateHome();
      } catch (error) {
        _signupBlocDelegate.showMessage(message: error.toString());
        yield ParentState(
          selectedDate: _selectedDate,
          image: image,
        );
      }
    }

    if (event is SuperAdminSignupEvent) {
      UserModel newSuperAdmin;

      final String email = event.email;
      final String password = event.password;
      final String firstName = event.firstName;
      final String lastName = event.lastName;

      try {
        yield SigningIn();

        AuthResult authResult =
            await locator<AuthService>().createUserWithEmailAndPassword(
          email: email,
          password: password,
        );

        final String firebaseUserUID = authResult.user.uid;

        newSuperAdmin = UserModel(
          imgUrl: DUMMY_PROFILE_PHOTO_URL,
          email: email,
          fcmToken: null,
          created: DateTime.now(),
          uid: firebaseUserUID,
          firstName: firstName,
          lastName: lastName,
          profileType: PROFILE_TYPE.SUPER_ADMIN.name,
          school: null,
          teacherID: null,
          dob: _selectedDate,
        );

        await locator<UserService>().createUser(user: newSuperAdmin);

        _signupBlocDelegate.navigateHome();
      } catch (error) {
        _signupBlocDelegate.showMessage(message: error.toString());
        yield SuperAdminState();
      }
    }

    if (event is UploadPictureEvent) {
      image = event.image;

      yield ParentState(
        selectedDate: _selectedDate,
        image: image,
      );
    }
  }
}
