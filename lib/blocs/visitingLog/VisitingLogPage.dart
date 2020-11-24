import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:getwidget/getwidget.dart';
import 'package:intl/intl.dart';
import 'package:maps_launcher/maps_launcher.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:p/ServiceLocator.dart';
import 'package:p/constants.dart';
import 'package:p/models/UserModel.dart';
import 'package:p/models/VisitModel.dart';
import 'package:p/services/ModalService.dart';
import 'package:p/widgets/AppBarWidget.dart';
import 'package:p/widgets/SpinnerWidget.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:url_launcher/url_launcher.dart';
import 'Bloc.dart';

class VisitingLogPage extends StatefulWidget {
  @override
  State createState() => VisitingLogPageState();
}

class VisitingLogPageState extends State<VisitingLogPage>
    implements VisitingLogDelegate {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  VisitingLogBloc _visitingLogBloc;

  CalendarController _calendarController = CalendarController();

  @override
  void initState() {
    _visitingLogBloc = BlocProvider.of<VisitingLogBloc>(context);
    _visitingLogBloc.setDelegate(delegate: this);
    super.initState();
  }

  @override
  void dispose() {
    _calendarController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<VisitingLogBloc, VisitingLogState>(
      builder: (BuildContext context, VisitingLogState state) {
        if (state is LoadingState) {
          return Container(
            color: Colors.white,
            child: SpinnerWidget(),
          );
        }

        if (state is LoadedState) {
          final List<VisitModel> visits = state.visits;
          final UserModel currentUser = state.currentUser;

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
                      AppBarWidget(title: 'Visit Log'),
                      Padding(
                        padding: EdgeInsets.all(20),
                        child: Text(
                          'Go to our partner sites and collect all four Visit Stamps for your Passport!',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: COLOR_NAVY,
                            fontWeight: FontWeight.bold,
                            fontSize: 21,
                          ),
                        ),
                      ),
                      Text(
                        'Sort Visits By...',
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
                                  visits.sort(
                                    (a, b) => b.modified.compareTo(a.modified),
                                  );
                                  setState(() {
                                    currentUser.visitSortBy = 'recent';
                                  });
                                },
                                text: "Recent",
                                shape: GFButtonShape.pills,
                                type: currentUser.visitSortBy == 'recent'
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
                                    (a, b) => b.logCount.compareTo(a.logCount),
                                  );
                                  setState(() {
                                    currentUser.visitSortBy = 'mostVisited';
                                  });
                                },
                                text: "Most Visits",
                                shape: GFButtonShape.pills,
                                type: currentUser.visitSortBy == 'mostVisited'
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
                                    (a, b) => a.logCount.compareTo(b.logCount),
                                  );
                                  setState(() {
                                    currentUser.visitSortBy = 'leastVisited';
                                  });
                                },
                                text: "Least Visits",
                                shape: GFButtonShape.pills,
                                type: currentUser.visitSortBy == 'leastVisited'
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
                                    (a, b) => a.title.compareTo(b.title),
                                  );
                                  setState(() {
                                    currentUser.visitSortBy = 'alphabet';
                                  });
                                },
                                text: 'A-Z',
                                shape: GFButtonShape.pills,
                                type: currentUser.visitSortBy == 'alphabet'
                                    ? null
                                    : GFButtonType.outline2x,
                              ),
                            ),
                          ),
                        ],
                      ),
                      Expanded(
                        child: ListView.builder(
                          itemCount: visits.length,
                          itemBuilder: (BuildContext context, int index) {
                            final VisitModel visit = visits[index];
                            return Padding(
                              padding: EdgeInsets.all(10),
                              child: ExpansionTile(
                                leading: Image.asset(
                                  '${visit.assetImagePath}',
                                ),
                                title:
                                    Text('${visit.title} (${visit.logCount})'),
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
                                                  final String url =
                                                      '${visit.website}';
                                                  if (await canLaunch(url)) {
                                                    await launch(url);
                                                  } else {
                                                    locator<ModalService>()
                                                        .showAlert(
                                                      context: context,
                                                      title: 'Error',
                                                      message:
                                                          'Could not open url.',
                                                    );
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
                                                  fontWeight: FontWeight.bold,
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
                                                          '${visit.address}');
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
                                                  fontWeight: FontWeight.bold,
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
                                                  fontWeight: FontWeight.bold,
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
                                    calendarController: _calendarController,
                                    events: visit.logEvents,
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
                                                  Icon(
                                                    Icons.location_on,
                                                    color: Colors.orange,
                                                    size: 15,
                                                  ),
                                                  Positioned(
                                                    bottom: 0,
                                                    right: 0,
                                                    child: CircleAvatar(
                                                      backgroundColor:
                                                          COLOR_NAVY,
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
                                      formatButtonTextStyle: TextStyle()
                                          .copyWith(
                                              color: Colors.white,
                                              fontSize: 15.0),
                                      formatButtonDecoration: BoxDecoration(
                                        color: Colors.deepOrange[400],
                                        borderRadius:
                                            BorderRadius.circular(8.0),
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
                                                  '${DateFormat('MMMM dd, yyyy').format(day)} for \"${visit.title}\"');

                                      if (!confirm) return;

                                      _visitingLogBloc.add(
                                        CreateVisitLogEvent(
                                          visitID: visit.id,
                                          visitName: visit.title,
                                          date: day,
                                        ),
                                      );
                                    },
                                    onVisibleDaysChanged: (DateTime first,
                                        DateTime last,
                                        CalendarFormat format) {},
                                  ),
                                ],
                              ),
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
