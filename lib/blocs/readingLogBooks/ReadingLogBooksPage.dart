import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:p/ServiceLocator.dart';
import 'package:p/constants.dart';
import 'package:p/models/ParentLogModel.dart';
import 'package:p/models/LogModel.dart';
import 'package:p/services/ModalService.dart';
import 'package:p/widgets/DrawerWidget.dart';
import 'package:p/widgets/FullWidthButtonWidget.dart';
import 'package:p/widgets/SpinnerWidget.dart';
import 'Bloc.dart' as READING_LOG_BOOKS_BP;
import 'package:p/blocs/readingLogAdd/Bloc.dart' as READING_LOG_ADD_BP;
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
            key: _scaffoldKey,
            appBar: AppBar(
              centerTitle: true,
              title: Text('Read Log'),
            ),
            drawer: DrawerWidget(
              currentUser: state.user,
              page: APP_PAGES.READ_LOG,
            ),
            body: AnnotatedRegion<SystemUiOverlayStyle>(
              value: SystemUiOverlayStyle.light,
              child: SafeArea(
                child: Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                        itemCount: books.length,
                        itemBuilder: (BuildContext context, int index) {
                          final ParentLogModel book = books[index];
                          return ListTile(
                            leading: Icon(Icons.bookmark),
                            title: Text('${book.title}'),
                            subtitle: Text(
                              'Created ${DateFormat('MMMM dd, yyyy').format(book.created)}',
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
                            trailing: CircleAvatar(
                              backgroundColor: Colors.orange.shade700,
                              child: Text(
                                '${book.logCount}',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          );
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
                      buttonColor: Colors.grey,
                    )
                  ],
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
