import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:p/ServiceLocator.dart';
import 'package:p/constants.dart';
import 'package:p/services/ModalService.dart';
import 'package:p/services/ValidatorService.dart';
import 'package:p/widgets/AppBarWidget.dart';
import 'package:p/widgets/FullWidthButtonWidget.dart';
import 'package:p/widgets/SpinnerWidget.dart';
import 'Bloc.dart' as VISITING_LOG_LOGS_ADD_BP;

class VisitingLogLogsAddPage extends StatefulWidget {
  @override
  State createState() => VisitingLogLogsAddPageState();
}

class VisitingLogLogsAddPageState extends State<VisitingLogLogsAddPage>
    implements VISITING_LOG_LOGS_ADD_BP.VisitingLogLogsAddDelegate {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  VISITING_LOG_LOGS_ADD_BP.VisitingLogLogsAddBloc _visitingLogLogsAddBloc;

  final TextEditingController _descriptionController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    _visitingLogLogsAddBloc =
        BlocProvider.of<VISITING_LOG_LOGS_ADD_BP.VisitingLogLogsAddBloc>(
            context);
    _visitingLogLogsAddBloc.setDelegate(delegate: this);
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<VISITING_LOG_LOGS_ADD_BP.VisitingLogLogsAddBloc,
        VISITING_LOG_LOGS_ADD_BP.VisitingLogLogsAddState>(
      builder: (BuildContext context,
          VISITING_LOG_LOGS_ADD_BP.VisitingLogLogsAddState state) {
        if (state is VISITING_LOG_LOGS_ADD_BP.LoadingState) {
          return Container(
            color: Colors.white,
            child: SpinnerWidget(),
          );
        }

        if (state is VISITING_LOG_LOGS_ADD_BP.LoadedState) {
          final String title = state.title;

          return Scaffold(
            key: _scaffoldKey,
            body: AnnotatedRegion<SystemUiOverlayStyle>(
              value: SystemUiOverlayStyle.light,
              child: Container(
                color: COLOR_CREAM,
                child: SafeArea(
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        AppBarWidget(title: 'Add New Log'),
                        Padding(
                          padding: EdgeInsets.fromLTRB(20, 30, 20, 0),
                          child: TextFormField(
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            cursorColor: Colors.black,
                            validator: locator<ValidatorService>().isEmpty,
                            keyboardType: TextInputType.text,
                            textInputAction: TextInputAction.done,
                            controller: _descriptionController,
                            style: TextStyle(
                                color: Colors.black, fontFamily: 'SFUIDisplay'),
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Description for Log',
                              prefixIcon: Icon(Icons.speaker_notes),
                              labelStyle: TextStyle(fontSize: 15),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Padding(
                          padding: EdgeInsets.all(10),
                          child: Text(
                            'For today, ${DateFormat('MMMM dd, yyyy').format(DateTime.now())} @ $title',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: COLOR_NAVY,
                            ),
                          ),
                        ),
                        Spacer(),
                        FullWidthButtonWidget(
                          onPressed: () async {
                            final bool confirm =
                                await locator<ModalService>().showConfirmation(
                              context: context,
                              title: 'Submit Visit Log for $title',
                              message: 'Are you sure?',
                            );

                            if (!confirm) return;

                            _visitingLogLogsAddBloc.add(
                              VISITING_LOG_LOGS_ADD_BP.SubmitEvent(
                                description: _descriptionController.text,
                              ),
                            );
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

        if (state is VISITING_LOG_LOGS_ADD_BP.ErrorState) {
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
    _formKey.currentState.reset();
  }
}
