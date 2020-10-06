import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:p/ServiceLocator.dart';
import 'package:p/constants.dart';
import 'package:p/models/ParentLogModel.dart';
import 'package:p/services/ModalService.dart';
import 'package:p/widgets/DrawerWidget.dart';
import 'package:p/widgets/FullWidthButtonWidget.dart';
import 'package:p/widgets/SpinnerWidget.dart';
import 'Bloc.dart' as READING_LOG_BOOKS_BP;
import 'package:p/blocs/readingLogLogs/Bloc.dart' as READING_LOG_LOGS_BP;

import 'package:p/blocs/readingLogBooksAdd/Bloc.dart'
    as READING_LOG_BOOKS_ADD_BP;

class ReadingLogBooksPage extends StatefulWidget {
  @override
  State createState() => ReadingLogBooksPageState();
}

class ReadingLogBooksPageState extends State<ReadingLogBooksPage>
    implements READING_LOG_BOOKS_BP.ReadingLogBooksDelegate {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  READING_LOG_BOOKS_BP.ReadingLogBooksBloc _readLogBooksBloc;

  @override
  void initState() {
    _readLogBooksBloc =
        BlocProvider.of<READING_LOG_BOOKS_BP.ReadingLogBooksBloc>(context);
    _readLogBooksBloc.setDelegate(delegate: this);
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<READING_LOG_BOOKS_BP.ReadingLogBooksBloc,
        READING_LOG_BOOKS_BP.ReadingLogBooksState>(
      builder: (BuildContext context,
          READING_LOG_BOOKS_BP.ReadingLogBooksState state) {
        if (state is READING_LOG_BOOKS_BP.LoadingState) {
          return Container(
            color: Colors.white,
            child: SpinnerWidget(),
          );
        }

        if (state is READING_LOG_BOOKS_BP.LoadedState) {
          final List<ParentLogModel> books = state.books;

          return Scaffold(
            appBar: AppBar(
              iconTheme: IconThemeData(color: Colors.black),
              backgroundColor: COLOR_CREAM,
            ),
            key: _scaffoldKey,
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
                        color: Colors.deepOrange,
                        child: Center(
                          child: Text(
                            'Reading Log',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 21,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: ListView.builder(
                          itemCount: books.length,
                          itemBuilder: (BuildContext context, int index) {
                            final ParentLogModel book = books[index];

                            //todo: check here if any of the books have the same title as any of the books of the month.
                            //todo: this way, you can just use the image url here instead of the DUMMY one.

                            return ListTile(
                                leading: CircleAvatar(
                                  backgroundColor: Colors.transparent,
                                  child: Text(
                                    '${book.logCount}',
                                    style: TextStyle(
                                      color: Colors.deepOrange,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20,
                                    ),
                                  ),
                                ),
                                title: Row(
                                  children: [
                                    CircleAvatar(
                                      backgroundImage:
                                          NetworkImage(DUMMY_PROFILE_PHOTO_URL),
                                    ),
                                    SizedBox(
                                      width: 15,
                                    ),
                                    Text('${book.title}')
                                  ],
                                ),
                                onTap: () {
                                  Route route = MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        BlocProvider(
                                      create: (BuildContext context) =>
                                          READING_LOG_LOGS_BP
                                              .ReadingLogLogsBloc(book: book)
                                            ..add(
                                              READING_LOG_LOGS_BP
                                                  .LoadPageEvent(),
                                            ),
                                      child: READING_LOG_LOGS_BP
                                          .ReadingLogLogsPage(),
                                    ),
                                  );
                                  Navigator.push(context, route);
                                },
                                trailing: Icon(Icons.chevron_right));
                          },
                        ),
                      ),
                      FullWidthButtonWidget(
                        onPressed: () {
                          Route route = MaterialPageRoute(
                            builder: (BuildContext context) => BlocProvider(
                              create: (BuildContext context) =>
                                  READING_LOG_BOOKS_ADD_BP
                                      .ReadingLogBooksAddBloc()
                                    ..add(
                                      READING_LOG_BOOKS_ADD_BP.LoadPageEvent(),
                                    ),
                              child: READING_LOG_BOOKS_ADD_BP
                                  .ReadingLogBooksAddPage(),
                            ),
                          );
                          Navigator.push(context, route);
                        },
                        text: 'Read A New Book?',
                        textColor: Colors.white,
                        buttonColor: COLOR_NAVY,
                      )
                    ],
                  ),
                ),
              ),
            ),
          );
        }

        if (state is READING_LOG_BOOKS_BP.ErrorState) {
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
