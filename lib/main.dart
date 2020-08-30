import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:package_info/package_info.dart';
import 'ServiceLocator.dart';
import 'blocs/splash/Bloc.dart';
import 'constants.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  setUpLocater();

  PackageInfo packageInfo = await PackageInfo.fromPlatform();
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
          primarySwatch: Colors.orange,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: Container(
          child: Center(
            child: Text('Welcome To P2K'),
          ),
        )

        // BlocProvider(
        //   create: (BuildContext context) => SplashBloc()..add(LoadPageEvent()),
        //   child: SplashPage(),
        // )

        // StreamBuilder(
        //   stream: locator<AuthService>().onAuthStateChanged(),
        //   builder: (BuildContext context, AsyncSnapshot snapshot) {
        //     final FirebaseUser firebaseUser = snapshot.data;
        //     return firebaseUser == null
        //         ? BlocProvider(
        //             create: (BuildContext context) =>
        //                 SplashBloc()..add(LoadPageEvent()),
        //             child: SplashPage(),
        //           )
        //         : Container(
        //             color: Colors.orange,
        //             child: Center(
        //               child: FullWidthButtonWidget(
        //                 buttonColor: Colors.white,
        //                 text: 'Sign Out',
        //                 textColor: Colors.orange,
        //                 onPressed: () {
        //                   locator<AuthService>().signOut();
        //                 },
        //               ),
        //             ),
        //           );
        //   },
        // ),
        );
  }
}
