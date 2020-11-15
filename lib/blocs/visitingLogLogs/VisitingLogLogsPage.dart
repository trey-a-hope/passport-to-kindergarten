import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:p/ServiceLocator.dart';
import 'package:p/constants.dart';
import 'package:p/models/ChildLogModel.dart';
import 'package:p/services/ModalService.dart';
import 'package:p/widgets/AppBarWidget.dart';
import 'package:p/widgets/FullWidthButtonWidget.dart';
import 'package:p/widgets/SpinnerWidget.dart';
import 'package:table_calendar/table_calendar.dart';
import 'Bloc.dart' as VISITING_LOG_LOGS_BP;
import 'package:p/blocs/visitingLogLogsAdd/Bloc.dart'
    as VISITING_LOG_LOGS_ADD_BP;

class VisitingLogLogsPage extends StatefulWidget {
  @override
  State createState() => VisitingLogLogsPageState();
}

class VisitingLogLogsPageState extends State<VisitingLogLogsPage>
    implements VISITING_LOG_LOGS_BP.VisitingLogLogsDelegate {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  VISITING_LOG_LOGS_BP.VisitingLogLogsBloc _visitingLogLogsBloc;

  final TextEditingController _descriptionController = TextEditingController();
  CalendarController _calendarController;

  @override
  void initState() {
    _visitingLogLogsBloc =
        BlocProvider.of<VISITING_LOG_LOGS_BP.VisitingLogLogsBloc>(context);
    _visitingLogLogsBloc.setDelegate(delegate: this);
    _calendarController = CalendarController();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<VISITING_LOG_LOGS_BP.VisitingLogLogsBloc,
        VISITING_LOG_LOGS_BP.VisitingLogLogState>(
      builder: (BuildContext context,
          VISITING_LOG_LOGS_BP.VisitingLogLogState state) {
        if (state is VISITING_LOG_LOGS_BP.LoadingState) {
          return Container(
            color: Colors.white,
            child: SpinnerWidget(),
          );
        }

        if (state is VISITING_LOG_LOGS_BP.LoadedState) {
          //final List<ChildLogModel> logs = state.logs;
          // final ParentLogModel book = state.book;
          final String title = state.title;

          final List<ChildLogModel> logs =
              state.events[state.dateKey] ?? List<ChildLogModel>();
          final DateTime initialSelectedDay = state.initialSelectedDay;

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
                      AppBarWidget(title: 'Logs for $title'),
                      TableCalendar(
                        calendarController: _calendarController,
                        events: state.events,
                        startingDayOfWeek: StartingDayOfWeek.sunday,
                        initialSelectedDay: initialSelectedDay,
                        calendarStyle: CalendarStyle(
                          selectedColor: Colors.deepOrange[400],
                          todayColor: Colors.deepOrange[200],
                          markersColor: Colors.black,
                          outsideDaysVisible: false,
                        ),
                        headerStyle: HeaderStyle(
                          formatButtonTextStyle: TextStyle()
                              .copyWith(color: Colors.white, fontSize: 15.0),
                          formatButtonDecoration: BoxDecoration(
                            color: Colors.deepOrange[400],
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        ),
                        onDaySelected: (DateTime day, List events) {
                          _visitingLogLogsBloc.add(
                            VISITING_LOG_LOGS_BP.OnDaySelectedEvent(
                              selectedDay: day,
                            ),
                          );
                        },
                        onVisibleDaysChanged: (DateTime first, DateTime last,
                            CalendarFormat format) {},
                      ),
                      Divider(
                        thickness: 1,
                      ),
                      Expanded(
                        child: ListView.builder(
                          itemCount: logs.length,
                          itemBuilder: (BuildContext context, int index) {
                            final ChildLogModel log = logs[index];
                            return ListTile(
                              leading: Icon(
                                MdiIcons.book,
                                color: COLOR_NAVY,
                              ),
                              title: Text(
                                '\"${log.notes}\"',
                                style: TextStyle(
                                  color: COLOR_NAVY,
                                ),
                              ),
                              subtitle: Text(
                                '${DateFormat('MMMM dd, yyyy').format(log.created)}',
                                style: TextStyle(
                                  color: COLOR_NAVY,
                                ),
                              ),
                              onTap: () {
                                // locator<ModalService>().showAlert(
                                //     context: context,
                                //     title: 'Notes',
                                //     message: '\"${log.notes}\"');
                              },
                            );
                          },
                        ),
                      ),
                      Divider(
                        thickness: 1,
                      ),
                      FullWidthButtonWidget(
                        onPressed: () {
                          Route route = MaterialPageRoute(
                            builder: (BuildContext context) => BlocProvider(
                              create: (BuildContext context) =>
                                  VISITING_LOG_LOGS_ADD_BP
                                      .VisitingLogLogsAddBloc(
                                title: title,
                              )..add(
                                      VISITING_LOG_LOGS_ADD_BP.LoadPageEvent(),
                                    ),
                              child: VISITING_LOG_LOGS_ADD_BP
                                  .VisitingLogLogsAddPage(),
                            ),
                          );
                          Navigator.push(context, route);
                        },
                        text: 'Add a new log',
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

        if (state is VISITING_LOG_LOGS_BP.ErrorState) {
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
  void clearForm() {
    _descriptionController.clear();
  }
}
