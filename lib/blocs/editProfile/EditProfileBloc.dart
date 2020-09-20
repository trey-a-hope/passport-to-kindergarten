import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:p/ServiceLocator.dart';
import 'package:p/blocs/editProfile/Bloc.dart';
import 'package:p/constants.dart';
import 'package:p/models/UserModel.dart';
import 'package:p/services/AuthService.dart';

abstract class EditProfileBlocDelegate {
  void showMessage({@required String message});
  void setTextFields({@required UserModel user});
}

class EditProfileBloc extends Bloc<EditProfileEvent, EditProfileState> {
  EditProfileBloc() : super(null);

  EditProfileBlocDelegate _editProfileBlocDelegate;
  UserModel _currentUser;

  void setDelegate({@required EditProfileBlocDelegate delegate}) {
    this._editProfileBlocDelegate = delegate;
  }

  @override
  Stream<EditProfileState> mapEventToState(EditProfileEvent event) async* {
    if (event is LoadPageEvent) {
      yield LoadingState();

      try {
        _currentUser = await locator<AuthService>().getCurrentUser();

        add(SetTextFieldsEvent(user: _currentUser));

        if (_currentUser.profileType == PROFILE_TYPE.ADMIN.name)
          yield SuperAdminLoadedState(user: _currentUser);

        if (_currentUser.profileType == PROFILE_TYPE.TEACHER.name)
          yield TeacherLoadedState(user: _currentUser);

        if (_currentUser.profileType == PROFILE_TYPE.PARENT.name)
          yield ParentLoadedState(
            user: _currentUser,
            autoValidate: false,
            formKey: GlobalKey<FormState>(),
          );
      } catch (error) {
        yield ErrorState(error: error);
      }
    }

    if (event is SetTextFieldsEvent) {
      _editProfileBlocDelegate.setTextFields(user: event.user);
    }

    if (event is SubmitEvent) {
      yield LoadingState();

      //todo: update profile.
    }
  }
}
