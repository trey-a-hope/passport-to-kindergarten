import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:getwidget/components/button/gf_button.dart';
import 'package:getwidget/shape/gf_button_shape.dart';
import 'package:getwidget/types/gf_button_type.dart';
import 'package:intl/intl.dart';
import 'package:maps_launcher/maps_launcher.dart';
import 'package:p/ServiceLocator.dart';
import 'package:p/constants.dart';
import 'package:p/models/BookModel.dart';
import 'package:p/models/StampModel.dart';
import 'package:p/models/UserModel.dart';
import 'package:p/models/VisitModel.dart';
import 'package:p/services/ModalService.dart';
import 'package:p/services/ValidatorService.dart';
import 'package:p/widgets/AppBarWidget.dart';
import 'package:p/widgets/FullWidthButtonWidget.dart';
import 'package:p/widgets/SpinnerWidget.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:url_launcher/url_launcher.dart';
import 'Bloc.dart';

class MyClassPage extends StatefulWidget {
  @override
  State createState() => MyClassPageState();
}

class MyClassPageState extends State<MyClassPage>
    implements MyClassBlocDelegate {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  MyClassBloc _myClassBloc;
  final TextEditingController _titleConController = TextEditingController();
  final TextEditingController _authorConController = TextEditingController();

  final int _totalBookProgressAmount = 15;
  CalendarController _calendarController = CalendarController();

  @override
  void initState() {
    _myClassBloc = BlocProvider.of<MyClassBloc>(context);
    _myClassBloc.setDelegate(delegate: this);
    super.initState();
  }

  @override
  void dispose() {
    _calendarController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;

    return BlocBuilder<MyClassBloc, MyClassState>(
      builder: (BuildContext context, MyClassState state) {
        if (state is LoadingState) {
          return Container(
            color: Colors.white,
            child: SpinnerWidget(),
          );
        }

        if (state is LoadedState) {
          final UserModel currentUser = state.user;
          final List<UserModel> students = state.students;
          final bool studentSelected = state.studentSelected;

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
                      AppBarWidget(title: 'My Class'),
                      studentSelected
                          ? SizedBox.shrink()
                          : Column(
                              children: [
                                Padding(
                                  padding: EdgeInsets.all(20),
                                  child: Text(
                                    'Tap a student\'s  name to see a list of their Passport stamps and to log reading or partner visits.',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: COLOR_NAVY,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 21,
                                    ),
                                  ),
                                ),
                                Image.asset(
                                  ASSET_p2k20_app_dotted_line,
                                  width: screenWidth,
                                ),
                                Padding(
                                  padding: EdgeInsets.all(10),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Text(
                                        '${currentUser.firstName} ${currentUser.lastName}',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: COLOR_NAVY),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                      Expanded(
                        child: ListView.builder(
                          itemCount: students.length,
                          itemBuilder: (BuildContext context, int index) {
                            final UserModel student = students[index];

                            final List<StampModel> stamps = student.stamps;
                            final List<BookModel> books = student.books;
                            final List<VisitModel> visits = student.visits;

                            int totalLogCount = 0;
                            books.forEach((book) {
                              totalLogCount += book.logCount;
                            });

                            final int remainingLogCount =
                                totalLogCount % _totalBookProgressAmount;

                            final int numberOf15BooksRead =
                                totalLogCount ~/ _totalBookProgressAmount;

                            return ExpansionTile(
                              backgroundColor: COLOR_NAVY,
                              leading: CircleAvatar(
                                backgroundImage: NetworkImage(
                                  '${student.imgUrl}',
                                ),
                              ),
                              title: Text(
                                '${student.firstName} ${student.lastName}',
                              ),
                              trailing: Icon(Icons.chevron_right),
                              children: [
                                ExpansionTile(
                                  backgroundColor: Colors.white,
                                  title: Text(
                                    'List of passport stamps',
                                    style: TextStyle(
                                      color: Colors.white,
                                    ),
                                  ),
                                  children: [
                                    Container(
                                      height: 300,
                                      child: StaggeredGridView.countBuilder(
                                        shrinkWrap: true,
                                        crossAxisCount: 4,
                                        itemCount: stamps.length,
                                        itemBuilder:
                                            (BuildContext context, int index) {
                                          final StampModel stamp =
                                              stamps[index];
                                          return Image.asset(
                                            stamp.assetImagePath,
                                            height: 100,
                                          );
                                        },
                                        staggeredTileBuilder: (int index) =>
                                            StaggeredTile.count(
                                                2, index.isEven ? 2 : 1),
                                        mainAxisSpacing: 4.0,
                                        crossAxisSpacing: 4.0,
                                      ),
                                    )
                                  ],
                                ),
                                ExpansionTile(
                                  backgroundColor: COLOR_YELLOW,
                                  title: Text(
                                    'Add a new title',
                                    style: TextStyle(
                                      color: Colors.white,
                                    ),
                                  ),
                                  children: [
                                    Container(
                                      height: 360,
                                      child: Column(
                                        children: [
                                          Text(
                                            'Add a new book that your student hasn\'t already logged here.',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              color: COLOR_NAVY,
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.fromLTRB(
                                                20, 30, 20, 0),
                                            child: TextFormField(
                                              autovalidateMode: AutovalidateMode
                                                  .onUserInteraction,
                                              cursorColor: Colors.black,
                                              validator:
                                                  locator<ValidatorService>()
                                                      .isEmpty,
                                              keyboardType: TextInputType.text,
                                              textInputAction:
                                                  TextInputAction.done,
                                              controller: _titleConController,
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontFamily: 'SFUIDisplay'),
                                              decoration: InputDecoration(
                                                border: OutlineInputBorder(),
                                                labelText: 'Title',
                                                prefixIcon:
                                                    Icon(Icons.speaker_notes),
                                                labelStyle:
                                                    TextStyle(fontSize: 15),
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.fromLTRB(
                                                20, 30, 20, 0),
                                            child: TextFormField(
                                              autovalidateMode: AutovalidateMode
                                                  .onUserInteraction,
                                              cursorColor: Colors.black,
                                              validator:
                                                  locator<ValidatorService>()
                                                      .isEmpty,
                                              keyboardType: TextInputType.text,
                                              textInputAction:
                                                  TextInputAction.done,
                                              controller: _authorConController,
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontFamily: 'SFUIDisplay'),
                                              decoration: InputDecoration(
                                                border: OutlineInputBorder(),
                                                labelText: 'Author',
                                                prefixIcon:
                                                    Icon(Icons.speaker_notes),
                                                labelStyle:
                                                    TextStyle(fontSize: 15),
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            height: 20,
                                          ),
                                          FullWidthButtonWidget(
                                            buttonColor: COLOR_NAVY,
                                            text: 'Add',
                                            textColor: Colors.white,
                                            onPressed: () async {
                                              final bool confirm =
                                                  await locator<ModalService>()
                                                      .showConfirmation(
                                                          context: context,
                                                          title: 'Add Book',
                                                          message:
                                                              'Are you sure?');

                                              if (!confirm) return;

                                              _myClassBloc.add(
                                                CreateBookForStudentEvent(
                                                  studentUID: student.uid,
                                                  title:
                                                      _titleConController.text,
                                                  author:
                                                      _authorConController.text,
                                                ),
                                              );
                                            },
                                          )
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                                ExpansionTile(
                                  backgroundColor: COLOR_YELLOW,
                                  title: Text(
                                    'Log a reading',
                                    style: TextStyle(
                                      color: Colors.white,
                                    ),
                                  ),
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.all(20),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            'x$numberOf15BooksRead',
                                            style: TextStyle(
                                              color: COLOR_ORANGE,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          SizedBox(width: 10),
                                          Image.asset(
                                              ASSET_p2k20_app_stamp_15_books_read,
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
                                                        fontWeight:
                                                            FontWeight.bold,
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
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Padding(
                                            padding: EdgeInsets.all(10),
                                            child: GFButton(
                                              color: COLOR_NAVY,
                                              onPressed: () {
                                                books.sort(
                                                  (a, b) => b.modified
                                                      .compareTo(a.modified),
                                                );
                                                setState(() {
                                                  student.bookSortBy = 'recent';
                                                });
                                              },
                                              text: "Recent",
                                              shape: GFButtonShape.pills,
                                              type:
                                                  student.bookSortBy == 'recent'
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
                                                  (a, b) => b.logCount
                                                      .compareTo(a.logCount),
                                                );
                                                setState(() {
                                                  student.bookSortBy =
                                                      'mostRead';
                                                });
                                              },
                                              text: "Most Read",
                                              shape: GFButtonShape.pills,
                                              type: student.bookSortBy ==
                                                      'mostRead'
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
                                                  (a, b) => a.logCount
                                                      .compareTo(b.logCount),
                                                );
                                                setState(() {
                                                  student.bookSortBy =
                                                      'leastRead';
                                                });
                                              },
                                              text: "Least Read",
                                              shape: GFButtonShape.pills,
                                              type: student.bookSortBy ==
                                                      'leastRead'
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
                                                  (a, b) => a.title
                                                      .compareTo(b.title),
                                                );
                                                setState(() {
                                                  student.bookSortBy =
                                                      'alphabet';
                                                });
                                              },
                                              text: 'Alphabet',
                                              shape: GFButtonShape.pills,
                                              type: student.bookSortBy ==
                                                      'alphabet'
                                                  ? null
                                                  : GFButtonType.outline2x,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Container(
                                      height: 400,
                                      child: ListView.builder(
                                        itemCount: books.length,
                                        itemBuilder:
                                            (BuildContext context, int index) {
                                          final BookModel book = books[index];

                                          return ExpansionTile(
                                            title: ListTile(
                                              leading: CircleAvatar(
                                                backgroundColor:
                                                    Colors.transparent,
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
                                                    backgroundImage: Image.asset(
                                                            '${book.assetImagePath}')
                                                        .image,
                                                  ),
                                                  SizedBox(
                                                    width: 15,
                                                  ),
                                                  Flexible(
                                                    child: Text(
                                                      '${book.title}',
                                                      style: TextStyle(
                                                        color: COLOR_NAVY,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                            children: [
                                              TableCalendar(
                                                calendarController:
                                                    _calendarController,
                                                events: book.logEvents,
                                                startingDayOfWeek:
                                                    StartingDayOfWeek.sunday,
                                                initialSelectedDay:
                                                    DateTime.now(),
                                                calendarStyle: CalendarStyle(
                                                  selectedColor:
                                                      Colors.deepOrange[400],
                                                  todayColor:
                                                      Colors.deepOrange[200],
                                                  markersColor: Colors.black,
                                                  outsideDaysVisible: false,
                                                ),
                                                headerStyle: HeaderStyle(
                                                  formatButtonTextStyle:
                                                      TextStyle().copyWith(
                                                          color: Colors.white,
                                                          fontSize: 15.0),
                                                  formatButtonDecoration:
                                                      BoxDecoration(
                                                    color:
                                                        Colors.deepOrange[400],
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8.0),
                                                  ),
                                                ),
                                                onDaySelected: (DateTime day,
                                                    List events) async {
                                                  final bool confirm =
                                                      await locator<
                                                              ModalService>()
                                                          .showConfirmation(
                                                              context: context,
                                                              title: 'Add Log',
                                                              message:
                                                                  '${DateFormat('MMMM dd, yyyy').format(day)} for \"${book.title}\"');

                                                  if (!confirm) return;

                                                  _myClassBloc.add(
                                                    CreateBookLogForStudentEvent(
                                                      studentUID: student.uid,
                                                      bookID: book.id,
                                                      date: day,
                                                    ),
                                                  );
                                                },
                                                onVisibleDaysChanged: (DateTime
                                                        first,
                                                    DateTime last,
                                                    CalendarFormat format) {},
                                              ),
                                              SizedBox(
                                                height: 20,
                                              ),
                                            ],
                                          );
                                        },
                                      ),
                                    )
                                  ],
                                ),
                                ExpansionTile(
                                  backgroundColor: COLOR_YELLOW,
                                  title: Text(
                                    'Log a visit',
                                    style: TextStyle(
                                      color: Colors.white,
                                    ),
                                  ),
                                  children: [
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Padding(
                                            padding: EdgeInsets.all(10),
                                            child: GFButton(
                                              color: COLOR_NAVY,
                                              onPressed: () {
                                                visits.sort(
                                                  (a, b) => b.modified
                                                      .compareTo(a.modified),
                                                );
                                                setState(() {
                                                  student.visitSortBy =
                                                      'recent';
                                                });
                                              },
                                              text: "Recent",
                                              shape: GFButtonShape.pills,
                                              type: student.visitSortBy ==
                                                      'recent'
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
                                                visits.sort(
                                                  (a, b) => b.logCount
                                                      .compareTo(a.logCount),
                                                );
                                                setState(() {
                                                  student.visitSortBy =
                                                      'mostVisit';
                                                });
                                              },
                                              text: "Most Visit",
                                              shape: GFButtonShape.pills,
                                              type: student.visitSortBy ==
                                                      'mostVisit'
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
                                                visits.sort(
                                                  (a, b) => a.logCount
                                                      .compareTo(b.logCount),
                                                );
                                                setState(() {
                                                  student.visitSortBy =
                                                      'leastVisit';
                                                });
                                              },
                                              text: "Least Visit",
                                              shape: GFButtonShape.pills,
                                              type: student.visitSortBy ==
                                                      'leastVisit'
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
                                                visits.sort(
                                                  (a, b) => a.title
                                                      .compareTo(b.title),
                                                );
                                                setState(() {
                                                  student.visitSortBy =
                                                      'alphabet';
                                                });
                                              },
                                              text: 'Alphabet',
                                              shape: GFButtonShape.pills,
                                              type: student.visitSortBy ==
                                                      'alphabet'
                                                  ? null
                                                  : GFButtonType.outline2x,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Container(
                                      height: 400,
                                      child: ListView.builder(
                                        itemCount: visits.length,
                                        itemBuilder:
                                            (BuildContext context, int index) {
                                          final VisitModel visit =
                                              visits[index];

                                          return ExpansionTile(
                                            leading: Image.asset(
                                              visit.assetImagePath,
                                            ),
                                            title: Text(
                                              '${visit.title} (${visit.logCount})',
                                            ),
                                            children: [
                                              Row(
                                                children: [
                                                  Expanded(
                                                    child: Padding(
                                                      padding:
                                                          EdgeInsets.all(20),
                                                      child: Column(
                                                        children: [
                                                          InkWell(
                                                            onTap: () async {
                                                              String url =
                                                                  visit.website;
                                                              if (await canLaunch(
                                                                  url)) {
                                                                await launch(
                                                                    url);
                                                              } else {
                                                                locator<ModalService>().showAlert(
                                                                    context:
                                                                        context,
                                                                    title:
                                                                        'Error',
                                                                    message:
                                                                        'Could not open url.');
                                                                //throw 'Could not launch $url';
                                                              }
                                                            },
                                                            child: Image.asset(
                                                              ASSET_website_icon,
                                                            ),
                                                          ),
                                                          Text(
                                                            'Website',
                                                            style: TextStyle(
                                                              color: COLOR_NAVY,
                                                              fontSize: 15,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                            ),
                                                          )
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                  Expanded(
                                                    child: Padding(
                                                      padding:
                                                          EdgeInsets.all(20),
                                                      child: Column(
                                                        children: [
                                                          InkWell(
                                                            onTap: () async {
                                                              await MapsLauncher
                                                                  .launchQuery(visit
                                                                      .address);
                                                            },
                                                            child: Image.asset(
                                                              ASSET_directions_icon,
                                                            ),
                                                          ),
                                                          Text(
                                                            'Directions',
                                                            style: TextStyle(
                                                              color: COLOR_NAVY,
                                                              fontSize: 15,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                            ),
                                                          )
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                  Expanded(
                                                    child: Padding(
                                                      padding:
                                                          EdgeInsets.all(20),
                                                      child: Column(
                                                        children: [
                                                          Image.asset(
                                                            ASSET_site_login_icon,
                                                          ),
                                                          Text(
                                                            'Log',
                                                            style: TextStyle(
                                                              color: COLOR_NAVY,
                                                              fontSize: 15,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                            ),
                                                          )
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              TableCalendar(
                                                calendarController:
                                                    _calendarController,
                                                events: visit.logEvents,
                                                startingDayOfWeek:
                                                    StartingDayOfWeek.sunday,
                                                initialSelectedDay:
                                                    DateTime.now(),
                                                calendarStyle: CalendarStyle(
                                                  selectedColor:
                                                      Colors.deepOrange[400],
                                                  todayColor:
                                                      Colors.deepOrange[200],
                                                  markersColor: Colors.black,
                                                  outsideDaysVisible: false,
                                                ),
                                                headerStyle: HeaderStyle(
                                                  formatButtonTextStyle:
                                                      TextStyle().copyWith(
                                                          color: Colors.white,
                                                          fontSize: 15.0),
                                                  formatButtonDecoration:
                                                      BoxDecoration(
                                                    color:
                                                        Colors.deepOrange[400],
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8.0),
                                                  ),
                                                ),
                                                onDaySelected: (DateTime day,
                                                    List events) async {
                                                  final bool confirm =
                                                      await locator<
                                                              ModalService>()
                                                          .showConfirmation(
                                                              context: context,
                                                              title: 'Add Log',
                                                              message:
                                                                  '${DateFormat('MMMM dd, yyyy').format(day)} for \"${visit.title}\"');

                                                  if (!confirm) return;

                                                  _myClassBloc.add(
                                                    CreateVisitLogForStudentEvent(
                                                      studentUID: student.uid,
                                                      visitID: visit.id,
                                                      date: day,
                                                    ),
                                                  );
                                                },
                                                onVisibleDaysChanged: (DateTime
                                                        first,
                                                    DateTime last,
                                                    CalendarFormat format) {},
                                              ),
                                              SizedBox(
                                                height: 20,
                                              ),
                                            ],
                                          );
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            );
                          },
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
          return Scaffold(
            backgroundColor: COLOR_CREAM,
            body: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(state.error.toString()),
              ],
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
  void clearAddTitleForm() {
    _titleConController.clear();
    _authorConController.clear();
  }
}
