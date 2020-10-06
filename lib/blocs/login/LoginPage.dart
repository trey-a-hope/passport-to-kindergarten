import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:p/constants.dart';
import 'package:p/extensions/HexColorExtension.dart';
import 'package:p/services/ModalService.dart';
import 'package:p/widgets/FullWidthButtonWidget.dart';
import 'package:p/widgets/SpinnerWidget.dart';
import '../../ServiceLocator.dart';
import 'Bloc.dart';
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
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  LoginBloc _loginBloc;

  void fillFormsWithDummyData() {
    this._emailController.text = 'trey.a.hope@gmail.com';
    this._passwordController.text = 'Peachy33';
  }

  @override
  void initState() {
    _loginBloc = BlocProvider.of<LoginBloc>(context);
    _loginBloc.setDelegate(delegate: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

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
                  return SpinnerWidget();
                }

                if (state is LoginNotStarted) {
                  return Column(
                    children: [
                      Expanded(
                        flex: 2,
                        child: InkWell(
                          child: Image.asset(ASSET_IMAGE_P2K_LOGO),
                          onTap: () {
                            fillFormsWithDummyData();
                          },
                        ),
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
                          obscureText: true,
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
                      Spacer(),
                      FullWidthButtonWidget(
                        buttonColor: HexColorExtension('ff4880'),
                        text: 'Login',
                        textColor: Colors.white,
                        onPressed: () {
                          final String email = _emailController.text;
                          final String password = _passwordController.text;

                          _loginBloc.add(
                            Login(
                              email: email,
                              password: password,
                              formKey: state.formKey,
                            ),
                          );
                        },
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
                                    text: 'New Teacher or Parent?',
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
  void showMessage({String message}) {
    locator<ModalService>()
        .showAlert(context: context, title: 'Error', message: message);
  }

  @override
  void navigateHome() {
    Navigator.of(context).popUntil((route) => route.isFirst);
  }
}
