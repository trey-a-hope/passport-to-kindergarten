import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:p/ServiceLocator.dart';
import 'package:p/constants.dart';
import 'package:p/services/ModalService.dart';
import 'package:p/widgets/DrawerWidget.dart';
import 'package:p/widgets/SpinnerWidget.dart';
import 'Bloc.dart';

class AwesomeReadingTipsPage extends StatefulWidget {
  @override
  State createState() => AwesomeReadingTipsPageState();
}

class AwesomeReadingTipsPageState extends State<AwesomeReadingTipsPage>
    implements AwesomeReadingTipsBlocDelegate {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  AwesomeReadingTipsBloc _awesomeReadingTipsBloc;

  @override
  void initState() {
    _awesomeReadingTipsBloc = BlocProvider.of<AwesomeReadingTipsBloc>(context);
    _awesomeReadingTipsBloc.setDelegate(delegate: this);

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AwesomeReadingTipsBloc, AwesomeReadingTipsState>(
      builder: (BuildContext context, AwesomeReadingTipsState state) {
        if (state is LoadingState) {
          return Container(
            color: Colors.white,
            child: SpinnerWidget(),
          );
        }

        if (state is LoadedState) {
          return Scaffold(
            key: _scaffoldKey,
            appBar: AppBar(
              title: Text('Awesome Reading Tips'),
            ),
            drawer: DrawerWidget(
              currentUser: state.user,
              page: APP_PAGES.AWESOME_READING_TIPS,
            ),
            body: AnnotatedRegion<SystemUiOverlayStyle>(
              value: SystemUiOverlayStyle.light,
              child: Center(
                child: Text('Awesome Reading Tips'),
              ),
            ),
          );
        }

        if (state is ErrorState) {
          return Container(
            child: Center(
              child: Text(
                state.error.toString(),
              ),
            ),
          );
        }

        return Container();
      },
    );
  }

  @override
  void showMessage({String message}) {
    locator<ModalService>()
        .showInSnackBar(scaffoldKey: _scaffoldKey, message: message);
  }
}