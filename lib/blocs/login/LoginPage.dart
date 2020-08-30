
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:p/extensions/HexColorExtension.dart';
import 'package:p/services/ModalService.dart';
import 'package:p/services/ValidatorService.dart';
import 'package:p/widgets/FullWidthButtonWidget.dart';
import 'package:p/widgets/SpinnerWidget.dart';
import '../../ServiceLocator.dart';
import 'Bloc.dart';

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
  final Color _orangeColor = HexColorExtension('#E95316');
  final Color _graniteColor = HexColorExtension('#2E2E2E');

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

    return BlocBuilder<LoginBloc, LoginState>(
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
          final Container layerOne = Container(
            height: screenHeight,
            width: screenWidth,
            color: Colors.black,
          );

          final double secondLayerCardPadding = 45;

          final Container layerTwo = Container(
            height: screenHeight,
            width: screenWidth * 0.8,
            child: Column(
              children: [
                SizedBox(
                  height: secondLayerCardPadding,
                ),
                Container(
                  height: screenHeight - secondLayerCardPadding,
                  width: screenWidth,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.only(
                      topLeft: const Radius.circular(
                        CARD_BORDER_RADIUS,
                      ),
                      topRight: const Radius.circular(CARD_BORDER_RADIUS),
                    ),
                  ),
                ),
              ],
            ),
          );

          final double thirdLayerPadding = 60;

          final Container layerThree = Container(
            // height: screenHeight,
            // width: screenWidth * 0.9,
            child: Column(
              children: [
                SizedBox(
                  height: thirdLayerPadding,
                ),
                Container(
                  height: screenHeight - thirdLayerPadding,
                  width: screenWidth,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: const Radius.circular(
                        CARD_BORDER_RADIUS,
                      ),
                      topRight: const Radius.circular(CARD_BORDER_RADIUS),
                    ),
                  ),
                ),
              ],
            ),
          );

          final double forthLayerPadding =
              40; //Extra padding added from Safe Area.

          final Container layerFour = Container(
            height: screenHeight,
            width: screenWidth,
            child: SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: forthLayerPadding,
                  ),
                  Row(
                    children: [
                      Spacer(),
                      SizedBox(
                        height: 60.0,
                        width: 60.0,
                        child: IconButton(
                          icon: new Image.asset('assets/images/icon_close.png'),
                          // tooltip: 'Closes application',
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                      )
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                      left: 20,
                    ),
                    child: SizedBox(
                      height: 50.0,
                      width: 50.0,
                      child: IconButton(
                        icon: new Image.asset('assets/images/icon_lock.png'),
                        // tooltip: 'Closes application',
                        onPressed: () {},
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                      left: 20,
                      top: 30,
                    ),
                    child: Text(
                      'Welcome',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 32,
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                      left: 20,
                      top: 10,
                    ),
                    child: Text(
                      'Please login to your account.',
                      style: TextStyle(fontSize: 18, color: Colors.grey),
                    ),
                  ),
                  Form(
                    key: state.formKey,
                    autovalidate: state.autoValidate,
                    child: Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.fromLTRB(20, 30, 20, 0),
                          child: TextFormField(
                            cursorColor: _graniteColor,
                            validator: locator<ValidatorService>().email,
                            keyboardType: TextInputType.text,
                            textInputAction: TextInputAction.done,
                            controller: _emailController,
                            style: TextStyle(
                                color: Colors.black, fontFamily: 'SFUIDisplay'),
                            decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: 'Email Address',
                                prefixIcon: Icon(Icons.email),
                                labelStyle: TextStyle(fontSize: 15)),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
                          child: TextFormField(
                            cursorColor: _graniteColor,
                            validator: locator<ValidatorService>().password,
                            keyboardType: TextInputType.text,
                            textInputAction: TextInputAction.done,
                            controller: _passwordController,
                            obscureText: true,
                            style: TextStyle(
                                color: Colors.black, fontFamily: 'SFUIDisplay'),
                            decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: 'Password',
                                prefixIcon: Icon(Icons.lock_outline),
                                labelStyle: TextStyle(fontSize: 15)),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                      left: 20,
                      top: 30,
                    ),
                    child: InkWell(
                      onTap: () {
                        locator<ModalService>().showAlert(context: context, title: 'Forgot Password', message: 'Coming soon...');
                      },
                      child: Text(
                        'Forgot Password?',
                        style: TextStyle(
                          fontSize: 18,
                          color: _orangeColor,
                        ),
                      ),
                    ),
                  ),
                  Spacer(),
                  Center(
                    child: FullWidthButtonWidget(
                      text: 'Login',
                      textColor: Colors.white,
                      buttonColor: _graniteColor,
                      onPressed: () {
                        _loginBloc.add(
                          Login(
                              email: _emailController.text,
                              password: _passwordController.text,
                              formKey: state.formKey),
                        );
                      },
                    ),
                  )
                ],
              ),
            ),
          );

          return Scaffold(
            key: _scaffoldKey,
            body: AnnotatedRegion<SystemUiOverlayStyle>(
              value: SystemUiOverlayStyle.light,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  layerOne,
                  layerTwo,
                  layerThree,
                  layerFour,
                ],
              ),
            ),
          );
        }

        return null;
      },
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
