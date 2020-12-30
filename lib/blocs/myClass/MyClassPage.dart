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
import 'package:p/models/EntryModel.dart';
import 'package:p/models/StampModel.dart';
import 'package:p/models/UserModel.dart';
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
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

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
            floatingActionButton: FloatingActionButton(
              backgroundColor: COLOR_NAVY,
              child: Icon(Icons.note),
              onPressed: () async {
                final bool confirm =
                    await locator<ModalService>().showConfirmation(
                  context: context,
                  title: 'Generate Report?',
                  message:
                      'This will list all books, visits, and stamps for each student in your class.',
                );

                if (!confirm) return;

                _myClassBloc.add(GenerateReportEvent());
              },
            ),
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
                                      fontSize: 18,
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
                      ListView.builder(
                        shrinkWrap: true,
                        physics: ClampingScrollPhysics(),
                        itemCount: students.length,
                        itemBuilder: (BuildContext context, int index) {
                          final UserModel student = students[index];

                          final List<StampModel> stamps = student.stamps;
                          final List<EntryModel> bookEntries =
                              student.bookEntries;
                          final List<EntryModel> visitEntries =
                              student.visitEntries;

                          int totalLogCount = 0;
                          student.bookEntries.forEach((bookEntry) {
                            totalLogCount += bookEntry.logCount;
                          });

                          final int currentLogCount =
                              totalLogCount % _totalBookProgressAmount;

                          final int numberOf15BooksRead =
                              totalLogCount ~/ _totalBookProgressAmount;

                          return ExpansionTile(
                            backgroundColor: Colors.white,
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
                                    color: COLOR_NAVY,
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
                                        final StampModel stamp = stamps[index];
                                        return Image.network(
                                          stamp.imgUrl,
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
                                backgroundColor: Colors.white,
                                title: Text(
                                  'Add a new title',
                                  style: TextStyle(
                                    color: COLOR_NAVY,
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
                                        Form(
                                          key: _formKey,
                                          child: Column(
                                            children: [
                                              Padding(
                                                padding: EdgeInsets.fromLTRB(
                                                    20, 30, 20, 0),
                                                child: TextFormField(
                                                  autovalidateMode:
                                                      AutovalidateMode
                                                          .onUserInteraction,
                                                  cursorColor: Colors.black,
                                                  validator: locator<
                                                          ValidatorService>()
                                                      .isEmpty,
                                                  keyboardType:
                                                      TextInputType.text,
                                                  textInputAction:
                                                      TextInputAction.done,
                                                  controller:
                                                      _titleConController,
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontFamily:
                                                          'SFUIDisplay'),
                                                  decoration: InputDecoration(
                                                    border:
                                                        OutlineInputBorder(),
                                                    labelText: 'Title',
                                                    prefixIcon: Icon(
                                                        Icons.speaker_notes),
                                                    labelStyle:
                                                        TextStyle(fontSize: 15),
                                                  ),
                                                ),
                                              ),
                                              Padding(
                                                padding: EdgeInsets.fromLTRB(
                                                    20, 30, 20, 0),
                                                child: TextFormField(
                                                  autovalidateMode:
                                                      AutovalidateMode
                                                          .onUserInteraction,
                                                  cursorColor: Colors.black,
                                                  validator: locator<
                                                          ValidatorService>()
                                                      .isEmpty,
                                                  keyboardType:
                                                      TextInputType.text,
                                                  textInputAction:
                                                      TextInputAction.done,
                                                  controller:
                                                      _authorConController,
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontFamily:
                                                          'SFUIDisplay'),
                                                  decoration: InputDecoration(
                                                    border:
                                                        OutlineInputBorder(),
                                                    labelText: 'Author',
                                                    prefixIcon: Icon(
                                                        Icons.speaker_notes),
                                                    labelStyle:
                                                        TextStyle(fontSize: 15),
                                                  ),
                                                ),
                                              ),
                                            ],
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
                                                title: _titleConController.text,
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
                                backgroundColor: Colors.white,
                                title: Text(
                                  'Log a reading',
                                  style: TextStyle(
                                    color: COLOR_NAVY,
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
                                        Image.network('$STAMP_15_BOOKS_READ',
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
                                                      fontWeight:
                                                          FontWeight.bold,
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
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Padding(
                                          padding: EdgeInsets.all(10),
                                          child: GFButton(
                                            color: COLOR_NAVY,
                                            onPressed: () {
                                              bookEntries.sort(
                                                (a, b) => b.modified
                                                    .compareTo(a.modified),
                                              );
                                              setState(() {
                                                student.bookSortBy = 'recent';
                                              });
                                            },
                                            text: "Recent",
                                            shape: GFButtonShape.pills,
                                            type: student.bookSortBy == 'recent'
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
                                              bookEntries.sort(
                                                (a, b) => b.logCount
                                                    .compareTo(a.logCount),
                                              );
                                              setState(() {
                                                student.bookSortBy = 'mostRead';
                                              });
                                            },
                                            text: "Most Read",
                                            shape: GFButtonShape.pills,
                                            type:
                                                student.bookSortBy == 'mostRead'
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
                                              bookEntries.sort(
                                                (a, b) => a.book.title
                                                    .compareTo(b.book.title),
                                              );
                                              setState(() {
                                                student.bookSortBy = 'alphabet';
                                              });
                                            },
                                            text: 'A-Z',
                                            shape: GFButtonShape.pills,
                                            type:
                                                student.bookSortBy == 'alphabet'
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
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      final EntryModel bookEntry =
                                          bookEntries[index];

                                      return ExpansionTile(
                                        key: GlobalKey(),
                                        title: ListTile(
                                          leading: CircleAvatar(
                                            backgroundColor: Colors.transparent,
                                            child: Text(
                                              '${bookEntry.logCount}',
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
                                                backgroundImage: Image.network(
                                                        '${bookEntry.book.imgUrl == null ? DUMMY_PROFILE_PHOTO_URL : bookEntry.book.imgUrl}' ,
                                                        ) 
                                                    .image,
                                              ),
                                              SizedBox(
                                                width: 15,
                                              ),
                                              Flexible(
                                                child: Text(
                                                  '${bookEntry.book.title}',
                                                  style: TextStyle(
                                                    color: COLOR_NAVY,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                        children: [
                                          TableCalendar(
                                            availableCalendarFormats: const {
                                              CalendarFormat.month: 'Month'
                                            },
                                            calendarController:
                                                _calendarController,
                                            events: bookEntry.logEvents,
                                            startingDayOfWeek:
                                                StartingDayOfWeek.sunday,
                                            initialSelectedDay: DateTime.now(),
                                            calendarStyle: CalendarStyle(
                                              selectedColor:
                                                  Colors.deepOrange[400],
                                              todayColor:
                                                  Colors.deepOrange[200],
                                              markersColor: Colors.black,
                                              outsideDaysVisible: false,
                                            ),
                                            builders: CalendarBuilders(
                                              markersBuilder: (context, date,
                                                  events, holidays) {
                                                final children = <Widget>[];

                                                if (events.isNotEmpty) {
                                                  children.add(
                                                    Center(
                                                      child: Stack(
                                                        children: [
                                                          Container(
                                                              height: 50,
                                                              width: 50),
                                                          Positioned(
                                                            bottom: 0,
                                                            right: 0,
                                                            child: CircleAvatar(
                                                              backgroundColor:
                                                                  COLOR_NAVY,
                                                              child: Text(
                                                                '${events.length}',
                                                                style:
                                                                    TextStyle(
                                                                  fontSize: 10,
                                                                  color: Colors
                                                                      .white,
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
                                              formatButtonTextStyle: TextStyle()
                                                  .copyWith(
                                                      color: Colors.white,
                                                      fontSize: 15.0),
                                              formatButtonDecoration:
                                                  BoxDecoration(
                                                color: Colors.deepOrange[400],
                                                borderRadius:
                                                    BorderRadius.circular(8.0),
                                              ),
                                            ),
                                            onDaySelected: (DateTime day,
                                                List events) async {
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
                                                          '${DateFormat('MMMM dd, yyyy').format(day)} for \"${bookEntry.book.title}\"');

                                              if (!confirm) return;

                                              bool totalLogLimitReached =
                                                  currentLogCount + 1 ==
                                                      _totalBookProgressAmount;

                                              _myClassBloc.add(
                                                CreateBookLogForStudentEvent(
                                                  studentUID: student.uid,
                                                  idOfEntry: bookEntry.id,
                                                  date: day,
                                                  totalLogLimitReached:
                                                      totalLogLimitReached,
                                                ),
                                              );
                                            },
                                            onVisibleDaysChanged:
                                                (DateTime first, DateTime last,
                                                    CalendarFormat format) {},
                                          ),
                                          SizedBox(
                                            height: 20,
                                          ),
                                        ],
                                      );
                                    },
                                  ),
                                ],
                              ),
                              ExpansionTile(
                                backgroundColor: Colors.white,
                                title: Text(
                                  'Log a visit',
                                  style: TextStyle(
                                    color: COLOR_NAVY,
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
                                              visitEntries.sort(
                                                (a, b) => b.modified
                                                    .compareTo(a.modified),
                                              );
                                              setState(() {
                                                student.visitSortBy = 'recent';
                                              });
                                            },
                                            text: "Recent",
                                            shape: GFButtonShape.pills,
                                            type:
                                                student.visitSortBy == 'recent'
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
                                              visitEntries.sort(
                                                (a, b) => a.visit.title
                                                    .compareTo(b.visit.title),
                                              );
                                              setState(() {
                                                student.visitSortBy =
                                                    'alphabet';
                                              });
                                            },
                                            text: 'A-Z',
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
                                  ListView.builder(
                                    shrinkWrap: true,
                                    physics: ClampingScrollPhysics(),
                                    itemCount: visitEntries.length,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      final EntryModel visitEntry =
                                          visitEntries[index];

                                      return ExpansionTile(
                                        key: GlobalKey(),
                                        leading: Image.network(
                                          visitEntry.visit.imgUrl,
                                        ),
                                        title: Text(
                                          '${visitEntry.visit.title} (${visitEntry.logCount})',
                                        ),
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
                                                          String url =
                                                              visitEntry.visit
                                                                  .website;
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
                                                          fontSize: 15,
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
                                                                  visitEntry
                                                                      .visit
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
                                                          fontSize: 15,
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
                                          TableCalendar(
                                            availableCalendarFormats: const {
                                              CalendarFormat.month: 'Month'
                                            },
                                            calendarController:
                                                _calendarController,
                                            events: visitEntry.logEvents,
                                            startingDayOfWeek:
                                                StartingDayOfWeek.sunday,
                                            initialSelectedDay: DateTime.now(),
                                            calendarStyle: CalendarStyle(
                                              selectedColor:
                                                  Colors.deepOrange[400],
                                              todayColor:
                                                  Colors.deepOrange[200],
                                              markersColor: Colors.black,
                                              outsideDaysVisible: false,
                                            ),
                                            builders: CalendarBuilders(
                                              markersBuilder: (context, date,
                                                  events, holidays) {
                                                final children = <Widget>[];

                                                if (events.isNotEmpty) {
                                                  children.add(
                                                    Center(
                                                      child: Stack(
                                                        children: [
                                                          Container(
                                                              height: 50,
                                                              width: 50),
                                                          Positioned(
                                                            bottom: 0,
                                                            right: 0,
                                                            child: CircleAvatar(
                                                              backgroundColor:
                                                                  COLOR_NAVY,
                                                              child: Text(
                                                                '${events.length}',
                                                                style:
                                                                    TextStyle(
                                                                  fontSize: 10,
                                                                  color: Colors
                                                                      .white,
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
                                              formatButtonTextStyle: TextStyle()
                                                  .copyWith(
                                                      color: Colors.white,
                                                      fontSize: 15.0),
                                              formatButtonDecoration:
                                                  BoxDecoration(
                                                color: Colors.deepOrange[400],
                                                borderRadius:
                                                    BorderRadius.circular(8.0),
                                              ),
                                            ),
                                            onDaySelected: (DateTime day,
                                                List events) async {
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
                                                          '${DateFormat('MMMM dd, yyyy').format(day)} for \"${visitEntry.visit.title}\"');

                                              if (!confirm) return;

                                              _myClassBloc.add(
                                                CreateVisitLogForStudentEvent(
                                                  studentUID: student.uid,
                                                  idOfEntry: visitEntry.id,
                                                  visitName:
                                                      visitEntry.visit.title,
                                                  date: day,
                                                ),
                                              );
                                            },
                                            onVisibleDaysChanged:
                                                (DateTime first, DateTime last,
                                                    CalendarFormat format) {},
                                          ),
                                          SizedBox(
                                            height: 20,
                                          ),
                                        ],
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ],
                          );
                        },
                      ),
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
    _formKey.currentState.reset();
  }
}
