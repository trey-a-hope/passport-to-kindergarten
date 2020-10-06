import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:p/blocs/myPassport/MyPassportEvent.dart';
import 'package:p/blocs/myPassport/MyPassportState.dart';
import 'package:p/constants.dart';
import 'package:p/models/ParentsModel.dart';
import 'package:p/models/UserModel.dart';
import 'package:p/services/AuthService.dart';
import 'package:p/services/UserService.dart';
import 'dart:async';
import '../../ServiceLocator.dart';

abstract class MyPassportBlocDelegate {
  void showMessage({@required String message});
}

class MyPassportBloc extends Bloc<MyPassportEvent, MyPassportState> {
  MyPassportBloc() : super(null);
  MyPassportBlocDelegate _myPassportBlocDelegate;
  UserModel _child;
  UserModel _teacher;
  ParentsModel _parents;

  void setDelegate({
    @required MyPassportBlocDelegate delegate,
  }) {
    this._myPassportBlocDelegate = delegate;
  }

  @override
  Stream<MyPassportState> mapEventToState(MyPassportEvent event) async* {
    if (event is LoadPageEvent) {
      yield LoadingState();

      try {
        _child = await locator<AuthService>().getCurrentUser();

        _parents = await locator<UserService>().retrieveParentInfo(uid: _child.uid);

        if (_child.teacherID == '${IDK_TEACHER_MODEL.uid}') {
          _teacher = IDK_TEACHER_MODEL;
        } else {
          _teacher =
              await locator<UserService>().retrieveUser(uid: _child.teacherID);
        }

        yield LoadedState(childUser: _child, teacherUser: _teacher, parents: _parents);
      } catch (error) {
        yield ErrorState(error: error);
      }
    }
  }
}
