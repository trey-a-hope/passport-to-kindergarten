import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:p/ServiceLocator.dart';
import 'package:p/blocs/editProfile/Bloc.dart';
import 'package:p/constants.dart';
import 'package:p/models/UserModel.dart';
import 'package:p/services/AuthService.dart';
import 'package:p/services/UserService.dart';

abstract class EditProfileBlocDelegate {
  void showMessage({@required String message});
  void teacherSetTextFields({@required UserModel user});
  void parentSetTextFields({@required UserModel user});
  void superAdminSetTextFields({@required UserModel user});
}

class EditProfileBloc extends Bloc<EditProfileEvent, EditProfileState> {
  EditProfileBloc() : super(null);

  EditProfileBlocDelegate _editProfileBlocDelegate;
  UserModel _currentUser;
  DateTime _childDOB;

  void setDelegate({@required EditProfileBlocDelegate delegate}) {
    this._editProfileBlocDelegate = delegate;
  }

  @override
  Stream<EditProfileState> mapEventToState(EditProfileEvent event) async* {
    if (event is LoadPageEvent) {
      yield LoadingState();

      try {
        _currentUser = await locator<AuthService>().getCurrentUser();

        _childDOB = _currentUser.dob;

        if (_currentUser.profileType == PROFILE_TYPE.ADMIN.name) {
          add(SuperAdminSetTextFieldsEvent(user: _currentUser));
          yield SuperAdminLoadedState(
            user: _currentUser,
            autoValidate: false,
            formKey: GlobalKey<FormState>(),
          );
        }

        if (_currentUser.profileType == PROFILE_TYPE.TEACHER.name) {
          add(TeacherSetTextFieldsEvent(user: _currentUser));
          yield TeacherLoadedState(
            user: _currentUser,
            autoValidate: false,
            formKey: GlobalKey<FormState>(),
          );
        }

        if (_currentUser.profileType == PROFILE_TYPE.PARENT.name) {
          add(ParentSetTextFieldsEvent(user: _currentUser));
          yield ParentLoadedState(
            user: _currentUser,
            autoValidate: false,
            formKey: GlobalKey<FormState>(),
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
      _editProfileBlocDelegate.parentSetTextFields(user: event.user);
    }

    if (event is ParentSubmitEvent) {
      yield LoadingState();

      try {
        final String firstName = event.firstName;
        final String lastName = event.lastName;

        await locator<UserService>().updateUser(uid: _currentUser.uid, data: {
          'firstName': firstName,
          'lastName': lastName,
          'dob': _childDOB
        });

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
  }
}
