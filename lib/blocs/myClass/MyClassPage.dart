import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:intl/intl.dart';
import 'package:maps_launcher/maps_launcher.dart';
import 'package:p/ServiceLocator.dart';
import 'package:p/constants.dart';
import 'package:p/models/BookModel.dart';
import 'package:p/models/ChildLogModel.dart';
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
          final List<BookModel> books = state.books;
          final DateTime selectedDateForBookLogs =
              state.selectedDateForBookLogs;
          final bool studentSelected = state.studentSelected;

          final List<VisitModel> selectedStudentVisits =
              state.selectedStudentVisits;

          final int boonshoftMuseumCount = selectedStudentVisits
              .where((visitLog) =>
                  visitLog.title == 'Boonshoft Museaum of Discovery')
              .toList()
              .length;

          final int daytonMetroCount = selectedStudentVisits
              .where((visitLog) => visitLog.title == 'Dayton Metro Library')
              .toList()
              .length;

          final int fiveRiversCount = selectedStudentVisits
              .where((visitLog) => visitLog.title == 'Five Rivers Metro Park')
              .toList()
              .length;

          final int daytonArtCount = selectedStudentVisits
              .where((visitLog) => visitLog.title == 'Dayton Art Institute')
              .toList()
              .length;

          int totalLogCount = 0;
          books.forEach((book) {
            totalLogCount += book.logCount;
          });

          final int remainingLogCount =
              totalLogCount % _totalBookProgressAmount;

          final int numberOf15BooksRead =
              totalLogCount ~/ _totalBookProgressAmount;

          Map<DateTime, List<ChildLogModel>> events = state.events;

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
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Type: Preschool',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: COLOR_NAVY),
                                      ),
                                      Text(
                                        'Passport Number: 2020-2021',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: COLOR_NAVY),
                                      )
                                    ],
                                  ),
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
                                Padding(
                                  padding: EdgeInsets.all(10),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Text(
                                        'ABC Child Development Center',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: COLOR_NAVY),
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                      Expanded(
                        child: ListView.builder(
                          itemCount: students.length,
                          itemBuilder: (BuildContext context, int index) {
                            final UserModel student = students[index];

                            return ExpansionTile(
                              onExpansionChanged: (bool open) {
                                _myClassBloc.add(
                                  StudentSelectedEvent(studentSelected: open),
                                );
                              },
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
                                        crossAxisCount: 4,
                                        itemCount: stamps.length,
                                        itemBuilder:
                                            (BuildContext context, int index) {
                                          return stamps[index];
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
                                              fontSize: 18,
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
                                  onExpansionChanged: (bool open) async {
                                    if (open) {
                                      _myClassBloc.add(
                                        GetBooksForStudentEvent(
                                            studentUID: student.uid),
                                      );
                                    } else {
                                      print('close');
                                    }
                                  },
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
                                    Container(
                                      height: 400,
                                      child: ListView.builder(
                                        itemCount: books.length,
                                        itemBuilder:
                                            (BuildContext context, int index) {
                                          final BookModel book = books[index];

                                          return ExpansionTile(
                                            onExpansionChanged: (bool open) {
                                              if (!open) {
                                                _myClassBloc.add(
                                                  SelectDateForBookEvent(
                                                    selectedDate: null,
                                                    studentUID: student.uid,
                                                    bookID: book.id,
                                                  ),
                                                );
                                              }
                                            },
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
                                                    backgroundImage: NetworkImage(
                                                        DUMMY_PROFILE_PHOTO_URL),
                                                  ),
                                                  SizedBox(
                                                    width: 15,
                                                  ),
                                                  Text(
                                                    '${book.title}',
                                                    style: TextStyle(
                                                      color: COLOR_NAVY,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  )
                                                ],
                                              ),
                                              onTap: () {},
                                            ),
                                            children: selectedDateForBookLogs !=
                                                    null
                                                ? [
                                                    TableCalendar(
                                                      calendarController:
                                                          _calendarController,
                                                      events: events,
                                                      startingDayOfWeek:
                                                          StartingDayOfWeek
                                                              .sunday,
                                                      initialSelectedDay:
                                                          selectedDateForBookLogs,
                                                      calendarStyle:
                                                          CalendarStyle(
                                                        selectedColor: Colors
                                                            .deepOrange[400],
                                                        todayColor: Colors
                                                            .deepOrange[200],
                                                        markersColor:
                                                            Colors.black,
                                                        outsideDaysVisible:
                                                            false,
                                                      ),
                                                      headerStyle: HeaderStyle(
                                                        formatButtonTextStyle:
                                                            TextStyle().copyWith(
                                                                color: Colors
                                                                    .white,
                                                                fontSize: 15.0),
                                                        formatButtonDecoration:
                                                            BoxDecoration(
                                                          color: Colors
                                                              .deepOrange[400],
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      8.0),
                                                        ),
                                                      ),
                                                      onDaySelected:
                                                          (DateTime day,
                                                              List events) {
                                                        // _readingLogLogsBloc.add(
                                                        //   READING_LOG_LOGS_BP
                                                        //       .OnDaySelectedEvent(
                                                        //           selectedDay:
                                                        //               day),
                                                        // );
                                                      },
                                                      onVisibleDaysChanged:
                                                          (DateTime first,
                                                              DateTime last,
                                                              CalendarFormat
                                                                  format) {},
                                                    ),
                                                    SizedBox(
                                                      height: 20,
                                                    ),
                                                    FullWidthButtonWidget(
                                                      buttonColor: COLOR_NAVY,
                                                      text:
                                                          'Add Log for ${DateFormat('MMMM dd, yyyy').format(DateTime.now())}',
                                                      textColor: Colors.white,
                                                      onPressed: () async {
                                                        final bool confirm = await locator<
                                                                ModalService>()
                                                            .showConfirmation(
                                                                context:
                                                                    context,
                                                                title:
                                                                    'Add Log for ${book.title}',
                                                                message:
                                                                    'Are you sure?');

                                                        if (!confirm) return;

                                                        _myClassBloc.add(
                                                          CreateLogForStudentEvent(
                                                            studentUID:
                                                                student.uid,
                                                            bookID: book.id,
                                                          ),
                                                        );
                                                      },
                                                    ),
                                                    SizedBox(
                                                      height: 20,
                                                    ),
                                                  ]
                                                : [
                                                    Container(
                                                      height: 50,
                                                      color: COLOR_YELLOW,
                                                      child: Center(
                                                        child: Text(
                                                          'Wow! You have read this book ${book.logCount} times!',
                                                          style: TextStyle(
                                                            color: Colors.white,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    Row(
                                                      children: [
                                                        Expanded(
                                                          child: Padding(
                                                            padding:
                                                                EdgeInsets.all(
                                                                    10),
                                                            child:
                                                                FullWidthButtonWidget(
                                                              textColor:
                                                                  Colors.white,
                                                              onPressed: () {
                                                                _myClassBloc
                                                                    .add(
                                                                  SelectDateForBookEvent(
                                                                    studentUID:
                                                                        student
                                                                            .uid,
                                                                    bookID:
                                                                        book.id,
                                                                    selectedDate:
                                                                        DateTime(
                                                                      2020,
                                                                      1,
                                                                    ),
                                                                  ),
                                                                );
                                                              },
                                                              buttonColor:
                                                                  COLOR_NAVY,
                                                              text: 'January',
                                                            ),
                                                          ),
                                                        ),
                                                        Expanded(
                                                          child: Padding(
                                                            padding:
                                                                EdgeInsets.all(
                                                                    10),
                                                            child:
                                                                FullWidthButtonWidget(
                                                              textColor:
                                                                  Colors.white,
                                                              onPressed: () {
                                                                _myClassBloc
                                                                    .add(
                                                                  SelectDateForBookEvent(
                                                                    studentUID:
                                                                        student
                                                                            .uid,
                                                                    bookID:
                                                                        book.id,
                                                                    selectedDate:
                                                                        DateTime(
                                                                      2020,
                                                                      2,
                                                                    ),
                                                                  ),
                                                                );
                                                              },
                                                              buttonColor:
                                                                  COLOR_NAVY,
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
                                                            padding:
                                                                EdgeInsets.all(
                                                                    10),
                                                            child:
                                                                FullWidthButtonWidget(
                                                              textColor:
                                                                  Colors.white,
                                                              onPressed: () {
                                                                _myClassBloc
                                                                    .add(
                                                                  SelectDateForBookEvent(
                                                                    studentUID:
                                                                        student
                                                                            .uid,
                                                                    bookID:
                                                                        book.id,
                                                                    selectedDate:
                                                                        DateTime(
                                                                      2020,
                                                                      3,
                                                                    ),
                                                                  ),
                                                                );
                                                              },
                                                              buttonColor:
                                                                  COLOR_NAVY,
                                                              text: 'March',
                                                            ),
                                                          ),
                                                        ),
                                                        Expanded(
                                                          child: Padding(
                                                            padding:
                                                                EdgeInsets.all(
                                                                    10),
                                                            child:
                                                                FullWidthButtonWidget(
                                                              textColor:
                                                                  Colors.white,
                                                              onPressed: () {
                                                                _myClassBloc
                                                                    .add(
                                                                  SelectDateForBookEvent(
                                                                    studentUID:
                                                                        student
                                                                            .uid,
                                                                    bookID:
                                                                        book.id,
                                                                    selectedDate:
                                                                        DateTime(
                                                                      2020,
                                                                      4,
                                                                    ),
                                                                  ),
                                                                );
                                                              },
                                                              buttonColor:
                                                                  COLOR_NAVY,
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
                                                            padding:
                                                                EdgeInsets.all(
                                                                    10),
                                                            child:
                                                                FullWidthButtonWidget(
                                                              textColor:
                                                                  Colors.white,
                                                              onPressed: () {
                                                                _myClassBloc
                                                                    .add(
                                                                  SelectDateForBookEvent(
                                                                    studentUID:
                                                                        student
                                                                            .uid,
                                                                    bookID:
                                                                        book.id,
                                                                    selectedDate:
                                                                        DateTime(
                                                                      2020,
                                                                      5,
                                                                    ),
                                                                  ),
                                                                );
                                                              },
                                                              buttonColor:
                                                                  COLOR_NAVY,
                                                              text: 'May',
                                                            ),
                                                          ),
                                                        ),
                                                        Expanded(
                                                          child: Padding(
                                                            padding:
                                                                EdgeInsets.all(
                                                                    10),
                                                            child:
                                                                FullWidthButtonWidget(
                                                              textColor:
                                                                  Colors.white,
                                                              onPressed: () {
                                                                _myClassBloc
                                                                    .add(
                                                                  SelectDateForBookEvent(
                                                                    studentUID:
                                                                        student
                                                                            .uid,
                                                                    bookID:
                                                                        book.id,
                                                                    selectedDate:
                                                                        DateTime(
                                                                      2020,
                                                                      6,
                                                                    ),
                                                                  ),
                                                                );
                                                              },
                                                              buttonColor:
                                                                  COLOR_NAVY,
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
                                                            padding:
                                                                EdgeInsets.all(
                                                                    10),
                                                            child:
                                                                FullWidthButtonWidget(
                                                              textColor:
                                                                  Colors.white,
                                                              onPressed: () {
                                                                _myClassBloc
                                                                    .add(
                                                                  SelectDateForBookEvent(
                                                                    studentUID:
                                                                        student
                                                                            .uid,
                                                                    bookID:
                                                                        book.id,
                                                                    selectedDate:
                                                                        DateTime(
                                                                      2020,
                                                                      7,
                                                                    ),
                                                                  ),
                                                                );
                                                              },
                                                              buttonColor:
                                                                  COLOR_NAVY,
                                                              text: 'July',
                                                            ),
                                                          ),
                                                        ),
                                                        Expanded(
                                                          child: Padding(
                                                            padding:
                                                                EdgeInsets.all(
                                                                    10),
                                                            child:
                                                                FullWidthButtonWidget(
                                                              textColor:
                                                                  Colors.white,
                                                              onPressed: () {
                                                                _myClassBloc
                                                                    .add(
                                                                  SelectDateForBookEvent(
                                                                    studentUID:
                                                                        student
                                                                            .uid,
                                                                    bookID:
                                                                        book.id,
                                                                    selectedDate:
                                                                        DateTime(
                                                                            2020,
                                                                            8),
                                                                  ),
                                                                );
                                                              },
                                                              buttonColor:
                                                                  COLOR_NAVY,
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
                                                            padding:
                                                                EdgeInsets.all(
                                                                    10),
                                                            child:
                                                                FullWidthButtonWidget(
                                                              textColor:
                                                                  Colors.white,
                                                              onPressed: () {
                                                                _myClassBloc
                                                                    .add(
                                                                  SelectDateForBookEvent(
                                                                    studentUID:
                                                                        student
                                                                            .uid,
                                                                    bookID:
                                                                        book.id,
                                                                    selectedDate:
                                                                        DateTime(
                                                                            2020,
                                                                            9),
                                                                  ),
                                                                );
                                                              },
                                                              buttonColor:
                                                                  COLOR_NAVY,
                                                              text: 'September',
                                                            ),
                                                          ),
                                                        ),
                                                        Expanded(
                                                          child: Padding(
                                                            padding:
                                                                EdgeInsets.all(
                                                                    10),
                                                            child:
                                                                FullWidthButtonWidget(
                                                              textColor:
                                                                  Colors.white,
                                                              onPressed: () {
                                                                _myClassBloc
                                                                    .add(
                                                                  SelectDateForBookEvent(
                                                                    studentUID:
                                                                        student
                                                                            .uid,
                                                                    bookID:
                                                                        book.id,
                                                                    selectedDate:
                                                                        DateTime(
                                                                            2020,
                                                                            10),
                                                                  ),
                                                                );
                                                              },
                                                              buttonColor:
                                                                  COLOR_NAVY,
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
                                                            padding:
                                                                EdgeInsets.all(
                                                                    10),
                                                            child:
                                                                FullWidthButtonWidget(
                                                              textColor:
                                                                  Colors.white,
                                                              onPressed: () {
                                                                _myClassBloc
                                                                    .add(
                                                                  SelectDateForBookEvent(
                                                                    studentUID:
                                                                        student
                                                                            .uid,
                                                                    bookID:
                                                                        book.id,
                                                                    selectedDate:
                                                                        DateTime(
                                                                            2020,
                                                                            11),
                                                                  ),
                                                                );
                                                              },
                                                              buttonColor:
                                                                  COLOR_NAVY,
                                                              text: 'November',
                                                            ),
                                                          ),
                                                        ),
                                                        Expanded(
                                                          child: Padding(
                                                            padding:
                                                                EdgeInsets.all(
                                                                    10),
                                                            child:
                                                                FullWidthButtonWidget(
                                                              textColor:
                                                                  Colors.white,
                                                              onPressed: () {
                                                                _myClassBloc
                                                                    .add(
                                                                  SelectDateForBookEvent(
                                                                    studentUID:
                                                                        student
                                                                            .uid,
                                                                    bookID:
                                                                        book.id,
                                                                    selectedDate:
                                                                        DateTime(
                                                                            2020,
                                                                            12),
                                                                  ),
                                                                );
                                                              },
                                                              buttonColor:
                                                                  COLOR_NAVY,
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
                                    Padding(
                                      padding: EdgeInsets.all(10),
                                      child: ExpansionTile(
                                        leading: Image.asset(
                                          ASSET_boonshoft_logo,
                                        ),
                                        title: Text(
                                            'Boonshoft Museum of Discovery ($boonshoftMuseumCount)'),
                                        children: [
                                          Row(
                                            children: [
                                              Expanded(
                                                child: Padding(
                                                  padding: EdgeInsets.all(20),
                                                  child: Column(
                                                    children: [
                                                      InkWell(
                                                        onTap: () async {
                                                          const url =
                                                              'https://www.boonshoftmuseum.org/';
                                                          if (await canLaunch(
                                                              url)) {
                                                            await launch(url);
                                                          } else {
                                                            locator<ModalService>()
                                                                .showAlert(
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
                                                          fontSize: 18,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              Expanded(
                                                child: Padding(
                                                  padding: EdgeInsets.all(20),
                                                  child: Column(
                                                    children: [
                                                      InkWell(
                                                        onTap: () async {
                                                          await MapsLauncher
                                                              .launchQuery(
                                                                  '2600 DeWeese Pkwy, Dayton, OH 45414, USA');
                                                        },
                                                        child: Image.asset(
                                                          ASSET_directions_icon,
                                                        ),
                                                      ),
                                                      Text(
                                                        'Directions',
                                                        style: TextStyle(
                                                          color: COLOR_NAVY,
                                                          fontSize: 18,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              Expanded(
                                                child: Padding(
                                                  padding: EdgeInsets.all(20),
                                                  child: Column(
                                                    children: [
                                                      Image.asset(
                                                        ASSET_site_login_icon,
                                                      ),
                                                      Text(
                                                        'Log',
                                                        style: TextStyle(
                                                          color: COLOR_NAVY,
                                                          fontSize: 18,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              ),
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
                                                      // _goToLogsForThisVisit(
                                                      //   title:
                                                      //       'Boonshoft Museum of Discovery',
                                                      //   initialSelectedDay:
                                                      //       DateTime(
                                                      //           2020, 1),
                                                      // );
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
                                                      // _goToLogsForThisVisit(
                                                      //   title:
                                                      //       'Boonshoft Museum of Discovery',
                                                      //   initialSelectedDay:
                                                      //       DateTime(
                                                      //           2020, 2),
                                                      // );
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
                                                      // _goToLogsForThisVisit(
                                                      //   title:
                                                      //       'Boonshoft Museum of Discovery',
                                                      //   initialSelectedDay:
                                                      //       DateTime(
                                                      //           2020, 3),
                                                      // );
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
                                                      // _goToLogsForThisVisit(
                                                      //   title:
                                                      //       'Boonshoft Museum of Discovery',
                                                      //   initialSelectedDay:
                                                      //       DateTime(
                                                      //           2020, 4),
                                                      // );
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
                                                      // _goToLogsForThisVisit(
                                                      //   title:
                                                      //       'Boonshoft Museum of Discovery',
                                                      //   initialSelectedDay:
                                                      //       DateTime(
                                                      //           2020, 5),
                                                      // );
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
                                                      // _goToLogsForThisVisit(
                                                      //   title:
                                                      //       'Boonshoft Museum of Discovery',
                                                      //   initialSelectedDay:
                                                      //       DateTime(
                                                      //           2020, 6),
                                                      // );
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
                                                      // _goToLogsForThisVisit(
                                                      //   title:
                                                      //       'Boonshoft Museum of Discovery',
                                                      //   initialSelectedDay:
                                                      //       DateTime(
                                                      //           2020, 7),
                                                      // );
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
                                                      // _goToLogsForThisVisit(
                                                      //   title:
                                                      //       'Boonshoft Museum of Discovery',
                                                      //   initialSelectedDay:
                                                      //       DateTime(
                                                      //           2020, 8),
                                                      // );
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
                                                      // _goToLogsForThisVisit(
                                                      //   title:
                                                      //       'Boonshoft Museum of Discovery',
                                                      //   initialSelectedDay:
                                                      //       DateTime(
                                                      //           2020, 9),
                                                      // );
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
                                                      // _goToLogsForThisVisit(
                                                      //   title:
                                                      //       'Boonshoft Museum of Discovery',
                                                      //   initialSelectedDay:
                                                      //       DateTime(
                                                      //           2020, 10),
                                                      // );
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
                                                      // _goToLogsForThisVisit(
                                                      //   title:
                                                      //       'Boonshoft Museum of Discovery',
                                                      //   initialSelectedDay:
                                                      //       DateTime(
                                                      //           2020, 11),
                                                      // );
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
                                                      // _goToLogsForThisVisit(
                                                      //   title:
                                                      //       'Boonshoft Museum of Discovery',
                                                      //   initialSelectedDay:
                                                      //       DateTime(
                                                      //     2020,
                                                      //     12,
                                                      //   ),
                                                      // );
                                                    },
                                                    buttonColor: COLOR_NAVY,
                                                    text: 'December',
                                                  ),
                                                ),
                                              )
                                            ],
                                          )
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.all(10),
                                      child: ExpansionTile(
                                        leading: Image.asset(
                                          ASSET_dayton_metro_library_logo,
                                        ),
                                        title: Text(
                                            'Dayton Metro Library ($daytonMetroCount)'),
                                        children: [
                                          Row(
                                            children: [
                                              Expanded(
                                                child: Padding(
                                                  padding: EdgeInsets.all(20),
                                                  child: Column(
                                                    children: [
                                                      InkWell(
                                                        onTap: () async {
                                                          const url =
                                                              'http://www.daytonmetrolibrary.org/';
                                                          if (await canLaunch(
                                                              url)) {
                                                            await launch(url);
                                                          } else {
                                                            locator<ModalService>()
                                                                .showAlert(
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
                                                          fontSize: 18,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              Expanded(
                                                child: Padding(
                                                  padding: EdgeInsets.all(20),
                                                  child: Column(
                                                    children: [
                                                      InkWell(
                                                        onTap: () async {
                                                          await MapsLauncher
                                                              .launchQuery(
                                                                  '215 E. Third St., Dayton, OH 45402, USA');
                                                        },
                                                        child: Image.asset(
                                                          ASSET_directions_icon,
                                                        ),
                                                      ),
                                                      Text(
                                                        'Directions',
                                                        style: TextStyle(
                                                          color: COLOR_NAVY,
                                                          fontSize: 18,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              Expanded(
                                                child: Padding(
                                                  padding: EdgeInsets.all(20),
                                                  child: Column(
                                                    children: [
                                                      Image.asset(
                                                        ASSET_site_login_icon,
                                                      ),
                                                      Text(
                                                        'Log',
                                                        style: TextStyle(
                                                          color: COLOR_NAVY,
                                                          fontSize: 18,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              ),
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
                                                      // _goToLogsForThisVisit(
                                                      //   title:
                                                      //       'Dayton Metro Library',
                                                      //   initialSelectedDay:
                                                      //       DateTime(
                                                      //           2020, 1),
                                                      // );
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
                                                      // _goToLogsForThisVisit(
                                                      //   title:
                                                      //       'Dayton Metro Library',
                                                      //   initialSelectedDay:
                                                      //       DateTime(
                                                      //           2020, 1),
                                                      // );
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
                                                      // _goToLogsForThisVisit(
                                                      //   title:
                                                      //       'Dayton Metro Library',
                                                      //   initialSelectedDay:
                                                      //       DateTime(
                                                      //           2020, 3),
                                                      // );
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
                                                      // _goToLogsForThisVisit(
                                                      //   title:
                                                      //       'Dayton Metro Library',
                                                      //   initialSelectedDay:
                                                      //       DateTime(
                                                      //           2020, 4),
                                                      // );
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
                                                      // _goToLogsForThisVisit(
                                                      //   title:
                                                      //       'Dayton Metro Library',
                                                      //   initialSelectedDay:
                                                      //       DateTime(
                                                      //           2020, 5),
                                                      // );
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
                                                      // _goToLogsForThisVisit(
                                                      //   title:
                                                      //       'Dayton Metro Library',
                                                      //   initialSelectedDay:
                                                      //       DateTime(
                                                      //           2020, 6),
                                                      // );
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
                                                      // _goToLogsForThisVisit(
                                                      //   title:
                                                      //       'Dayton Metro Library',
                                                      //   initialSelectedDay:
                                                      //       DateTime(
                                                      //           2020, 7),
                                                      // );
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
                                                      // _goToLogsForThisVisit(
                                                      //   title:
                                                      //       'Dayton Metro Library',
                                                      //   initialSelectedDay:
                                                      //       DateTime(
                                                      //           2020, 8),
                                                      // );
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
                                                      // _goToLogsForThisVisit(
                                                      //   title:
                                                      //       'Dayton Metro Library',
                                                      //   initialSelectedDay:
                                                      //       DateTime(
                                                      //           2020, 9),
                                                      // );
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
                                                      // _goToLogsForThisVisit(
                                                      //   title:
                                                      //       'Dayton Metro Library',
                                                      //   initialSelectedDay:
                                                      //       DateTime(
                                                      //           2020, 10),
                                                      // );
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
                                                      // _goToLogsForThisVisit(
                                                      //   title:
                                                      //       'Dayton Metro Library',
                                                      //   initialSelectedDay:
                                                      //       DateTime(
                                                      //           2020, 11),
                                                      // );
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
                                                      // _goToLogsForThisVisit(
                                                      //   title:
                                                      //       'Dayton Metro Library',
                                                      //   initialSelectedDay:
                                                      //       DateTime(
                                                      //           2020, 12),
                                                      // );
                                                    },
                                                    buttonColor: COLOR_NAVY,
                                                    text: 'December',
                                                  ),
                                                ),
                                              )
                                            ],
                                          )
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.all(10),
                                      child: ExpansionTile(
                                        leading: Image.asset(
                                          ASSET_five_rivers_metroparks_logo,
                                        ),
                                        title: Text(
                                            'Five Rivers Metro Park ($fiveRiversCount)'),
                                        children: [
                                          Row(
                                            children: [
                                              Expanded(
                                                child: Padding(
                                                  padding: EdgeInsets.all(20),
                                                  child: Column(
                                                    children: [
                                                      InkWell(
                                                        onTap: () async {
                                                          const url =
                                                              'https://www.metroparks.org/contact/';
                                                          if (await canLaunch(
                                                              url)) {
                                                            await launch(url);
                                                          } else {
                                                            locator<ModalService>()
                                                                .showAlert(
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
                                                          fontSize: 18,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              Expanded(
                                                child: Padding(
                                                  padding: EdgeInsets.all(20),
                                                  child: Column(
                                                    children: [
                                                      InkWell(
                                                        onTap: () async {
                                                          await MapsLauncher
                                                              .launchQuery(
                                                                  '409 E. Monument Ave., Dayton, OH 45402, USA');
                                                        },
                                                        child: Image.asset(
                                                          ASSET_directions_icon,
                                                        ),
                                                      ),
                                                      Text(
                                                        'Directions',
                                                        style: TextStyle(
                                                          color: COLOR_NAVY,
                                                          fontSize: 18,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              Expanded(
                                                child: Padding(
                                                  padding: EdgeInsets.all(20),
                                                  child: Column(
                                                    children: [
                                                      Image.asset(
                                                        ASSET_site_login_icon,
                                                      ),
                                                      Text(
                                                        'Log',
                                                        style: TextStyle(
                                                          color: COLOR_NAVY,
                                                          fontSize: 18,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              ),
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
                                                      // _goToLogsForThisVisit(
                                                      //   title:
                                                      //       'Fiver Rivers Metro Park',
                                                      //   initialSelectedDay:
                                                      //       DateTime(
                                                      //     2020,
                                                      //     1,
                                                      //   ),
                                                      // );
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
                                                      // _goToLogsForThisVisit(
                                                      //   title:
                                                      //       'Fiver Rivers Metro Park',
                                                      //   initialSelectedDay:
                                                      //       DateTime(
                                                      //     2020,
                                                      //     2,
                                                      //   ),
                                                      // );
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
                                                      // _goToLogsForThisVisit(
                                                      //   title:
                                                      //       'Fiver Rivers Metro Park',
                                                      //   initialSelectedDay:
                                                      //       DateTime(
                                                      //     2020,
                                                      //     3,
                                                      //   ),
                                                      // );
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
                                                      // _goToLogsForThisVisit(
                                                      //   title:
                                                      //       'Fiver Rivers Metro Park',
                                                      //   initialSelectedDay:
                                                      //       DateTime(
                                                      //     2020,
                                                      //     4,
                                                      //   ),
                                                      // );
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
                                                      // _goToLogsForThisVisit(
                                                      //   title:
                                                      //       'Fiver Rivers Metro Park',
                                                      //   initialSelectedDay:
                                                      //       DateTime(
                                                      //     2020,
                                                      //     5,
                                                      //   ),
                                                      // );
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
                                                      // _goToLogsForThisVisit(
                                                      //   title:
                                                      //       'Fiver Rivers Metro Park',
                                                      //   initialSelectedDay:
                                                      //       DateTime(
                                                      //     2020,
                                                      //     6,
                                                      //   ),
                                                      // );
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
                                                      // _goToLogsForThisVisit(
                                                      //   title:
                                                      //       'Fiver Rivers Metro Park',
                                                      //   initialSelectedDay:
                                                      //       DateTime(
                                                      //           2020, 7),
                                                      // );
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
                                                      // _goToLogsForThisVisit(
                                                      //   title:
                                                      //       'Fiver Rivers Metro Park',
                                                      //   initialSelectedDay:
                                                      //       DateTime(
                                                      //     2020,
                                                      //     8,
                                                      //   ),
                                                      // );
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
                                                      // _goToLogsForThisVisit(
                                                      //   title:
                                                      //       'Fiver Rivers Metro Park',
                                                      //   initialSelectedDay:
                                                      //       DateTime(
                                                      //     2020,
                                                      //     9,
                                                      //   ),
                                                      // );
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
                                                      // _goToLogsForThisVisit(
                                                      //   title:
                                                      //       'Fiver Rivers Metro Park',
                                                      //   initialSelectedDay:
                                                      //       DateTime(
                                                      //     2020,
                                                      //     10,
                                                      //   ),
                                                      // );
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
                                                      // _goToLogsForThisVisit(
                                                      //   title:
                                                      //       'Fiver Rivers Metro Park',
                                                      //   initialSelectedDay:
                                                      //       DateTime(
                                                      //     2020,
                                                      //     11,
                                                      //   ),
                                                      // );
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
                                                      // _goToLogsForThisVisit(
                                                      //   title:
                                                      //       'Fiver Rivers Metro Park',
                                                      //   initialSelectedDay:
                                                      //       DateTime(
                                                      //     2020,
                                                      //     12,
                                                      //   ),
                                                      // );
                                                    },
                                                    buttonColor: COLOR_NAVY,
                                                    text: 'December',
                                                  ),
                                                ),
                                              )
                                            ],
                                          )
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.all(10),
                                      child: ExpansionTile(
                                        leading: Image.asset(
                                          ASSET_dayton_art_institute_logo,
                                        ),
                                        title: Text(
                                            'Dayton Art Institute ($daytonArtCount)'),
                                        children: [
                                          Row(
                                            children: [
                                              Expanded(
                                                child: Padding(
                                                  padding: EdgeInsets.all(20),
                                                  child: Column(
                                                    children: [
                                                      InkWell(
                                                        onTap: () async {
                                                          const url =
                                                              'https://www.daytonartinstitute.org/';
                                                          if (await canLaunch(
                                                              url)) {
                                                            await launch(url);
                                                          } else {
                                                            locator<ModalService>()
                                                                .showAlert(
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
                                                          fontSize: 18,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              Expanded(
                                                child: Padding(
                                                  padding: EdgeInsets.all(20),
                                                  child: Column(
                                                    children: [
                                                      InkWell(
                                                        onTap: () async {
                                                          await MapsLauncher
                                                              .launchQuery(
                                                                  '456 Belmonte Park N, Dayton, OH 45405, USA');
                                                        },
                                                        child: Image.asset(
                                                          ASSET_directions_icon,
                                                        ),
                                                      ),
                                                      Text(
                                                        'Directions',
                                                        style: TextStyle(
                                                          color: COLOR_NAVY,
                                                          fontSize: 18,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              Expanded(
                                                child: Padding(
                                                  padding: EdgeInsets.all(20),
                                                  child: Column(
                                                    children: [
                                                      Image.asset(
                                                        ASSET_site_login_icon,
                                                      ),
                                                      Text(
                                                        'Log',
                                                        style: TextStyle(
                                                          color: COLOR_NAVY,
                                                          fontSize: 18,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              ),
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
                                                      // _goToLogsForThisVisit(
                                                      //   title:
                                                      //       'Dayton Art Institute',
                                                      //   initialSelectedDay:
                                                      //       DateTime(
                                                      //     2020,
                                                      //     1,
                                                      //   ),
                                                      // );
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
                                                      // _goToLogsForThisVisit(
                                                      //   title:
                                                      //       'Dayton Art Institute',
                                                      //   initialSelectedDay:
                                                      //       DateTime(
                                                      //     2020,
                                                      //     2,
                                                      //   ),
                                                      // );
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
                                                      // _goToLogsForThisVisit(
                                                      //   title:
                                                      //       'Dayton Art Institute',
                                                      //   initialSelectedDay:
                                                      //       DateTime(
                                                      //     2020,
                                                      //     3,
                                                      //   ),
                                                      // );
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
                                                      // _goToLogsForThisVisit(
                                                      //   title:
                                                      //       'Dayton Art Institute',
                                                      //   initialSelectedDay:
                                                      //       DateTime(
                                                      //     2020,
                                                      //     4,
                                                      //   ),
                                                      // );
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
                                                      // _goToLogsForThisVisit(
                                                      //   title:
                                                      //       'Dayton Art Institute',
                                                      //   initialSelectedDay:
                                                      //       DateTime(
                                                      //     2020,
                                                      //     5,
                                                      //   ),
                                                      // );
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
                                                      // _goToLogsForThisVisit(
                                                      //   title:
                                                      //       'Dayton Art Institute',
                                                      //   initialSelectedDay:
                                                      //       DateTime(
                                                      //     2020,
                                                      //     6,
                                                      //   ),
                                                      // );
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
                                                      // _goToLogsForThisVisit(
                                                      //   title:
                                                      //       'Dayton Art Institute',
                                                      //   initialSelectedDay:
                                                      //       DateTime(
                                                      //     2020,
                                                      //     7,
                                                      //   ),
                                                      // );
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
                                                      // _goToLogsForThisVisit(
                                                      //   title:
                                                      //       'Dayton Art Institute',
                                                      //   initialSelectedDay:
                                                      //       DateTime(
                                                      //     2020,
                                                      //     8,
                                                      //   ),
                                                      // );
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
                                                      // _goToLogsForThisVisit(
                                                      //   title:
                                                      //       'Dayton Art Institute',
                                                      //   initialSelectedDay:
                                                      //       DateTime(
                                                      //     2020,
                                                      //     9,
                                                      //   ),
                                                      // );
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
                                                      // _goToLogsForThisVisit(
                                                      //   title:
                                                      //       'Dayton Art Institute',
                                                      //   initialSelectedDay:
                                                      //       DateTime(
                                                      //     2020,
                                                      //     10,
                                                      //   ),
                                                      // );
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
                                                      // _goToLogsForThisVisit(
                                                      //   title:
                                                      //       'Dayton Art Institute',
                                                      //   initialSelectedDay:
                                                      //       DateTime(
                                                      //     2020,
                                                      //     11,
                                                      //   ),
                                                      // );
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
                                                      // _goToLogsForThisVisit(
                                                      //  title:
                                                      //       'Dayton Art Institute',
                                                      //   initialSelectedDay:
                                                      //       DateTime(
                                                      //     2020,
                                                      //     12,
                                                      //   ),
                                                      // );
                                                    },
                                                    buttonColor: COLOR_NAVY,
                                                    text: 'December',
                                                  ),
                                                ),
                                              )
                                            ],
                                          )
                                        ],
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
