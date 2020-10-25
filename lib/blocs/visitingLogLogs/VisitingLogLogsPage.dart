import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:p/ServiceLocator.dart';
import 'package:p/services/ModalService.dart';
import 'package:p/widgets/FullWidthButtonWidget.dart';
import 'package:p/widgets/SpinnerWidget.dart';
import 'Bloc.dart' as VISITING_LOG_LOGS_BP;

class VisitingLogLogsPage extends StatefulWidget {
  @override
  State createState() => VisitingLogLogsPageState();
}

class VisitingLogLogsPageState extends State<VisitingLogLogsPage>
    implements VISITING_LOG_LOGS_BP.VisitingLogLogsDelegate {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  VISITING_LOG_LOGS_BP.VisitingLogLogsBloc _visitingLogLogsBloc;

  final TextEditingController _descriptionController = TextEditingController();

  @override
  void initState() {
    _visitingLogLogsBloc =
        BlocProvider.of<VISITING_LOG_LOGS_BP.VisitingLogLogsBloc>(context);
    _visitingLogLogsBloc.setDelegate(delegate: this);
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
          return Scaffold(
            key: _scaffoldKey,
            appBar: AppBar(
              centerTitle: true,
              title: Text('Create Visit Log'),
            ),
            body: AnnotatedRegion<SystemUiOverlayStyle>(
                value: SystemUiOverlayStyle.light,
                child: SafeArea(
                  child: Form(
                    key: state.formKey,
                    child: Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.all(20),
                          child: TextFormField(
                            autovalidate: state.autoValidate,
                            controller: _descriptionController,
                            style: TextStyle(color: Colors.black),
                            decoration: InputDecoration(
                                prefixIcon: Icon(
                                  Icons.description,
                                  color: Colors.grey.shade700,
                                ),
                                border: OutlineInputBorder(
                                  // width: 0.0 produces a thin "hairline" border
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(90.0),
                                  ),
                                  borderSide: BorderSide.none,

                                  //borderSide: const BorderSide(),
                                ),
                                hintStyle: TextStyle(
                                    color: Colors.grey,
                                    fontFamily: "WorkSansLight"),
                                filled: true,
                                fillColor: Colors.grey.shade300,
                                hintText: 'Description'),
                          ),
                        ),
                        Spacer(),
                        FullWidthButtonWidget(
                          buttonColor: Colors.blue,
                          text: 'Submit Visit Log',
                          textColor: Colors.white,
                          onPressed: () async {
                            bool confirm = await locator<ModalService>()
                                .showConfirmation(
                                    context: context,
                                    title: 'Submit',
                                    message: 'Are you sure?');

                            if (!confirm) return;

                            final String description =
                                _descriptionController.text;

                            _visitingLogLogsBloc.add(
                              VISITING_LOG_LOGS_BP.SubmitEvent(
                                description: description,
                                formKey: state.formKey,
                              ),
                            );
                          },
                        )
                      ],
                    ),
                  ),
                )),
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
