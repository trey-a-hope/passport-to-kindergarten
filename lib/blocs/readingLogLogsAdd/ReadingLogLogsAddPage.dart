import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:p/ServiceLocator.dart';
import 'package:p/constants.dart';
import 'package:p/models/ParentLogModel.dart';
import 'package:p/models/LogModel.dart';
import 'package:p/services/ModalService.dart';
import 'package:p/services/ValidatorService.dart';
import 'package:p/widgets/DrawerWidget.dart';
import 'package:p/widgets/FullWidthButtonWidget.dart';
import 'package:p/widgets/SpinnerWidget.dart';
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

  @override
  void initState() {
    _readLogLogsBloc =
        BlocProvider.of<READING_LOG_LOGS_ADD_BP.ReadingLogLogsAddBloc>(context);
    _readLogLogsBloc.setDelegate(delegate: this);
    super.initState();
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
            appBar: AppBar(
              centerTitle: true,
              title: Text('Create Log'),
            ),
            body: AnnotatedRegion<SystemUiOverlayStyle>(
              value: SystemUiOverlayStyle.light,
              child: SafeArea(
                child: Form(
                  key: state.formKey,
                  child: Column(
                    children: [
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
                            labelText: 'Notes',
                            prefixIcon: Icon(Icons.speaker_notes),
                            labelStyle: TextStyle(fontSize: 15),
                          ),
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
                        },
                        text: 'Submit',
                        textColor: Colors.white,
                        buttonColor: Colors.grey,
                      )
                    ],
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