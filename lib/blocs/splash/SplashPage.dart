import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:p/extensions/HexColorExtension.dart';
import 'package:p/widgets/FullWidthButtonWidget.dart';
import '../../constants.dart';
import 'Bloc.dart';

class SplashPage extends StatefulWidget {
  @override
  State createState() => SplashPageState();
}

class SplashPageState extends State<SplashPage> implements SplashDelegate {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  SplashBloc _splashBloc;

  @override
  void initState() {
    _splashBloc = BlocProvider.of<SplashBloc>(context);
    _splashBloc.setDelegate(delegate: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;
    return BlocBuilder<SplashBloc, SplashState>(
      builder: (BuildContext context, SplashState state) {
        if (state is DefaultState) {
          return Scaffold(
            key: _scaffoldKey,
            body: AnnotatedRegion<SystemUiOverlayStyle>(
              value: SystemUiOverlayStyle.light,
              child: Container(
                width: screenWidth,
                height: screenHeight,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(ASSET_IMAGE_SPLASH_BACKGROUND),
                    fit: BoxFit.cover,
                  ),
                ),
                child: SafeArea(
                  child: Stack(
                    children: [
                      Column(
                        children: [
                          Expanded(
                            flex: 1,
                            child: Container(),
                          ),
                          Expanded(flex: 1, child: Container()),
                          Expanded(
                            flex: 1,
                            child: Column(
                              children: [
                                Spacer(),
                                FullWidthButtonWidget(
                                  buttonColor: Colors.white,
                                  text: 'Login',
                                  textColor: Colors.black,
                                  onPressed: () {
                                    // Route route = MaterialPageRoute(
                                    //   builder: (BuildContext context) =>
                                    //       BlocProvider(
                                    //     create: (BuildContext context) =>
                                    //         LOGIN_BP.LoginBloc()
                                    //           ..add(
                                    //             LOGIN_BP.LoadPageEvent(),
                                    //           ),
                                    //     child: LOGIN_BP.LoginPage(),
                                    //   ),
                                    // );
                                    // Navigator.push(context, route);
                                  },
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                FullWidthButtonWidget(
                                  buttonColor: HexColorExtension('e95316'),
                                  text: 'Sign Up',
                                  textColor: Colors.white,
                                  onPressed: () {
                                    // Route route = MaterialPageRoute(
                                    //   builder: (BuildContext context) =>
                                    //       BlocProvider(
                                    //     create: (BuildContext context) =>
                                    //         SIGNUP_BP.SignupBloc()
                                    //           ..add(
                                    //             SIGNUP_BP.LoadPageEvent(),
                                    //           ),
                                    //     child: SIGNUP_BP.SignupPage(),
                                    //   ),
                                    // );
                                    // Navigator.push(context, route);
                                  },
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        }

        if (state is ErrorState) {
          return Container();
        }

        return Container();
      },
    );
  }

  @override
  void showMessage({String message}) {
    // locator<ModalService>()
    //     .showInSnackBar(scaffoldKey: _scaffoldKey, message: message);
  }
}
