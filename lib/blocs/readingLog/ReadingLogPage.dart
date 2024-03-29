import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:getwidget/getwidget.dart';
import 'package:intl/intl.dart';
import 'package:p/ServiceLocator.dart';
import 'package:p/SuccessMessagePage.dart';
import 'package:p/constants.dart';
import 'package:p/models/EntryModel.dart';
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
  // CalendarController _calendarController = CalendarController();

  @override
  void initState() {
    _readingLogBloc = BlocProvider.of<ReadingLogBloc>(context);
    _readingLogBloc.setDelegate(delegate: this);
    super.initState();
  }

  @override
  void dispose() {
    // _calendarController.dispose();
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
          final List<EntryModel> bookEntries = state.bookEntries;
          final UserModel currentUser = state.currentUser;

          int totalLogCount = 0;
          bookEntries.forEach((bookEntry) {
            totalLogCount += bookEntry.logCount;
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
                color: colorCream,
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
                                color: colorOrange,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(width: 10),
                            Image.network('$STAMP_15_BOOKS_READ', width: 100),
                            SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                children: [
                                  Text(
                                    'Your progress to $_totalBookProgressAmount MORE books read!',
                                    style: TextStyle(
                                      color: colorNavy,
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
                                    progressColor: colorOrange,
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
                        color: colorDarkCream,
                        child: Center(
                          child: Text(
                            'Tap on  a title below to log another reading.',
                            style: TextStyle(
                                color: colorNavy, fontWeight: FontWeight.bold),
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
                          color: colorNavy,
                        ),
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Padding(
                              padding: EdgeInsets.all(10),
                              child: GFButton(
                                color: colorNavy,
                                onPressed: () {
                                  bookEntries.sort(
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
                                color: colorNavy,
                                onPressed: () {
                                  bookEntries.sort(
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
                                color: colorNavy,
                                onPressed: () {
                                  bookEntries.sort(
                                    (a, b) =>
                                        a.book.title.compareTo(b.book.title),
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
                      ListView.builder(
                        shrinkWrap: true,
                        physics: ClampingScrollPhysics(),
                        itemCount: bookEntries.length,
                        itemBuilder: (BuildContext context, int index) {
                          final EntryModel bookEntry = bookEntries[index];
                          return ExpansionTile(
                            key: GlobalKey(),
                            leading: Container(
                              height: 50,
                              width: 50,
                              foregroundDecoration: BoxDecoration(
                                color: bookEntry.book.given
                                    ? Colors.transparent
                                    : Colors.grey,
                                backgroundBlendMode: BlendMode.saturation,
                              ),
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  fit: BoxFit.fill,
                                  image: Image.network(
                                    bookEntry.book.imgUrl == null
                                        ? DUMMY_PROFILE_PHOTO_URL
                                        : bookEntry.book.imgUrl,
                                  ).image,
                                ),
                              ),
                            ),
                            title: Text(
                              '${bookEntry.book.title} (${bookEntry.logCount})',
                              style: TextStyle(
                                color: colorNavy,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            children: [
                              bookEntry.logCount == 0
                                  ? SizedBox.shrink()
                                  : Container(
                                      height: 50,
                                      color: colorYellow,
                                      child: Center(
                                        child: Text(
                                          'Wow! You have read this book ${bookEntry.logCount} ${bookEntry.logCount == 1 ? 'time' : 'times'}!',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                              TableCalendar(
                                firstDay: DateTime.now().subtract(
                                  Duration(days: 365),
                                ),
                                lastDay: DateTime.now().add(
                                  Duration(days: 365),
                                ),
                                availableCalendarFormats: const {
                                  CalendarFormat.month: 'Month'
                                },
                                eventLoader: (day) {
                                  DateTime dayKey = DateTime(
                                    day.year,
                                    day.month,
                                    day.day,
                                  );

                                  return bookEntry.logEvents[dayKey] ?? [];
                                },
                                startingDayOfWeek: StartingDayOfWeek.sunday,
                                focusedDay: DateTime.now(),
                                calendarStyle: CalendarStyle(
                                  outsideDaysVisible: false,
                                ),
                                calendarBuilders: CalendarBuilders(
                                  markerBuilder: (context, day, events) {
                                    if (events.isNotEmpty) {
                                      return Center(
                                        child: Stack(
                                          children: [
                                            Container(height: 50, width: 50),
                                            Positioned(
                                              bottom: 0,
                                              right: 0,
                                              child: CircleAvatar(
                                                backgroundColor: colorNavy,
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
                                      );
                                    } else {
                                      return Container();
                                    }
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
                                onDaySelected: (selectedDay, focusedDay) async {
                                  DateTime now = DateTime.now();
                                  now = now.add(
                                    const Duration(days: 1),
                                  );
                                  if (now.isBefore(selectedDay)) {
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
                                              '${DateFormat('MMMM dd, yyyy').format(selectedDay)} for \"${bookEntry.book.title}\"');

                                  if (!confirm) return;

                                  bool totalLogLimitReached =
                                      currentLogCount + 1 ==
                                          _totalBookProgressAmount;

                                  _readingLogBloc.add(
                                    CreateBookLogEvent(
                                      date: selectedDay,
                                      totalLogLimitReached:
                                          totalLogLimitReached,
                                      idOfEntry: bookEntry.id,
                                    ),
                                  );
                                },
                                // onVisibleDaysChanged: (DateTime first,
                                //     DateTime last, CalendarFormat format) {},
                              ),
                            ],
                          );
                        },
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
                          buttonColor: colorNavy,
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
    locator<ModalService>().showInSnackBar(context: context, message: message);
  }

  @override
  void showAwardMessage() {
    Route route = MaterialPageRoute(
      builder: (BuildContext context) => SuccessMessagePage(),
    );
    Navigator.push(context, route);
  }
}
