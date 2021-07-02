import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:getwidget/getwidget.dart';
import 'package:intl/intl.dart';
import 'package:maps_launcher/maps_launcher.dart';
import 'package:p/ServiceLocator.dart';
import 'package:p/constants.dart';
import 'package:p/models/EntryModel.dart';
import 'package:p/models/UserModel.dart';
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

  // CalendarController _calendarController = CalendarController();

  @override
  void initState() {
    _visitingLogBloc = BlocProvider.of<VisitingLogBloc>(context);
    _visitingLogBloc.setDelegate(delegate: this);
    super.initState();
  }

  @override
  void dispose() {
    // _calendarController.dispose();
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
          final List<EntryModel> visitEntries = state.visitEntries;
          final UserModel currentUser = state.currentUser;

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
                      AppBarWidget(title: 'Visit Log'),
                      Padding(
                        padding: EdgeInsets.all(20),
                        child: Text(
                          'Go to our partner sites and collect all four Visit Stamps for your Passport!',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: colorNavy,
                            fontWeight: FontWeight.bold,
                            fontSize: 21,
                          ),
                        ),
                      ),
                      Text(
                        'Sort Visits By...',
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
                                  visitEntries.sort(
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
                                color: colorNavy,
                                onPressed: () {
                                  visitEntries.sort(
                                    (a, b) =>
                                        a.visit.title.compareTo(b.visit.title),
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
                      ListView.builder(
                        shrinkWrap: true,
                        physics: ClampingScrollPhysics(),
                        itemCount: visitEntries.length,
                        itemBuilder: (BuildContext context, int index) {
                          final EntryModel visitEntry = visitEntries[index];
                          return Padding(
                            padding: EdgeInsets.all(10),
                            child: ExpansionTile(
                              key: GlobalKey(),
                              leading: Image.network(
                                '${visitEntry.visit.imgUrl}',
                              ),
                              title: Text(
                                  '${visitEntry.visit.title} (${visitEntry.logCount})'),
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
                                                    '${visitEntry.visit.website}';
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
                                                color: colorNavy,
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
                                                await MapsLauncher.launchQuery(
                                                    '${visitEntry.visit.address}');
                                              },
                                              child: Image.asset(
                                                ASSET_directions_icon,
                                              ),
                                            ),
                                            Text(
                                              'Directions',
                                              style: TextStyle(
                                                color: colorNavy,
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
                                                color: colorNavy,
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
                                  focusedDay: DateTime.now(),
                                  availableCalendarFormats: const {
                                    CalendarFormat.month: 'Month'
                                  },
                                  firstDay: DateTime.now().subtract(
                                    Duration(days: 365),
                                  ),
                                  lastDay: DateTime.now().add(
                                    Duration(days: 365),
                                  ),
                                  eventLoader: (day) {
                                    DateTime dayKey = DateTime(
                                      day.year,
                                      day.month,
                                      day.day,
                                    );
                                    return visitEntry.logEvents[dayKey] ?? [];
                                  },
                                  startingDayOfWeek: StartingDayOfWeek.sunday,
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
                                  onDaySelected:
                                      (selectedDay, focusedDay) async {
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
                                                '${DateFormat('MMMM dd, yyyy').format(selectedDay)} for \"${visitEntry.visit.title}\"');

                                    if (!confirm) return;

                                    _visitingLogBloc.add(
                                      CreateVisitLogEvent(
                                        date: selectedDay,
                                        idOfEntry: visitEntry.id,
                                        visitName: visitEntry.visit.title,
                                      ),
                                    );
                                  },
                                  // onVisibleDaysChanged: (DateTime first,
                                  //     DateTime last,
                                  //     CalendarFormat format) {},
                                ),

                                // onVisibleDaysChanged: (DateTime first,
                                //     DateTime last, CalendarFormat format) {},
                              ],
                            ),
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
}
