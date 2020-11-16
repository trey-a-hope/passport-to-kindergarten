import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:p/ServiceLocator.dart';
import 'package:p/constants.dart';
import 'package:maps_launcher/maps_launcher.dart';
import 'package:p/models/LogModel.dart';
import 'package:p/models/VisitModel.dart';
import 'package:p/services/ModalService.dart';
import 'package:p/widgets/AppBarWidget.dart';
import 'package:p/widgets/FullWidthButtonWidget.dart';
import 'package:p/widgets/SpinnerWidget.dart';
import 'package:url_launcher/url_launcher.dart';
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
    @required VisitModel visit,
    @required DateTime initialSelectedDay,
  }) {
    locator<ModalService>().showAlert(
      context: context,
      title: 'To Do',
      message: 'Display visit logs page.',
    );
    return;

    Route route = MaterialPageRoute(
      builder: (BuildContext context) => BlocProvider(
        create: (BuildContext context) =>
            VISITING_LOG_LOGS_BP.VisitingLogLogsBloc(
          visit: visit,
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
          final List<LogModel> logs = state.logs;

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
                      Expanded(
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: DEFAULT_VISITS.length,
                          itemBuilder: (context, index) {
                            final VisitModel visit = DEFAULT_VISITS[index];
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
                                                visit: visit,
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
                                                visit: visit,
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
                                                visit: visit,
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
                                                visit: visit,
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
                                                visit: visit,
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
                                                visit: visit,
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
                                                visit: visit,
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
                                                visit: visit,
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
                                                visit: visit,
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
                                                visit: visit,
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
                                                visit: visit,
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
                                                visit: visit,
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
                            );
                          },
                        ),
                      ),
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
