import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:p/blocs/splash/SplashState.dart';
import 'package:p/constants.dart';
import 'package:p/extensions/HexColorExtension.dart';
import 'package:p/services/ModalService.dart';
import 'package:p/widgets/FullWidthButtonWidget.dart';
import 'package:p/widgets/SpinnerWidget.dart';
import '../../ServiceLocator.dart';
import 'Bloc.dart';
import 'package:p/blocs/login/Bloc.dart' as LOGIN_BP;
import 'package:p/blocs/signup/Bloc.dart' as SIGNUP_BP;

class LoginPage extends StatefulWidget {
  @override
  State createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage>
    with SingleTickerProviderStateMixin
    implements LoginBlocDelegate {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  LoginBloc _loginBloc;

  @override
  void initState() {
    _loginBloc = BlocProvider.of<LoginBloc>(context);
    _loginBloc.setDelegate(delegate: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;
    const double CARD_BORDER_RADIUS = 30;

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
            child: BlocBuilder<LoginBloc, LoginState>(
              builder: (BuildContext context, LoginState state) {
                if (state is LoggingIn) {
                  return Container(
                    height: screenHeight,
                    width: screenWidth,
                    color: Colors.white,
                    child: SpinnerWidget(),
                  );
                }

                if (state is LoginNotStarted) {
                  return Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.fromLTRB(20, 10, 20, 0),
                        child: Row(
                          children: [
                            IconButton(
                              icon: Icon(Icons.arrow_back),
                              color: Colors.white,
                              onPressed: () {
                                Navigator.pop(context);
                              },
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      Image.asset(ASSET_IMAGE_P2K_LOGO),
                      SizedBox(
                        height: 50,
                      ),
                      Image.asset(ASSET_IMAGE_P2K_TEXT),
                      SizedBox(
                        height: 20,
                      ),
                      Padding(
                        padding: EdgeInsets.all(20),
                        child: TextFormField(
                          controller: _emailController,
                          style: TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                              prefixIcon: Icon(
                                Icons.alternate_email,
                                color: Colors.white,
                              ),
                              border: OutlineInputBorder(
                                // width: 0.0 produces a thin "hairline" border
                                borderRadius: BorderRadius.all(
                                  Radius.circular(90.0),
                                ),
                                borderSide: BorderSide.none,

                                //borderSide: const BorderSide(),
                              ),
                              hintStyle: TextStyle(
                                  color: Colors.white,
                                  fontFamily: "WorkSansLight"),
                              filled: true,
                              fillColor: Colors.white24,
                              hintText: 'Email'),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                        child: TextFormField(
                          controller: _passwordController,
                          style: TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                              prefixIcon: Icon(
                                Icons.lock,
                                color: Colors.white,
                              ),
                              border: OutlineInputBorder(
                                // width: 0.0 produces a thin "hairline" border
                                borderRadius: BorderRadius.all(
                                  Radius.circular(90.0),
                                ),
                                borderSide: BorderSide.none,

                                //borderSide: const BorderSide(),
                              ),
                              hintStyle: TextStyle(
                                  color: Colors.white,
                                  fontFamily: "WorkSansLight"),
                              filled: true,
                              fillColor: Colors.white24,
                              hintText: 'Password'),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(27),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            InkWell(
                              child: Text(
                                'Forget Password?',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              onTap: () {
                                locator<ModalService>().showAlert(
                                    context: context,
                                    title: 'To Do',
                                    message: 'Open Forgot Password Page.');
                              },
                            ),
                          ],
                        ),
                      ),
                      Spacer(),
                      FullWidthButtonWidget(
                        buttonColor: HexColorExtension('ff4880'),
                        text: 'Login Up',
                        textColor: Colors.white,
                        onPressed: () {},
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 20),
                        child: Image.asset(ASSET_IMAGE_OR),
                      ),
                      FullWidthButtonWidget(
                        buttonColor: Colors.grey.shade900,
                        text: 'Login Up With Google',
                        textColor: Colors.white,
                        onPressed: () {},
                      ),
                      Padding(
                        padding: EdgeInsets.all(20),
                        child: InkWell(
                          onTap: () {
                            Route route = MaterialPageRoute(
                              builder: (BuildContext context) => BlocProvider(
                                create: (BuildContext context) =>
                                    SIGNUP_BP.SignupBloc()
                                      ..add(
                                        SIGNUP_BP.LoadPageEvent(),
                                      ),
                                child: SIGNUP_BP.SignupPage(),
                              ),
                            );
                            Navigator.push(context, route);
                          },
                          child: RichText(
                            text: TextSpan(
                              style: TextStyle(fontWeight: FontWeight.bold),
                              children: [
                                TextSpan(
                                    text: 'New User?',
                                    style: TextStyle(color: Colors.grey)),
                                TextSpan(text: ' Create an Account')
                              ],
                            ),
                          ),
                        ),
                      )
                    ],
                  );
                }

                return Container();
              },
            ),
          ),
        ),
      ),
    );
  }

  @override
  void navigateHome() {
    Navigator.of(context).pop();
  }

  @override
  void showMessage({String message}) {
    locator<ModalService>()
        .showAlert(context: context, title: 'Error', message: message);
  }
}
