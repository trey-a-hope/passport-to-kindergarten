import 'package:flutter/material.dart';
import 'package:p/main.dart';

enum AnalyticsEventType {
  LOGIN,
  SIGNUP,
}
//https://support.google.com/firebase/answer/6317498?authuser=1
abstract class IAnalyticsService {
  void logEvent({
    @required AnalyticsEventType eventType,
  });
}

class AnalyticsService extends IAnalyticsService {
  @override
  void logEvent({
    @required AnalyticsEventType eventType,
  }) {
    switch (AnalyticsEventType.LOGIN) {
      case AnalyticsEventType.LOGIN:
        analytics.logEvent(name: 'LOGIN: ' + 'SUFA030CA0');
        break;

      case AnalyticsEventType.SIGNUP:
        analytics.logEvent(name: 'SIGNUP: ' + 'SUFA030CA0');
        break;
    }
  }
}
