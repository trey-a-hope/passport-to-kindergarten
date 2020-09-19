import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:p/ServiceLocator.dart';
import 'package:p/constants.dart';
import 'package:p/models/BookOfTheMonthModel.dart';
import 'package:p/models/VisitingLogModel.dart';
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
          final List<VisitingLogModel> visitLogs = state.visitLogs;

          return Scaffold(
            key: _scaffoldKey,
            appBar: AppBar(
              centerTitle: true,
              title: Text('Visit Logs - ${visitLogs.length}'),
              actions: [
                IconButton(
                  icon: Icon(Icons.refresh),
                  onPressed: () {
                    _visitingLogBloc.add(
                      VISITING_LOG_BP.LoadPageEvent(),
                    );
                  },
                ),
                IconButton(
                  icon: Icon(Icons.add),
                  onPressed: () {
                    Route route = MaterialPageRoute(
                      builder: (BuildContext context) => BlocProvider(
                        create: (BuildContext context) =>
                            VISITING_LOG_ADD_BP.VisitingLogAddBloc()
                              ..add(
                                VISITING_LOG_ADD_BP.LoadPageEvent(),
                              ),
                        child: VISITING_LOG_ADD_BP.VisitingLogAddPage(),
                      ),
                    );
                    Navigator.push(context, route);
                  },
                ),
              ],
            ),
            drawer: DrawerWidget(
              currentUser: state.user,
              page: APP_PAGES.VISITING_LOG,
            ),
            body: AnnotatedRegion<SystemUiOverlayStyle>(
              value: SystemUiOverlayStyle.light,
              child: ListView.builder(
                  itemCount: state.visitLogs.length,
                  itemBuilder: (BuildContext context, int index) {
                    final VisitingLogModel visitLog = visitLogs[index];
                    return ListTile(
                      leading: Icon(Icons.location_city),
                      title: Text('${visitLog.description}'),
                      subtitle: Text(DateFormat('MMMM dd, yyyy').format(
                        visitLog.created,
                      )),
                    );
                  }),
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
