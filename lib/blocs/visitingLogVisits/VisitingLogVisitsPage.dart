import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:p/ServiceLocator.dart';
import 'package:p/constants.dart';
import 'package:p/models/ChildLogModel.dart';
import 'package:p/models/ParentLogModel.dart';
import 'package:p/services/ModalService.dart';
import 'package:p/widgets/FullWidthButtonWidget.dart';
import 'package:p/widgets/SpinnerWidget.dart';
import 'Bloc.dart' as VISITING_LOG_VISITS_BP;
import 'package:p/blocs/visitingLogLogs/Bloc.dart' as VISITING_LOG_LOGS_BP;

class VisitingLogVisitsPage extends StatefulWidget {
  @override
  State createState() => VisitingLogVisitsPageState();
}

class VisitingLogVisitsPageState extends State<VisitingLogVisitsPage>
    implements VISITING_LOG_VISITS_BP.VisitingLogVisitsDelegate {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  VISITING_LOG_VISITS_BP.VisitingLogVisitsBloc _visitingLogVisitsBloc;

  @override
  void initState() {
    _visitingLogVisitsBloc =
        BlocProvider.of<VISITING_LOG_VISITS_BP.VisitingLogVisitsBloc>(context);
    _visitingLogVisitsBloc.setDelegate(delegate: this);
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _goToLogsForThisVisit({
    @required String title,
    @required DateTime initialSelectedDay,
  }) {
    Route route = MaterialPageRoute(
      builder: (BuildContext context) => BlocProvider(
        create: (BuildContext context) =>
            VISITING_LOG_LOGS_BP.VisitingLogLogsBloc(
          title: title,
          initialSelectedDay: initialSelectedDay,
        )..add(
                VISITING_LOG_LOGS_BP.LoadPageEvent(),
              ),
        child: VISITING_LOG_LOGS_BP.VisitingLogLogsPage(),
      ),
    );
    Navigator.push(context, route);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<VISITING_LOG_VISITS_BP.VisitingLogVisitsBloc,
        VISITING_LOG_VISITS_BP.VisitingLogVisitsState>(
      builder: (BuildContext context,
          VISITING_LOG_VISITS_BP.VisitingLogVisitsState state) {
        if (state is VISITING_LOG_VISITS_BP.LoadingState) {
          return Container(
            color: Colors.white,
            child: SpinnerWidget(),
          );
        }

        if (state is VISITING_LOG_VISITS_BP.LoadedState) {
          final List<ChildLogModel> visitLogs = state.logs;

          final int boonshoftMuseumCount = visitLogs
              .where((visitLog) =>
                  visitLog.title == 'Boonshoft Museaum of Discovery')
              .toList()
              .length;

          final int daytonMetroCount = visitLogs
              .where((visitLog) => visitLog.title == 'Dayton Metro Library')
              .toList()
              .length;

          final int fiveRiversCount = visitLogs
              .where((visitLog) => visitLog.title == 'Five Rivers Metro Park')
              .toList()
              .length;

          final int daytonArtCount = visitLogs
              .where((visitLog) => visitLog.title == 'Dayton Art Institute')
              .toList()
              .length;

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
                                'Visit Log',
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
                      Expanded(
                        child: ListView(
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
                                                onTap: () {
                                                  locator<ModalService>()
                                                      .showAlert(
                                                    context: context,
                                                    title: 'To Do',
                                                    message: 'Go to website.',
                                                  );
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
                                                onTap: () {
                                                  locator<ModalService>()
                                                      .showAlert(
                                                    context: context,
                                                    title: 'To Do',
                                                    message:
                                                        'Go to directions.',
                                                  );
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
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold,
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
                                              _goToLogsForThisVisit(
                                                title:
                                                    'Boonshoft Museum of Discovery',
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
                                              _goToLogsForThisVisit(
                                                title:
                                                    'Boonshoft Museum of Discovery',
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
                                              _goToLogsForThisVisit(
                                                title:
                                                    'Boonshoft Museum of Discovery',
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
                                              _goToLogsForThisVisit(
                                                title:
                                                    'Boonshoft Museum of Discovery',
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
                                              _goToLogsForThisVisit(
                                                title:
                                                    'Boonshoft Museum of Discovery',
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
                                              _goToLogsForThisVisit(
                                                title:
                                                    'Boonshoft Museum of Discovery',
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
                                              _goToLogsForThisVisit(
                                                title:
                                                    'Boonshoft Museum of Discovery',
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
                                              _goToLogsForThisVisit(
                                                title:
                                                    'Boonshoft Museum of Discovery',
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
                                              _goToLogsForThisVisit(
                                                title:
                                                    'Boonshoft Museum of Discovery',
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
                                              _goToLogsForThisVisit(
                                                title:
                                                    'Boonshoft Museum of Discovery',
                                                initialSelectedDay:
                                                    DateTime(2020, 10),
                                              ); // _goToLogsForThisBook(
                                              //   book: book,
                                              //   initialSelectedDay:
                                              //       DateTime(2020, 10),
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
                                              _goToLogsForThisVisit(
                                                title:
                                                    'Boonshoft Museum of Discovery',
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
                                              _goToLogsForThisVisit(
                                                title:
                                                    'Boonshoft Museum of Discovery',
                                                initialSelectedDay: DateTime(
                                                  2020,
                                                  12,
                                                ),
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
                                                onTap: () {
                                                  locator<ModalService>()
                                                      .showAlert(
                                                    context: context,
                                                    title: 'To Do',
                                                    message: 'Go to website.',
                                                  );
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
                                                onTap: () {
                                                  locator<ModalService>()
                                                      .showAlert(
                                                    context: context,
                                                    title: 'To Do',
                                                    message:
                                                        'Go to directions.',
                                                  );
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
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold,
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
                                              _goToLogsForThisVisit(
                                                title: 'Dayton Metro Library',
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
                                              _goToLogsForThisVisit(
                                                title: 'Dayton Metro Library',
                                                initialSelectedDay:
                                                    DateTime(2020, 1),
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
                                              _goToLogsForThisVisit(
                                                title: 'Dayton Metro Library',
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
                                              _goToLogsForThisVisit(
                                                title: 'Dayton Metro Library',
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
                                              _goToLogsForThisVisit(
                                                title: 'Dayton Metro Library',
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
                                              _goToLogsForThisVisit(
                                                title: 'Dayton Metro Library',
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
                                              _goToLogsForThisVisit(
                                                title: 'Dayton Metro Library',
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
                                              _goToLogsForThisVisit(
                                                title: 'Dayton Metro Library',
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
                                              _goToLogsForThisVisit(
                                                title: 'Dayton Metro Library',
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
                                              _goToLogsForThisVisit(
                                                title: 'Dayton Metro Library',
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
                                              _goToLogsForThisVisit(
                                                title: 'Dayton Metro Library',
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
                                              _goToLogsForThisVisit(
                                                title: 'Dayton Metro Library',
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
                                                onTap: () {
                                                  locator<ModalService>()
                                                      .showAlert(
                                                    context: context,
                                                    title: 'To Do',
                                                    message: 'Go to website.',
                                                  );
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
                                                onTap: () {
                                                  locator<ModalService>()
                                                      .showAlert(
                                                    context: context,
                                                    title: 'To Do',
                                                    message:
                                                        'Go to directions.',
                                                  );
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
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold,
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
                                              _goToLogsForThisVisit(
                                                title:
                                                    'Fiver Rivers Metro Park',
                                                initialSelectedDay: DateTime(
                                                  2020,
                                                  1,
                                                ),
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
                                              _goToLogsForThisVisit(
                                                title:
                                                    'Fiver Rivers Metro Park',
                                                initialSelectedDay: DateTime(
                                                  2020,
                                                  2,
                                                ),
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
                                              _goToLogsForThisVisit(
                                                title:
                                                    'Fiver Rivers Metro Park',
                                                initialSelectedDay: DateTime(
                                                  2020,
                                                  3,
                                                ),
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
                                              _goToLogsForThisVisit(
                                                title:
                                                    'Fiver Rivers Metro Park',
                                                initialSelectedDay: DateTime(
                                                  2020,
                                                  4,
                                                ),
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
                                              _goToLogsForThisVisit(
                                                title:
                                                    'Fiver Rivers Metro Park',
                                                initialSelectedDay: DateTime(
                                                  2020,
                                                  5,
                                                ),
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
                                              _goToLogsForThisVisit(
                                                title:
                                                    'Fiver Rivers Metro Park',
                                                initialSelectedDay: DateTime(
                                                  2020,
                                                  6,
                                                ),
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
                                              _goToLogsForThisVisit(
                                                title:
                                                    'Fiver Rivers Metro Park',
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
                                              _goToLogsForThisVisit(
                                                title:
                                                    'Fiver Rivers Metro Park',
                                                initialSelectedDay: DateTime(
                                                  2020,
                                                  8,
                                                ),
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
                                              _goToLogsForThisVisit(
                                                title:
                                                    'Fiver Rivers Metro Park',
                                                initialSelectedDay: DateTime(
                                                  2020,
                                                  9,
                                                ),
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
                                              _goToLogsForThisVisit(
                                                title:
                                                    'Fiver Rivers Metro Park',
                                                initialSelectedDay: DateTime(
                                                  2020,
                                                  10,
                                                ),
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
                                              _goToLogsForThisVisit(
                                                title:
                                                    'Fiver Rivers Metro Park',
                                                initialSelectedDay: DateTime(
                                                  2020,
                                                  11,
                                                ),
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
                                              _goToLogsForThisVisit(
                                                title:
                                                    'Fiver Rivers Metro Park',
                                                initialSelectedDay: DateTime(
                                                  2020,
                                                  12,
                                                ),
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
                                                onTap: () {
                                                  locator<ModalService>()
                                                      .showAlert(
                                                    context: context,
                                                    title: 'To Do',
                                                    message: 'Go to website.',
                                                  );
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
                                                onTap: () {
                                                  locator<ModalService>()
                                                      .showAlert(
                                                    context: context,
                                                    title: 'To Do',
                                                    message:
                                                        'Go to directions.',
                                                  );
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
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold,
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
                                              _goToLogsForThisVisit(
                                                title: 'Dayton Art Institute',
                                                initialSelectedDay: DateTime(
                                                  2020,
                                                  1,
                                                ),
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
                                              _goToLogsForThisVisit(
                                                title: 'Dayton Art Institute',
                                                initialSelectedDay: DateTime(
                                                  2020,
                                                  2,
                                                ),
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
                                              _goToLogsForThisVisit(
                                                title: 'Dayton Art Institute',
                                                initialSelectedDay: DateTime(
                                                  2020,
                                                  3,
                                                ),
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
                                              _goToLogsForThisVisit(
                                                title: 'Dayton Art Institute',
                                                initialSelectedDay: DateTime(
                                                  2020,
                                                  4,
                                                ),
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
                                              _goToLogsForThisVisit(
                                                title: 'Dayton Art Institute',
                                                initialSelectedDay: DateTime(
                                                  2020,
                                                  5,
                                                ),
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
                                              _goToLogsForThisVisit(
                                                title: 'Dayton Art Institute',
                                                initialSelectedDay: DateTime(
                                                  2020,
                                                  6,
                                                ),
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
                                              _goToLogsForThisVisit(
                                                title: 'Dayton Art Institute',
                                                initialSelectedDay: DateTime(
                                                  2020,
                                                  7,
                                                ),
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
                                              _goToLogsForThisVisit(
                                                title: 'Dayton Art Institute',
                                                initialSelectedDay: DateTime(
                                                  2020,
                                                  8,
                                                ),
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
                                              _goToLogsForThisVisit(
                                                title: 'Dayton Art Institute',
                                                initialSelectedDay: DateTime(
                                                  2020,
                                                  9,
                                                ),
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
                                              _goToLogsForThisVisit(
                                                title: 'Dayton Art Institute',
                                                initialSelectedDay: DateTime(
                                                  2020,
                                                  10,
                                                ),
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
                                              _goToLogsForThisVisit(
                                                title: 'Dayton Art Institute',
                                                initialSelectedDay: DateTime(
                                                  2020,
                                                  11,
                                                ),
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
                                              _goToLogsForThisVisit(
                                                title: 'Dayton Art Institute',
                                                initialSelectedDay: DateTime(
                                                  2020,
                                                  12,
                                                ),
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
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          );
        }

        if (state is VISITING_LOG_VISITS_BP.ErrorState) {
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