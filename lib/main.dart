import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:firebase_auth/firebase_auth.dart';
// import 'package:crashlytics/crashlytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:package_info/package_info.dart';
import 'ServiceLocator.dart';
import 'blocs/login/Bloc.dart' as LOGIN_BP;
import 'blocs/menu/Bloc.dart' as MENU_BP;
import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:page_transition/page_transition.dart';

import 'constants.dart';
import 'services/AuthService.dart';

FirebaseAnalytics analytics;
PackageInfo packageInfo;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  setUpLocater();

  analytics = FirebaseAnalytics();
  packageInfo = await PackageInfo.fromPlatform();

  // Crashlytics.setup();

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
    SystemChrome.setEnabledSystemUIOverlays([]);

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
      home: AnimatedSplashScreen(
        splash: 'assets/images/app_icon.png',
        splashIconSize: 200,
        splashTransition: SplashTransition.fadeTransition,
        pageTransitionType: PageTransitionType.fade,
        nextScreen: StreamBuilder(
          stream: locator<AuthService>().onAuthStateChanged(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            final User user = snapshot.data;

            screenWidth = MediaQuery.of(context).size.width;
            screenHeight = MediaQuery.of(context).size.height;

            return user == null
                ? BlocProvider(
                    create: (BuildContext context) =>
                        LOGIN_BP.LoginBloc()..add(LOGIN_BP.LoadPageEvent()),
                    child: LOGIN_BP.LoginPage(),
                  )
                : BlocProvider(
                    create: (BuildContext context) => MENU_BP.MenuBloc()
                      ..add(
                        MENU_BP.LoadPageEvent(),
                      ),
                    child: MENU_BP.MenuPage(),
                  );
          },
        ),
      ),
    );
  }
}
