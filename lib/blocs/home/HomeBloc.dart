import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:p/ServiceLocator.dart';
import 'package:p/models/UserModel.dart';
import 'package:p/services/AuthService.dart';
import 'package:p/services/DummyService.dart';
import 'package:p/services/UserService.dart';

import 'HomeEvent.dart';
import 'HomeState.dart';

abstract class HomeDelegate {
  void showMessage({@required String message});
}

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc() : super(null);

  final FirebaseMessaging _fcm = FirebaseMessaging();
  HomeDelegate _homeDelegate;
  UserModel _currentUser;

  void setDelegate({@required HomeDelegate delegate}) {
    this._homeDelegate = delegate;
  }

  //Request notification permissions and register call backs for receiving push notifications.
  void _setUpFirebaseMessaging() async {
    if (Platform.isIOS) {
      _fcm.requestNotificationPermissions(
        IosNotificationSettings(),
      );
    }

    final String fcmToken = await _fcm.getToken();
    if (fcmToken != null) {
      locator<UserService>()
          .updateUser(uid: _currentUser.uid, data: {'fcmToken': fcmToken});
    }

    _fcm.configure(
      onMessage: (Map<String, dynamic> message) async {
        print("onMessage: $message");
      },
      onLaunch: (Map<String, dynamic> message) async {
        print("onLaunch: $message");
      },
      onResume: (Map<String, dynamic> message) async {
        print("onResume: $message");
      },
    );
  }

  @override
  Stream<HomeState> mapEventToState(HomeEvent event) async* {
    if (event is LoadPageEvent) {
      yield LoadingState();

      try {
        locator<DummyService>().addIDKTeacherToUsers();

        _currentUser = await locator<AuthService>().getCurrentUser();

        _setUpFirebaseMessaging();

        yield LoadedState(user: _currentUser);
      } catch (error) {
        yield ErrorState(error: error);
      }
    }
  }
}
