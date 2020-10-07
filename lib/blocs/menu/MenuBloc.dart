import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:p/ServiceLocator.dart';
import 'package:p/constants.dart';
import 'package:p/models/UserModel.dart';
import 'package:p/services/AuthService.dart';
import 'package:p/services/UserService.dart';
import 'MenuEvent.dart';
import 'MenuState.dart';

abstract class MenuBlocDelegate {
  void showMessage({@required String message});
}

class MenuBloc extends Bloc<MenuEvent, MenuState> {
  MenuBloc() : super(null);

  final FirebaseMessaging _fcm = FirebaseMessaging();
  MenuBlocDelegate _menuBlocDelegate;
  UserModel _currentUser;

  void setDelegate({@required MenuBlocDelegate delegate}) {
    this._menuBlocDelegate = delegate;
  }

  static Future<dynamic> myBackgroundMessageHandler(
      Map<String, dynamic> message) async {
    if (message.containsKey('data')) {
      // Handle data message
      final dynamic data = message['data'];
    }

    if (message.containsKey('notification')) {
      // Handle notification message
      final dynamic notification = message['notification'];
    }

    // Or do other work.
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
      onBackgroundMessage: Platform.isIOS ? null : myBackgroundMessageHandler,
    );
  }

  @override
  Stream<MenuState> mapEventToState(MenuEvent event) async* {
    if (event is LoadPageEvent) {
      yield LoadingState();

      try {

        _currentUser = await locator<AuthService>().getCurrentUser();

        _setUpFirebaseMessaging();

        final DateTime now = DateTime.now();

        String greetingMessage;
        if (now.hour < 12) {
          greetingMessage = 'Morning';
        } else if (now.hour < 17) {
          greetingMessage = 'Afternoon';
        } else {
          greetingMessage = 'Evening';
        }

        if (_currentUser.profileType == PROFILE_TYPE.PARENT.name)
          yield ParentState(
              user: _currentUser, greetingMessage: greetingMessage);
        else if (_currentUser.profileType == PROFILE_TYPE.TEACHER.name)
          yield TeacherState(
              user: _currentUser, greetingMessage: greetingMessage);
        else if (_currentUser.profileType == PROFILE_TYPE.SUPER_ADMIN.name)
          yield SuperAdminState(
              user: _currentUser, greetingMessage: greetingMessage);
        else
          yield ErrorState(error: 'Should not see this...');
      } catch (error) {
        yield ErrorState(error: error);
      }
    }
  }
}