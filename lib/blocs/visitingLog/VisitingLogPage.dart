import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:p/ServiceLocator.dart';
import 'package:p/constants.dart';
import 'package:p/models/BookOfTheMonthModel.dart';
import 'package:p/models/LogModel.dart';
import 'package:p/models/ParentLogModel.dart';
import 'package:p/services/ModalService.dart';
import 'package:p/widgets/DrawerWidget.dart';
import 'package:p/widgets/SpinnerWidget.dart';
import 'Bloc.dart' as VISITING_LOG_BP;
import 'package:p/blocs/visitingLogAdd/Bloc.dart' as VISITING_LOG_ADD_BP;

class VisitingLogPage extends StatefulWidget {
  @override
  State createState() => VisitingLogPageState();
}

class VisitingLogPageState extends State<VisitingLogPage>
    implements VISITING_LOG_BP.VisitingLogDelegate {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  VISITING_LOG_BP.VisitingLogBloc _visitingLogBloc;

  @override
  void initState() {
    _visitingLogBloc =
        BlocProvider.of<VISITING_LOG_BP.VisitingLogBloc>(context);
    _visitingLogBloc.setDelegate(delegate: this);
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<VISITING_LOG_BP.VisitingLogBloc,
        VISITING_LOG_BP.VisitingLogState>(
      builder: (BuildContext context, VISITING_LOG_BP.VisitingLogState state) {
        if (state is VISITING_LOG_BP.LoadingState) {
          return Container(
            color: Colors.white,
            child: SpinnerWidget(),
          );
        }

        if (state is VISITING_LOG_BP.LoadedState) {
          final List<ParentLogModel> visitLogs = state.visitLogs;

          return Scaffold(
            key: _scaffoldKey,
            appBar: AppBar(
              iconTheme: IconThemeData(color: Colors.black),
              backgroundColor: COLOR_CREAM,
            ),
            body: AnnotatedRegion<SystemUiOverlayStyle>(
              value: SystemUiOverlayStyle.light,
              child: Container(
                width: screenWidth,
                height: screenHeight,
                color: COLOR_CREAM,
                child: SafeArea(
                  child: Column(
                    children: [
                      Container(
                        width: screenWidth,
                        height: 80,
                        color: COLOR_ORANGE,
                        child: Center(
                          child: Text(
                            'Visit Log',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 21,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Center(
                          child: Text(
                            'Still Needs Work...',
                            style: TextStyle(
                              color: COLOR_NAVY,
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          );
        }

        if (state is VISITING_LOG_BP.ErrorState) {
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
