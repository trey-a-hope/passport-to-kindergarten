import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:p/extensions/HexColorExtension.dart';
import 'package:p/widgets/FullWidthButtonWidget.dart';
import '../../constants.dart';
import 'Bloc.dart';
import 'package:p/blocs/signup/Bloc.dart' as SIGNUP_BP;
import 'package:p/blocs/login/Bloc.dart' as LOGIN_BP;
import 'Bloc.dart';

class HomePage extends StatefulWidget {
  @override
  State createState() => HomePageState();
}

class HomePageState extends State<HomePage> implements HomeDelegate {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  HomeBloc _homeBloc;

  @override
  void initState() {
    _homeBloc = BlocProvider.of<HomeBloc>(context);
    _homeBloc.setDelegate(delegate: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;

    return BlocBuilder<HomeBloc, HomeState>(
      builder: (BuildContext context, HomeState state) {
        if (state is DefaultState) {
          return Scaffold(
            key: _scaffoldKey,
            body: AnnotatedRegion<SystemUiOverlayStyle>(
              value: SystemUiOverlayStyle.light,
              child: Center(
                child: Text('Home Page'),
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
