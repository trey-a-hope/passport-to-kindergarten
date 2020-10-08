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
import 'Bloc.dart' as READING_LOG_BOOKS_ADD_BP;

class ReadingLogBooksAddPage extends StatefulWidget {
  @override
  State createState() => ReadingLogBooksAddPageState();
}

class ReadingLogBooksAddPageState extends State<ReadingLogBooksAddPage>
    implements READING_LOG_BOOKS_ADD_BP.ReadingLogBooksAddDelegate {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  READING_LOG_BOOKS_ADD_BP.ReadingLogBooksAddBloc _readLogBooksBloc;

  final TextEditingController _bookTitleController = TextEditingController();

  @override
  void initState() {
    _readLogBooksBloc =
        BlocProvider.of<READING_LOG_BOOKS_ADD_BP.ReadingLogBooksAddBloc>(
            context);
    _readLogBooksBloc.setDelegate(delegate: this);
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<READING_LOG_BOOKS_ADD_BP.ReadingLogBooksAddBloc,
        READING_LOG_BOOKS_ADD_BP.ReadingLogBooksAddState>(
      builder: (BuildContext context,
          READING_LOG_BOOKS_ADD_BP.ReadingLogBooksAddState state) {
        if (state is READING_LOG_BOOKS_ADD_BP.LoadingState) {
          return Container(
            color: Colors.white,
            child: SpinnerWidget(),
          );
        }

        if (state is READING_LOG_BOOKS_ADD_BP.LoadedState) {
          return Scaffold(
            key: _scaffoldKey,
            appBar: AppBar(
              iconTheme: IconThemeData(color: Colors.black),
              backgroundColor: COLOR_CREAM,
            ),
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
                          Container(
                            width: screenWidth,
                            height: 80,
                            color: COLOR_ORANGE,
                            child: Center(
                              child: Text(
                                'Add Book',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 21,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.fromLTRB(20, 30, 20, 0),
                            child: TextFormField(
                              autovalidate: state.autoValidate,
                              cursorColor: Colors.black,
                              validator: locator<ValidatorService>().isEmpty,
                              keyboardType: TextInputType.text,
                              textInputAction: TextInputAction.done,
                              controller: _bookTitleController,
                              style: TextStyle(
                                  color: Colors.black,
                                  fontFamily: 'SFUIDisplay'),
                              decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: 'Book Title',
                                prefixIcon: Icon(Icons.person),
                                labelStyle: TextStyle(fontSize: 15),
                              ),
                            ),
                          ),
                          Spacer(),
                          FullWidthButtonWidget(
                            onPressed: () async {
                              final bool confirm = await locator<ModalService>()
                                  .showConfirmation(
                                context: context,
                                title: 'Submit Book',
                                message: 'Are you sure?',
                              );

                              if (!confirm) return;

                              _readLogBooksBloc.add(
                                READING_LOG_BOOKS_ADD_BP.SubmitEvent(
                                  bookTitle: _bookTitleController.text,
                                  formKey: state.formKey,
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
                )

                // SafeArea(
                //   child: Form(
                //     key: state.formKey,
                //     child: Column(
                //       children: [
                //         Padding(
                //           padding: EdgeInsets.fromLTRB(20, 30, 20, 0),
                //           child: TextFormField(
                //             autovalidate: state.autoValidate,
                //             cursorColor: Colors.black,
                //             validator: locator<ValidatorService>().isEmpty,
                //             keyboardType: TextInputType.text,
                //             textInputAction: TextInputAction.done,
                //             controller: _bookTitleController,
                //             style: TextStyle(
                //                 color: Colors.black, fontFamily: 'SFUIDisplay'),
                //             decoration: InputDecoration(
                //               border: OutlineInputBorder(),
                //               labelText: 'Book Title',
                //               prefixIcon: Icon(Icons.person),
                //               labelStyle: TextStyle(fontSize: 15),
                //             ),
                //           ),
                //         ),
                //         Spacer(),
                //         FullWidthButtonWidget(
                //           onPressed: () async {
                //             final bool confirm =
                //                 await locator<ModalService>().showConfirmation(
                //               context: context,
                //               title: 'Submit Book',
                //               message: 'Are you sure?',
                //             );

                //             if (!confirm) return;

                //             _readLogBooksBloc.add(
                //               READING_LOG_BOOKS_ADD_BP.SubmitEvent(
                //                 bookTitle: _bookTitleController.text,
                //                 formKey: state.formKey,
                //               ),
                //             );
                //           },
                //           text: 'Submit',
                //           textColor: Colors.white,
                //           buttonColor: Colors.grey,
                //         )
                //       ],
                //     ),
                //   ),
                // ),
                ),
          );
        }

        if (state is READING_LOG_BOOKS_ADD_BP.ErrorState) {
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
    _bookTitleController.clear();
  }
}
