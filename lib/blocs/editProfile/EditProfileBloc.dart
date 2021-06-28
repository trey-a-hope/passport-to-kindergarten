import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:p/ServiceLocator.dart';
import 'package:p/blocs/editProfile/Bloc.dart';
import 'package:p/constants.dart';
import 'package:p/models/UserModel.dart';
import 'package:p/services/AuthService.dart';
import 'package:p/services/StorageService.dart';
import 'package:p/services/UserService.dart';

abstract class EditProfileBlocDelegate {
  void showMessage({@required String message});
  void teacherSetTextFields({@required UserModel user});
  void parentSetTextFields(
      {@required UserModel student, @required UserModel teacher});
  void superAdminSetTextFields({@required UserModel user});
}

class EditProfileBloc extends Bloc<EditProfileEvent, EditProfileState> {
  EditProfileBloc() : super(null);

  EditProfileBlocDelegate _editProfileBlocDelegate;
  UserModel _currentUser;
  DateTime _childDOB;
  UserModel _teacher;

  void setDelegate({@required EditProfileBlocDelegate delegate}) {
    this._editProfileBlocDelegate = delegate;
  }

  @override
  Stream<EditProfileState> mapEventToState(EditProfileEvent event) async* {
    if (event is LoadPageEvent) {
      yield LoadingState();

      try {
        _currentUser = await locator<AuthService>().getCurrentUser();

        if (_currentUser.profileType == PROFILE_TYPE.SUPER_ADMIN.name) {
          add(SuperAdminSetTextFieldsEvent(user: _currentUser));
          yield SuperAdminLoadedState(
            user: _currentUser,
          );
        }

        if (_currentUser.profileType == PROFILE_TYPE.TEACHER.name) {
          add(TeacherSetTextFieldsEvent(user: _currentUser));
          yield TeacherLoadedState(
            user: _currentUser,
          );
        }

        if (_currentUser.profileType == PROFILE_TYPE.PARENT.name) {
          _childDOB = _currentUser.dob;
          _teacher = _currentUser.teacherID == idkTeacherModel.uid
              ? idkTeacherModel
              : await locator<UserService>()
                  .retrieveUser(uid: _currentUser.teacherID);

          add(
            ParentSetTextFieldsEvent(user: _currentUser, teacher: _teacher),
          );

          yield ParentLoadedState(
            user: _currentUser,
          );
        }
      } catch (error) {
        yield ErrorState(error: error);
      }
    }

    if (event is SuperAdminSetTextFieldsEvent) {
      _editProfileBlocDelegate.superAdminSetTextFields(user: event.user);
    }

    if (event is SuperAdminSubmitEvent) {
      yield LoadingState();

      try {
        final String firstName = event.firstName;
        final String lastName = event.lastName;

        await locator<UserService>().updateUser(uid: _currentUser.uid, data: {
          'firstName': firstName,
          'lastName': lastName,
        });

        add(
          LoadPageEvent(),
        );
      } catch (error) {
        yield ErrorState(error: error);
      }
    }

    if (event is ParentSetTextFieldsEvent) {
      _editProfileBlocDelegate.parentSetTextFields(
          student: event.user, teacher: event.teacher);
    }

    if (event is ParentSubmitEvent) {
      yield LoadingState();

      try {
        final String firstName = event.firstName;
        final String lastName = event.lastName;
        final String primaryParentFirstName = event.primaryParentFirstName;
        final String primaryParentLastName = event.primaryParentLastName;
        final String secondaryParentFirstName = event.secondaryParentFirstName;
        final String secondaryParentLastName = event.secondaryParentLastName;

        await locator<UserService>().updateUser(
          uid: _currentUser.uid,
          data: {
            'firstName': firstName,
            'lastName': lastName,
            'dob': _childDOB,
            'primaryParentFirstName': primaryParentFirstName,
            'primaryParentLastName': primaryParentLastName,
            'secondaryParentFirstName': secondaryParentFirstName,
            'secondaryParentLastName': secondaryParentLastName,
            'teacherID': _teacher.uid,
          },
        );

        add(
          LoadPageEvent(),
        );
      } catch (error) {
        yield ErrorState(error: error);
      }
    }

    if (event is TeacherSetTextFieldsEvent) {
      _editProfileBlocDelegate.teacherSetTextFields(user: event.user);
    }

    if (event is TeacherSubmitEvent) {
      yield LoadingState();

      try {
        final String firstName = event.firstName;
        final String lastName = event.lastName;
        final String school = event.school;

        await locator<UserService>().updateUser(uid: _currentUser.uid, data: {
          'firstName': firstName,
          'lastName': lastName,
          'school': school,
        });

        add(
          LoadPageEvent(),
        );
      } catch (error) {
        yield ErrorState(error: error);
      }
    }

    if (event is UpdateChildDOBEvent) {
      final DateTime dob = event.childDOB;
      _childDOB = dob;
    }

    if (event is UploadPictureEvent) {
      final File image = event.image;

      try {
        final String imgUrl = await locator<StorageService>().uploadImage(
            file: image, imgPath: 'Images/Users/${_currentUser.uid}/Profile');

        await locator<UserService>().updateUser(
          uid: _currentUser.uid,
          data: {
            'imgUrl': imgUrl,
          },
        );

        add(LoadPageEvent());
      } catch (error) {
        _editProfileBlocDelegate.showMessage(
          message: error.toString(),
        );
      }
    }

    if (event is SelectTeacherEvent) {
      this._teacher = event.selectedTeacher;
    }
  }
}
