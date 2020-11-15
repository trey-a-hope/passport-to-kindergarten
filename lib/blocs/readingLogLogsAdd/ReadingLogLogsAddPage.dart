import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:p/ServiceLocator.dart';
import 'package:p/SuccessMessagePage.dart';
import 'package:p/constants.dart';
import 'package:p/services/ModalService.dart';
import 'package:p/services/ValidatorService.dart';
import 'package:p/widgets/AppBarWidget.dart';
import 'package:p/widgets/FullWidthButtonWidget.dart';
import 'package:p/widgets/SpinnerWidget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Bloc.dart' as READING_LOG_LOGS_ADD_BP;

class ReadingLogLogsAddPage extends StatefulWidget {
  @override
  State createState() => ReadingLogLogsAddPageState();
}

class ReadingLogLogsAddPageState extends State<ReadingLogLogsAddPage>
    implements READING_LOG_LOGS_ADD_BP.ReadingLogLogsAddDelegate {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  READING_LOG_LOGS_ADD_BP.ReadingLogLogsAddBloc _readLogLogsBloc;
  final TextEditingController _notesController = TextEditingController();
  SharedPreferences _sharedPreferences;
  int _totalLogCount;

  @override
  void initState() {
    _readLogLogsBloc =
        BlocProvider.of<READING_LOG_LOGS_ADD_BP.ReadingLogLogsAddBloc>(context);
    _readLogLogsBloc.setDelegate(delegate: this);
    _loadSharedPref();
    super.initState();
  }

  _loadSharedPref() async {
    _sharedPreferences = await SharedPreferences.getInstance();
    _totalLogCount = _sharedPreferences.getInt('totalLogCount');
    print('Total Log Count: $_totalLogCount');
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<READING_LOG_LOGS_ADD_BP.ReadingLogLogsAddBloc,
        READING_LOG_LOGS_ADD_BP.ReadingLogLogsAddState>(
      builder: (BuildContext context,
          READING_LOG_LOGS_ADD_BP.ReadingLogLogsAddState state) {
        if (state is READING_LOG_LOGS_ADD_BP.LoadingState) {
          return Container(
            color: Colors.white,
            child: SpinnerWidget(),
          );
        }

        if (state is READING_LOG_LOGS_ADD_BP.LoadedState) {
          return Scaffold(
            key: _scaffoldKey,
            body: AnnotatedRegion<SystemUiOverlayStyle>(
              value: SystemUiOverlayStyle.light,
              child: Container(
                width: screenWidth,
                height: screenHeight,
                color: COLOR_CREAM,
                child: SafeArea(
                  child: Form(
                    key: state.formKey,
                    child: Column(
                      children: [
                        AppBarWidget(title: 'Add New Log'),
                        Padding(
                          padding: EdgeInsets.fromLTRB(20, 30, 20, 0),
                          child: TextFormField(
                            autovalidate: state.autoValidate,
                            cursorColor: Colors.black,
                            validator: locator<ValidatorService>().isEmpty,
                            keyboardType: TextInputType.text,
                            textInputAction: TextInputAction.done,
                            controller: _notesController,
                            style: TextStyle(
                                color: Colors.black, fontFamily: 'SFUIDisplay'),
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Notes for Log',
                              prefixIcon: Icon(Icons.speaker_notes),
                              labelStyle: TextStyle(fontSize: 15),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Text(
                          'For today, ${DateFormat('MMMM dd, yyyy').format(DateTime.now())}.',
                          style: TextStyle(
                            color: COLOR_NAVY,
                          ),
                        ),
                        Spacer(),
                        FullWidthButtonWidget(
                          onPressed: () async {
                            final bool confirm =
                                await locator<ModalService>().showConfirmation(
                              context: context,
                              title: 'Submit Log for ${state.book.title}',
                              message: 'Are you sure?',
                            );

                            if (!confirm) return;

                            _readLogLogsBloc.add(
                              READING_LOG_LOGS_ADD_BP.SubmitEvent(
                                formKey: state.formKey,
                                notes: _notesController.text,
                              ),
                            );

                            _totalLogCount++;

                            if (_totalLogCount % 15 == 0) {
                              Route route = MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    SuccessMessagePage(),
                              );

                              Navigator.push(context, route);
                            }
                          },
                          text: 'Submit',
                          textColor: Colors.white,
                          buttonColor: COLOR_NAVY,
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        }

        if (state is READING_LOG_LOGS_ADD_BP.ErrorState) {
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
    _notesController.clear();
  }
}
