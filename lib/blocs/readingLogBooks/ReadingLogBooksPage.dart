import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:getwidget/getwidget.dart';
import 'package:p/ServiceLocator.dart';
import 'package:p/constants.dart';
import 'package:p/models/ParentLogModel.dart';
import 'package:p/services/ModalService.dart';
import 'package:p/widgets/FullWidthButtonWidget.dart';
import 'package:p/widgets/SpinnerWidget.dart';
import 'Bloc.dart' as READING_LOG_BOOKS_BP;
import 'package:p/blocs/readingLogLogs/Bloc.dart' as READING_LOG_LOGS_BP;
import 'package:p/blocs/readingLogBooksAdd/Bloc.dart'
    as READING_LOG_BOOKS_ADD_BP;
import 'package:percent_indicator/percent_indicator.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ReadingLogBooksPage extends StatefulWidget {
  @override
  State createState() => ReadingLogBooksPageState();
}

class ReadingLogBooksPageState extends State<ReadingLogBooksPage>
    implements READING_LOG_BOOKS_BP.ReadingLogBooksDelegate {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final int _totalBookProgressAmount = 15;
  SharedPreferences _sharedPreferences;
  READING_LOG_BOOKS_BP.ReadingLogBooksBloc _readLogBooksBloc;

  @override
  void initState() {
    _readLogBooksBloc =
        BlocProvider.of<READING_LOG_BOOKS_BP.ReadingLogBooksBloc>(context);
    _readLogBooksBloc.setDelegate(delegate: this);
    _loadSharedPref();
    super.initState();
  }

  _loadSharedPref() async {
    _sharedPreferences = await SharedPreferences.getInstance();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _goToLogsForThisBook({
    @required ParentLogModel book,
    @required DateTime initialSelectedDay,
  }) {
    Route route = MaterialPageRoute(
      builder: (BuildContext context) => BlocProvider(
        create: (BuildContext context) =>
            READING_LOG_LOGS_BP.ReadingLogLogsBloc(
          book: book,
          initialSelectedDay: initialSelectedDay,
        )..add(
                READING_LOG_LOGS_BP.LoadPageEvent(),
              ),
        child: READING_LOG_LOGS_BP.ReadingLogLogsPage(),
      ),
    );
    Navigator.push(context, route);
  }

  Widget _buildSortButtons({
    @required String sortBy,
  }) {
    return Row(
      children: [
        Expanded(
          child: Padding(
            padding: EdgeInsets.all(10),
            child: GFButton(
              color: COLOR_NAVY,
              onPressed: () {
                _readLogBooksBloc.add(
                  READING_LOG_BOOKS_BP.UpdateSortEvent(
                    sortBy: 'recent',
                  ),
                );
              },
              text: "Recent",
              shape: GFButtonShape.pills,
              type: sortBy == 'recent' ? null : GFButtonType.outline2x,
            ),
          ),
        ),
        Expanded(
          child: Padding(
            padding: EdgeInsets.all(10),
            child: GFButton(
              color: COLOR_NAVY,
              onPressed: () {
                _readLogBooksBloc.add(
                  READING_LOG_BOOKS_BP.UpdateSortEvent(
                    sortBy: 'mostRead',
                  ),
                );
              },
              text: "Most Read",
              shape: GFButtonShape.pills,
              type: sortBy == 'mostRead' ? null : GFButtonType.outline2x,
            ),
          ),
        ),
        Expanded(
          child: Padding(
            padding: EdgeInsets.all(10),
            child: GFButton(
              color: COLOR_NAVY,
              onPressed: () {
                _readLogBooksBloc.add(
                  READING_LOG_BOOKS_BP.UpdateSortEvent(
                    sortBy: 'leastRead',
                  ),
                );
              },
              text: "Least Read",
              shape: GFButtonShape.pills,
              type: sortBy == 'leastRead' ? null : GFButtonType.outline2x,
            ),
          ),
        ),
      ],
    );
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

          int totalLogCount = 0;
          books.forEach((book) {
            totalLogCount += book.logCount;
          });

          _sharedPreferences.setInt('totalLogCount', totalLogCount);

          final int remainingLogCount =
              totalLogCount % _totalBookProgressAmount;

          final int numberOf15BooksRead =
              totalLogCount ~/ _totalBookProgressAmount;

          return Scaffold(
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
                      Stack(
                        children: [
                          Image.asset(
                            ASSET_p2k20_app_header_bar,
                            width: screenWidth,
                          ),
                          Positioned.fill(
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: IconButton(
                                icon: Icon(
                                  Icons.chevron_left,
                                  color: Colors.white,
                                ),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              ),
                            ),
                          ),
                          Positioned.fill(
                            child: Align(
                              alignment: Alignment.center,
                              child: Text(
                                'Reading Log',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 21,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                      Padding(
                        padding: EdgeInsets.all(20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'x$numberOf15BooksRead',
                              style: TextStyle(
                                color: COLOR_ORANGE,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(width: 10),
                            Image.asset(ASSET_p2k20_app_stamp_15_books_read,
                                width: 100),
                            SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                children: [
                                  Text(
                                    'Your progress to $_totalBookProgressAmount MORE books read!',
                                    style: TextStyle(
                                      color: COLOR_NAVY,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  LinearPercentIndicator(
                                    center: Text(
                                      '$remainingLogCount',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white),
                                    ),
                                    lineHeight: 30.0,
                                    percent: remainingLogCount /
                                        _totalBookProgressAmount,
                                    backgroundColor: Colors.grey,
                                    progressColor: COLOR_ORANGE,
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                      Container(
                        width: double.infinity,
                        height: 50,
                        color: COLOR_DARK_CREAM,
                        child: Center(
                          child: Text(
                            'Tap on  a title below to log another reading.',
                            style: TextStyle(
                              color: COLOR_NAVY,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        'Sort Books By...',
                        style: TextStyle(
                          color: COLOR_NAVY,
                        ),
                      ),
                      _buildSortButtons(
                        sortBy: state.sortBy,
                      ),
                      Expanded(
                        child: ListView.builder(
                          itemCount: books.length,
                          itemBuilder: (BuildContext context, int index) {
                            final ParentLogModel book = books[index];

                            //todo: check here if any of the books have the same title as any of the books of the month.
                            //todo: this way, you can just use the image url here instead of the DUMMY one.
                            return ExpansionTile(
                              title: ListTile(
                                leading: CircleAvatar(
                                  backgroundColor: Colors.transparent,
                                  child: Text(
                                    '${book.logCount}',
                                    style: TextStyle(
                                      color: COLOR_ORANGE,
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
                                    Text(
                                      '${book.title}',
                                      style: TextStyle(
                                        color: COLOR_NAVY,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    )
                                  ],
                                ),
                                onTap: () {},
                              ),
                              children: [
                                Container(
                                  height: 50,
                                  color: COLOR_YELLOW,
                                  child: Center(
                                    child: Text(
                                      'Wow! You have read this book ${book.logCount} times!',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                                Row(
                                  children: [
                                    Expanded(
                                      child: Padding(
                                        padding: EdgeInsets.all(10),
                                        child: FullWidthButtonWidget(
                                          textColor: Colors.white,
                                          onPressed: () {
                                            _goToLogsForThisBook(
                                              book: book,
                                              initialSelectedDay:
                                                  DateTime(2020, 1),
                                            );
                                          },
                                          buttonColor: COLOR_NAVY,
                                          text: 'January',
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Padding(
                                        padding: EdgeInsets.all(10),
                                        child: FullWidthButtonWidget(
                                          textColor: Colors.white,
                                          onPressed: () {
                                            _goToLogsForThisBook(
                                              book: book,
                                              initialSelectedDay:
                                                  DateTime(2020, 2),
                                            );
                                          },
                                          buttonColor: COLOR_NAVY,
                                          text: 'February',
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                                Row(
                                  children: [
                                    Expanded(
                                      child: Padding(
                                        padding: EdgeInsets.all(10),
                                        child: FullWidthButtonWidget(
                                          textColor: Colors.white,
                                          onPressed: () {
                                            _goToLogsForThisBook(
                                              book: book,
                                              initialSelectedDay:
                                                  DateTime(2020, 3),
                                            );
                                          },
                                          buttonColor: COLOR_NAVY,
                                          text: 'March',
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Padding(
                                        padding: EdgeInsets.all(10),
                                        child: FullWidthButtonWidget(
                                          textColor: Colors.white,
                                          onPressed: () {
                                            _goToLogsForThisBook(
                                              book: book,
                                              initialSelectedDay:
                                                  DateTime(2020, 4),
                                            );
                                          },
                                          buttonColor: COLOR_NAVY,
                                          text: 'April',
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                                Row(
                                  children: [
                                    Expanded(
                                      child: Padding(
                                        padding: EdgeInsets.all(10),
                                        child: FullWidthButtonWidget(
                                          textColor: Colors.white,
                                          onPressed: () {
                                            _goToLogsForThisBook(
                                              book: book,
                                              initialSelectedDay:
                                                  DateTime(2020, 5),
                                            );
                                          },
                                          buttonColor: COLOR_NAVY,
                                          text: 'May',
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Padding(
                                        padding: EdgeInsets.all(10),
                                        child: FullWidthButtonWidget(
                                          textColor: Colors.white,
                                          onPressed: () {
                                            _goToLogsForThisBook(
                                              book: book,
                                              initialSelectedDay:
                                                  DateTime(2020, 6),
                                            );
                                          },
                                          buttonColor: COLOR_NAVY,
                                          text: 'June',
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                                Row(
                                  children: [
                                    Expanded(
                                      child: Padding(
                                        padding: EdgeInsets.all(10),
                                        child: FullWidthButtonWidget(
                                          textColor: Colors.white,
                                          onPressed: () {
                                            _goToLogsForThisBook(
                                              book: book,
                                              initialSelectedDay:
                                                  DateTime(2020, 7),
                                            );
                                          },
                                          buttonColor: COLOR_NAVY,
                                          text: 'July',
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Padding(
                                        padding: EdgeInsets.all(10),
                                        child: FullWidthButtonWidget(
                                          textColor: Colors.white,
                                          onPressed: () {
                                            _goToLogsForThisBook(
                                              book: book,
                                              initialSelectedDay:
                                                  DateTime(2020, 8),
                                            );
                                          },
                                          buttonColor: COLOR_NAVY,
                                          text: 'August',
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                                Row(
                                  children: [
                                    Expanded(
                                      child: Padding(
                                        padding: EdgeInsets.all(10),
                                        child: FullWidthButtonWidget(
                                          textColor: Colors.white,
                                          onPressed: () {
                                            _goToLogsForThisBook(
                                              book: book,
                                              initialSelectedDay:
                                                  DateTime(2020, 9),
                                            );
                                          },
                                          buttonColor: COLOR_NAVY,
                                          text: 'September',
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Padding(
                                        padding: EdgeInsets.all(10),
                                        child: FullWidthButtonWidget(
                                          textColor: Colors.white,
                                          onPressed: () {
                                            _goToLogsForThisBook(
                                              book: book,
                                              initialSelectedDay:
                                                  DateTime(2020, 10),
                                            );
                                          },
                                          buttonColor: COLOR_NAVY,
                                          text: 'October',
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                                Row(
                                  children: [
                                    Expanded(
                                      child: Padding(
                                        padding: EdgeInsets.all(10),
                                        child: FullWidthButtonWidget(
                                          textColor: Colors.white,
                                          onPressed: () {
                                            _goToLogsForThisBook(
                                              book: book,
                                              initialSelectedDay:
                                                  DateTime(2020, 11),
                                            );
                                          },
                                          buttonColor: COLOR_NAVY,
                                          text: 'November',
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Padding(
                                        padding: EdgeInsets.all(10),
                                        child: FullWidthButtonWidget(
                                          textColor: Colors.white,
                                          onPressed: () {
                                            _goToLogsForThisBook(
                                              book: book,
                                              initialSelectedDay:
                                                  DateTime(2020, 12),
                                            );
                                          },
                                          buttonColor: COLOR_NAVY,
                                          text: 'December',
                                        ),
                                      ),
                                    )
                                  ],
                                )
                              ],
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
                        text: 'Add a new title',
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
