import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:p/models/UserModel.dart';
import 'package:p/services/UserService.dart';
import 'package:p/widgets/FullWidthButtonWidget.dart';
import 'package:package_info/package_info.dart';
import 'ServiceLocator.dart';
// import 'blocs/splash/Bloc.dart';
import 'blocs/login/Bloc.dart' as LOGIN_BP;
import 'constants.dart';
import 'services/AuthService.dart';

FirebaseAnalytics analytics;
PackageInfo packageInfo;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  setUpLocater();

  analytics = FirebaseAnalytics();
  packageInfo = await PackageInfo.fromPlatform();

  Crashlytics.instance.enableInDevMode = true;
  FlutterError.onError = Crashlytics.instance.recordFlutterError;

  version = packageInfo.version;
  buildNumber = packageInfo.buildNumber;

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp],
    );

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      navigatorObservers: [
        FirebaseAnalyticsObserver(analytics: analytics),
      ],
      home: StreamBuilder(
        stream: locator<AuthService>().onAuthStateChanged(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          final FirebaseUser firebaseUser = snapshot.data;

          return firebaseUser == null
              ? BlocProvider(
                  create: (BuildContext context) =>
                      LOGIN_BP.LoginBloc()..add(LOGIN_BP.LoadPageEvent()),
                  child: LOGIN_BP.LoginPage(),
                )
              : HomePage();
        },
      ),
    );
  }
}

HomePage() {
  return Container(
    color: Colors.orange,
    child: Center(
      child: FullWidthButtonWidget(
        buttonColor: Colors.white,
        text: 'Sign Out',
        textColor: Colors.orange,
        onPressed: () {
          locator<AuthService>().signOut();
        },
      ),
    ),
  );
}
