import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:p/constants.dart';
import 'package:p/services/ModalService.dart';
import 'package:p/widgets/DrawerWidget.dart';
import 'package:p/widgets/SpinnerWidget.dart';
import '../../ServiceLocator.dart';
import 'Bloc.dart';

class MyPassportPage extends StatefulWidget {
  @override
  State createState() => MyPassportPageState();
}

class MyPassportPageState extends State<MyPassportPage>
    with SingleTickerProviderStateMixin
    implements MyPassportBlocDelegate {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  MyPassportBloc _myPassportBloc;

  @override
  void initState() {
    _myPassportBloc = BlocProvider.of<MyPassportBloc>(context);
    _myPassportBloc.setDelegate(delegate: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return BlocBuilder<MyPassportBloc, MyPassportState>(
      builder: (BuildContext context, MyPassportState state) {
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
              title: Text('My Passport'),
            ),
            drawer: DrawerWidget(
              currentUser: state.user,
              page: APP_PAGES.MY_PASSPORT,
            ),
            body: AnnotatedRegion<SystemUiOverlayStyle>(
              value: SystemUiOverlayStyle.light,
              child: Center(
                child: Text('My Passport'),
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
        .showAlert(context: context, title: 'Error', message: message);
  }
}
