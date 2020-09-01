import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:getwidget/getwidget.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:p/constants.dart';
import 'package:p/extensions/HexColorExtension.dart';
import 'package:p/services/ModalService.dart';
import 'package:p/services/ValidatorService.dart';
import 'package:p/widgets/FullWidthButtonWidget.dart';
import 'package:p/widgets/SpinnerWidget.dart';
import '../../ServiceLocator.dart';
import 'Bloc.dart';
import 'package:p/blocs/login/Bloc.dart' as LOGIN_BP;

class SignupPage extends StatefulWidget {
  @override
  State createState() => SignupPageState();
}

class SignupPageState extends State<SignupPage>
    with SingleTickerProviderStateMixin
    implements SignupBlocDelegate {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  SignupBloc _signupBloc;

  @override
  void initState() {
    _signupBloc = BlocProvider.of<SignupBloc>(context);
    _signupBloc.setDelegate(delegate: this);
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
            child: BlocBuilder<SignupBloc, SignupState>(
              builder: (BuildContext context, SignupState state) {
                if (state is SigningIn) {
                  return SpinnerWidget();
                }

                if (state is SignupNotStarted) {
                  return Form(
                    autovalidate: state.autoValidate,
                    key: state.formKey,
                    child: Column(
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
                        Spacer(),
                        FullWidthButtonWidget(
                          buttonColor: HexColorExtension('ff4880'),
                          text: 'Sign Up',
                          textColor: Colors.white,
                          onPressed: () {
                            final String email = _emailController.text;
                            final String password = _passwordController.text;

                            _signupBloc.add(
                              Signup(
                                email: email,
                                password: password,
                                formKey: state.formKey,
                              ),
                            );
                          },
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 20),
                          child: Image.asset(ASSET_IMAGE_OR),
                        ),
                        FullWidthButtonWidget(
                          buttonColor: Colors.grey.shade900,
                          text: 'Sign Up With Google',
                          textColor: Colors.white,
                          onPressed: () {
                            locator<ModalService>().showAlert(
                                context: context,
                                title: 'To Do',
                                message: 'Sign Up With Google');
                          },
                        ),
                        Padding(
                          padding: EdgeInsets.all(20),
                          child: InkWell(
                            onTap: () {
                              Route route = MaterialPageRoute(
                                builder: (BuildContext context) => BlocProvider(
                                  create: (BuildContext context) =>
                                      LOGIN_BP.LoginBloc()
                                        ..add(
                                          LOGIN_BP.LoadPageEvent(),
                                        ),
                                  child: LOGIN_BP.LoginPage(),
                                ),
                              );
                              Navigator.pushReplacement(context, route);
                            },
                            child: RichText(
                              text: TextSpan(
                                style: TextStyle(fontWeight: FontWeight.bold),
                                children: [
                                  TextSpan(
                                      text: 'Already have an account?',
                                      style: TextStyle(color: Colors.grey)),
                                  TextSpan(text: ' Log in')
                                ],
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
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
