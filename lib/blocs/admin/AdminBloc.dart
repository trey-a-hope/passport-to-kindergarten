import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:p/ServiceLocator.dart';
import 'package:p/constants.dart';
import 'package:p/models/UserModel.dart';
import 'package:p/services/AuthService.dart';

import 'Bloc.dart';

abstract class AdminBlocDelegate {
  void showMessage({@required String message});
}

class AdminBloc extends Bloc<AdminEvent, AdminState> {
  AdminBloc() : super(null);

  AdminBlocDelegate _adminBlocDelegate;
  UserModel _currentUser;

  void setDelegate({@required AdminBlocDelegate delegate}) {
    this._adminBlocDelegate = delegate;
  }

  @override
  Stream<AdminState> mapEventToState(AdminEvent event) async* {
    if (event is LoadPageEvent) {
      yield LoadingState();

      try {
        _currentUser = await locator<AuthService>().getCurrentUser();

        if (_currentUser.profileType == PROFILE_TYPE.SUPER_ADMIN.name)
          yield SuperAdminLoadedState(user: _currentUser);

        if (_currentUser.profileType == PROFILE_TYPE.TEACHER.name)
          yield TeacherLoadedState(user: _currentUser);
      } catch (error) {
        yield ErrorState(error: error);
      }
    }
  }
}
