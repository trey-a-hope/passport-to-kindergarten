import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:p/ServiceLocator.dart';
import 'package:p/constants.dart';
import 'package:p/models/BookOfTheMonthModel.dart';
import 'package:p/models/LogModel.dart';
import 'package:p/services/ModalService.dart';
import 'package:p/widgets/DrawerWidget.dart';
import 'package:p/widgets/SpinnerWidget.dart';
import 'Bloc.dart' as READING_LOG_BP;
import 'package:p/blocs/readingLogAdd/Bloc.dart' as READING_LOG_ADD_BP;

class ReadingLogPage extends StatefulWidget {
  @override
  State createState() => ReadingLogPageState();
}

class ReadingLogPageState extends State<ReadingLogPage>
    implements READING_LOG_BP.ReadingLogDelegate {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  READING_LOG_BP.ReadingLogBloc _readingLogBloc;

  @override
  void initState() {
    _readingLogBloc = BlocProvider.of<READING_LOG_BP.ReadingLogBloc>(context);
    _readingLogBloc.setDelegate(delegate: this);
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<READING_LOG_BP.ReadingLogBloc,
        READING_LOG_BP.ReadingLogState>(
      builder: (BuildContext context, READING_LOG_BP.ReadingLogState state) {
        if (state is READING_LOG_BP.LoadingState) {
          return Container(
            color: Colors.white,
            child: SpinnerWidget(),
          );
        }

        if (state is READING_LOG_BP.LoadedState) {
          final List<LogModel> readLogs = state.readLogs;

          return Scaffold(
            key: _scaffoldKey,
            appBar: AppBar(
              centerTitle: true,
              title: Text('Read Logs - ${readLogs.length}'),
              actions: [
                IconButton(
                  icon: Icon(Icons.refresh),
                  onPressed: () {
                    _readingLogBloc.add(
                      READING_LOG_BP.LoadPageEvent(),
                    );
                  },
                ),
                IconButton(
                  icon: Icon(Icons.add),
                  onPressed: () {
                    Route route = MaterialPageRoute(
                      builder: (BuildContext context) => BlocProvider(
                        create: (BuildContext context) =>
                            READING_LOG_ADD_BP.ReadingLogAddBloc()
                              ..add(
                                READING_LOG_ADD_BP.LoadPageEvent(),
                              ),
                        child: READING_LOG_ADD_BP.ReadingLogAddPage(),
                      ),
                    );
                    Navigator.push(context, route);
                  },
                ),
              ],
            ),
            drawer: DrawerWidget(
              currentUser: state.user,
              page: APP_PAGES.READ_LOG,
            ),
            body: AnnotatedRegion<SystemUiOverlayStyle>(
              value: SystemUiOverlayStyle.light,
              child: ListView.builder(
                  itemCount: readLogs.length,
                  itemBuilder: (BuildContext context, int index) {
                    final LogModel readLog = readLogs[index];
                    return ListTile(
                      leading: Icon(Icons.bookmark),
                      title: Text('${readLog.description}'),
                      subtitle: Text(DateFormat('MMMM dd, yyyy').format(
                        readLog.created,
                      )),
                    );
                  }),
            ),
          );
        }

        if (state is READING_LOG_BP.ErrorState) {
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
