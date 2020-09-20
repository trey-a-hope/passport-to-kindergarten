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

class AdminPage extends StatefulWidget {
  @override
  State createState() => AdminPageState();
}

class AdminPageState extends State<AdminPage> implements AdminBlocDelegate {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  AdminBloc _adminBloc;

  @override
  void initState() {
    _adminBloc = BlocProvider.of<AdminBloc>(context);
    _adminBloc.setDelegate(delegate: this);

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AdminBloc, AdminState>(
      builder: (BuildContext context, AdminState state) {
        if (state is LoadingState) {
          return Container(
            color: Colors.white,
            child: SpinnerWidget(),
          );
        }

        if (state is TeacherLoadedState) {
          return Scaffold(
            key: _scaffoldKey,
            appBar: AppBar(
              title: Text('Admin'),
            ),
            drawer: DrawerWidget(
              currentUser: state.user,
              page: APP_PAGES.ADMIN,
            ),
            body: AnnotatedRegion<SystemUiOverlayStyle>(
                value: SystemUiOverlayStyle.light,
                child: Center(
                  child: Text('Admin for Teacher'),
                )),
          );
        }

        if (state is SuperAdminLoadedState) {
          return Scaffold(
            key: _scaffoldKey,
            appBar: AppBar(
              title: Text('Admin'),
            ),
            drawer: DrawerWidget(
              currentUser: state.user,
              page: APP_PAGES.ADMIN,
            ),
            body: AnnotatedRegion<SystemUiOverlayStyle>(
                value: SystemUiOverlayStyle.light,
                child: Center(
                  child: Text('Admin for Super Admin'),
                )),
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
