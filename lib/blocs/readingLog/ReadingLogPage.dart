import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:getwidget/getwidget.dart';
import 'package:intl/intl.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:p/ServiceLocator.dart';
import 'package:p/SuccessMessagePage.dart';
import 'package:p/constants.dart';
import 'package:p/models/BookModel.dart';
import 'package:p/models/UserModel.dart';
import 'package:p/services/ModalService.dart';
import 'package:p/widgets/AppBarWidget.dart';
import 'package:p/widgets/FullWidthButtonWidget.dart';
import 'package:p/widgets/SpinnerWidget.dart';
import 'package:table_calendar/table_calendar.dart';
import 'Bloc.dart';
import 'package:percent_indicator/percent_indicator.dart';

class ReadingLogPage extends StatefulWidget {
  @override
  State createState() => ReadingLogPageState();
}

class ReadingLogPageState extends State<ReadingLogPage>
    implements ReadingLogDelegate {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  ReadingLogBloc _readingLogBloc;

  final int _totalBookProgressAmount = 15;
  CalendarController _calendarController = CalendarController();

  @override
  void initState() {
    _readingLogBloc = BlocProvider.of<ReadingLogBloc>(context);
    _readingLogBloc.setDelegate(delegate: this);
    super.initState();
  }

  @override
  void dispose() {
    _calendarController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ReadingLogBloc, ReadingLogState>(
      builder: (BuildContext context, ReadingLogState state) {
        if (state is LoadingState) {
          return Container(
            color: Colors.white,
            child: SpinnerWidget(),
          );
        }

        if (state is LoadedState) {
          final List<BookModel> books = state.books;
          final UserModel currentUser = state.currentUser;

          int totalLogCount = 0;
          books.forEach((book) {
            totalLogCount += book.logCount;
          });

          final int currentLogCount = totalLogCount % _totalBookProgressAmount;

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
                  child: ListView(
                    shrinkWrap: true,
                    children: [
                      AppBarWidget(title: 'Reading Log'),
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
                                      '$currentLogCount',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white),
                                    ),
                                    lineHeight: 30.0,
                                    percent: currentLogCount /
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
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: COLOR_NAVY,
                        ),
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Padding(
                              padding: EdgeInsets.all(10),
                              child: GFButton(
                                color: COLOR_NAVY,
                                onPressed: () {
                                  books.sort(
                                    (a, b) => b.modified.compareTo(a.modified),
                                  );
                                  setState(() {
                                    currentUser.bookSortBy = 'recent';
                                  });
                                },
                                text: "Recent",
                                shape: GFButtonShape.pills,
                                type: currentUser.bookSortBy == 'recent'
                                    ? null
                                    : GFButtonType.outline2x,
                              ),
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding: EdgeInsets.all(10),
                              child: GFButton(
                                color: COLOR_NAVY,
                                onPressed: () {
                                  books.sort(
                                    (a, b) => b.logCount.compareTo(a.logCount),
                                  );
                                  setState(() {
                                    currentUser.bookSortBy = 'mostRead';
                                  });
                                },
                                text: "Most Read",
                                shape: GFButtonShape.pills,
                                type: currentUser.bookSortBy == 'mostRead'
                                    ? null
                                    : GFButtonType.outline2x,
                              ),
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding: EdgeInsets.all(10),
                              child: GFButton(
                                color: COLOR_NAVY,
                                onPressed: () {
                                  books.sort(
                                    (a, b) => a.title.compareTo(b.title),
                                  );
                                  setState(() {
                                    currentUser.bookSortBy = 'alphabet';
                                  });
                                },
                                text: 'A-Z',
                                shape: GFButtonShape.pills,
                                type: currentUser.bookSortBy == 'alphabet'
                                    ? null
                                    : GFButtonType.outline2x,
                              ),
                            ),
                          ),
                        ],
                      ),
                      Expanded(
                        child: ListView.builder(
                          shrinkWrap: true,
                          physics: ClampingScrollPhysics(),
                          itemCount: books.length,
                          itemBuilder: (BuildContext context, int index) {
                            final BookModel book = books[index];
                            return ExpansionTile(
                              key: GlobalKey(),
                              leading: CircleAvatar(
                                backgroundColor: Colors.transparent,
                                child: CircleAvatar(
                                  backgroundImage: book.assetImagePath == null
                                      ? NetworkImage(DUMMY_PROFILE_PHOTO_URL)
                                      : AssetImage(book.assetImagePath),
                                ),
                              ),
                              title: Text(
                                '${book.title} (${book.logCount})',
                                style: TextStyle(
                                  color: COLOR_NAVY,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              children: [
                                book.logCount == 0
                                    ? SizedBox.shrink()
                                    : Container(
                                        height: 50,
                                        color: COLOR_YELLOW,
                                        child: Center(
                                          child: Text(
                                            'Wow! You have read this book ${book.logCount} ${book.logCount == 1 ? 'time' : 'times'}!',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ),
                                TableCalendar(
                                  availableCalendarFormats: const {
                                    CalendarFormat.month: 'Month'
                                  },
                                  calendarController: _calendarController,
                                  events: book.logEvents,
                                  startingDayOfWeek: StartingDayOfWeek.sunday,
                                  initialSelectedDay: DateTime.now(),
                                  calendarStyle: CalendarStyle(
                                    selectedColor: Colors.deepOrange[400],
                                    todayColor: Colors.deepOrange[200],
                                    markersColor: Colors.black,
                                    outsideDaysVisible: false,
                                  ),
                                  builders: CalendarBuilders(
                                    markersBuilder:
                                        (context, date, events, holidays) {
                                      final children = <Widget>[];

                                      if (events.isNotEmpty) {
                                        children.add(
                                          Center(
                                            child: Stack(
                                              children: [
                                                Container(
                                                    height: 50, width: 50),
                                                Positioned(
                                                  bottom: 0,
                                                  right: 0,
                                                  child: CircleAvatar(
                                                    backgroundColor: COLOR_NAVY,
                                                    child: Text(
                                                      '${events.length}',
                                                      style: TextStyle(
                                                        fontSize: 10,
                                                        color: Colors.white,
                                                      ),
                                                    ),
                                                    radius: 10,
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                        );
                                      }

                                      return children;
                                    },
                                  ),
                                  headerStyle: HeaderStyle(
                                    formatButtonTextStyle: TextStyle().copyWith(
                                        color: Colors.white, fontSize: 15.0),
                                    formatButtonDecoration: BoxDecoration(
                                      color: Colors.deepOrange[400],
                                      borderRadius: BorderRadius.circular(8.0),
                                    ),
                                  ),
                                  onDaySelected:
                                      (DateTime day, List events) async {
                                    DateTime now = DateTime.now();
                                    now = now.add(
                                      const Duration(days: 1),
                                    );
                                    if (now.isBefore(day)) {
                                      locator<ModalService>().showAlert(
                                          context: context,
                                          title: 'Sorry',
                                          message:
                                              'You cannot log in the future.');
                                      return;
                                    }
                                    final bool confirm = await locator<
                                            ModalService>()
                                        .showConfirmation(
                                            context: context,
                                            title: 'Add Log',
                                            message:
                                                '${DateFormat('MMMM dd, yyyy').format(day)} for \"${book.title}\"');

                                    if (!confirm) return;

                                    bool totalLogLimitReached =
                                        currentLogCount + 1 ==
                                            _totalBookProgressAmount;

                                    _readingLogBloc.add(
                                      CreateBookLogEvent(
                                        bookID: book.id,
                                        date: day,
                                        totalLogLimitReached:
                                            totalLogLimitReached,
                                      ),
                                    );
                                  },
                                  onVisibleDaysChanged: (DateTime first,
                                      DateTime last, CalendarFormat format) {},
                                ),
                              ],
                            );
                          },
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(10),
                        child: FullWidthButtonWidget(
                          onPressed: () async {
                            dynamic res = await locator<ModalService>()
                                .showAddBook(context: context);

                            if (res == null) return;

                            _readingLogBloc.add(
                              CreateBookEvent(
                                title: res['title'],
                                author: res['author'],
                              ),
                            );
                          },
                          text: 'Add new title',
                          buttonColor: COLOR_NAVY,
                          textColor: Colors.white,
                        ),
                      )
                    ],
                  ),
                ),
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

  @override
  void showAwardMessage() {
    Route route = MaterialPageRoute(
      builder: (BuildContext context) => SuccessMessagePage(),
    );
    Navigator.push(context, route);
  }
}
