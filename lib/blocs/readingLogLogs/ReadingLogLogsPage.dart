import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:p/ServiceLocator.dart';
import 'package:p/constants.dart';
import 'package:p/models/ChildLogModel.dart';
import 'package:p/models/ParentLogModel.dart';
import 'package:p/models/LogModel.dart';
import 'package:p/services/ModalService.dart';
import 'package:p/widgets/DrawerWidget.dart';
import 'package:p/widgets/FullWidthButtonWidget.dart';
import 'package:p/widgets/SpinnerWidget.dart';
import 'Bloc.dart' as READING_LOG_LOGS_BP;
import 'package:p/blocs/readingLogAdd/Bloc.dart' as READING_LOG_ADD_BP;
import 'package:p/blocs/readingLogBooksAdd/Bloc.dart'
    as READING_LOG_BOOKS_ADD_BP;

class ReadingLogLogsPage extends StatefulWidget {
  @override
  State createState() => ReadingLogLogsPageSate();
}

class ReadingLogLogsPageSate extends State<ReadingLogLogsPage>
    implements READING_LOG_LOGS_BP.ReadingLogLogsDelegate {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  READING_LOG_LOGS_BP.ReadingLogLogsBloc _readingLogLogsBloc;

  @override
  void initState() {
    _readingLogLogsBloc =
        BlocProvider.of<READING_LOG_LOGS_BP.ReadingLogLogsBloc>(context);
    _readingLogLogsBloc.setDelegate(delegate: this);
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<READING_LOG_LOGS_BP.ReadingLogLogsBloc,
        READING_LOG_LOGS_BP.ReadingLogLogsState>(
      builder: (BuildContext context,
          READING_LOG_LOGS_BP.ReadingLogLogsState state) {
        if (state is READING_LOG_LOGS_BP.LoadingState) {
          return Container(
            color: Colors.white,
            child: SpinnerWidget(),
          );
        }

        if (state is READING_LOG_LOGS_BP.LoadedState) {
          final List<ChildLogModel> logs = state.logs;
          final ParentLogModel book = state.book;

          return Scaffold(
            key: _scaffoldKey,
            appBar: AppBar(
              centerTitle: true,
              title: Text('${book.title}'),
            ),
            body: AnnotatedRegion<SystemUiOverlayStyle>(
              value: SystemUiOverlayStyle.light,
              child: SafeArea(
                child: Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                        itemCount: logs.length,
                        itemBuilder: (BuildContext context, int index) {
                          final ChildLogModel log = logs[index];
                          return ListTile(
                            leading: Icon(Icons.bookmark),
                            title: Text('${log.title}'),
                            subtitle: Text(
                              'Created ${DateFormat('MMMM dd, yyyy').format(log.created)}',
                            ),
                            onTap: () {
                              // Route route = MaterialPageRoute(
                              //   builder: (BuildContext context) => BlocProvider(
                              //     create: (BuildContext context) =>
                              //         READING_LOG_ADD_BP.ReadingLogAddBloc(
                              //             book: book)
                              //           ..add(
                              //             READING_LOG_ADD_BP.LoadPageEvent(),
                              //           ),
                              //     child: READING_LOG_ADD_BP.ReadingLogAddPage(),
                              //   ),
                              // );
                              // Navigator.push(context, route);
                            },
                          );
                        },
                      ),
                    ),
                    FullWidthButtonWidget(
                      onPressed: () {
                        // Route route = MaterialPageRoute(
                        //   builder: (BuildContext context) => BlocProvider(
                        //     create: (BuildContext context) =>
                        //         READING_LOG_BOOKS_ADD_BP
                        //             .ReadingLogBooksAddBloc()
                        //           ..add(
                        //             READING_LOG_BOOKS_ADD_BP.LoadPageEvent(),
                        //           ),
                        //     child: READING_LOG_BOOKS_ADD_BP
                        //         .ReadingLogBooksAddPage(),
                        //   ),
                        // );
                        // Navigator.push(context, route);
                      },
                      text: 'Add a New Log',
                      textColor: Colors.white,
                      buttonColor: Colors.grey,
                    )
                  ],
                ),
              ),
            ),
          );
        }

        if (state is READING_LOG_LOGS_BP.ErrorState) {
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
