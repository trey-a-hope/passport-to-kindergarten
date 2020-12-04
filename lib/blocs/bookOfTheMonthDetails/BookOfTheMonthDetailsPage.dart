import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:p/ServiceLocator.dart';
import 'package:p/constants.dart';
import 'package:p/models/BookModel.dart';
import 'package:p/services/ModalService.dart';
import 'package:p/widgets/AppBarWidget.dart';
import 'package:p/widgets/SpinnerWidget.dart';
import 'Bloc.dart';

class BookOfTheMonthDetailsPage extends StatefulWidget {
  @override
  State createState() => BookOfTheMonthDetailsPageState();
}

class BookOfTheMonthDetailsPageState extends State<BookOfTheMonthDetailsPage>
    implements BookOfTheMonthDetailsDelegate {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  BookOfTheMonthDetailsBloc _bookOfTheMonthDetailsBloc;

  @override
  void initState() {
    _bookOfTheMonthDetailsBloc =
        BlocProvider.of<BookOfTheMonthDetailsBloc>(context);
    _bookOfTheMonthDetailsBloc.setDelegate(delegate: this);
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BookOfTheMonthDetailsBloc, BookOfTheMonthDetailsState>(
      builder: (BuildContext context, BookOfTheMonthDetailsState state) {
        if (state is LoadingState) {
          return Container(
            color: Colors.white,
            child: SpinnerWidget(),
          );
        }

        if (state is LoadedState) {
          final BookModel bookOfTheMonth = state.bookOfTheMonth;
          List<Widget> conversationStarters = List<Widget>();

          bookOfTheMonth.conversationStarters.forEach(
            (String conversationStarter) {
              conversationStarters.add(
                Padding(
                  padding: EdgeInsets.fromLTRB(20, 0, 20, 20),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: Text(
                          String.fromCharCode(0x2022),
                        ),
                      ),
                      Expanded(
                        flex: 12,
                        child: Text(
                          '$conversationStarter',
                          style: TextStyle(
                            color: COLOR_NAVY,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              );
            },
          );

          return Scaffold(
            key: _scaffoldKey,
            body: AnnotatedRegion<SystemUiOverlayStyle>(
              value: SystemUiOverlayStyle.light,
              child: Container(
                width: screenWidth,
                height: screenHeight,
                color: COLOR_CREAM,
                child: SafeArea(
                  child: ListView(
                    children: [
                      AppBarWidget(title: 'Book of The Month'),
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                        'This content is provided courtesy of',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: COLOR_NAVY,
                          fontStyle: FontStyle.italic,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Image.asset(
                        ASSET_dayton_metro_library_logo,
                        height: 100,
                      ),
                      Divider(),
                      SizedBox(
                        height: 20,
                      ),
                      Align(
                        alignment: Alignment.center,
                        child: Container(
                          child: Image.asset(
                            bookOfTheMonth.assetImagePath,
                            fit: BoxFit.contain,
                          ),
                          height: 200,
                          width: 200,
                          decoration: BoxDecoration(
                            color: COLOR_CREAM,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.7),
                                spreadRadius: 5,
                                blurRadius: 7,
                                offset:
                                    Offset(0, 3), // changes position of shadow
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                        '${bookOfTheMonth.title}',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        'by ${bookOfTheMonth.author}',
                        textAlign: TextAlign.center,
                      ),
                      Divider(),
                      Padding(
                        padding: EdgeInsets.only(
                          left: 20,
                          right: 20,
                        ),
                        child: Text(
                          '${bookOfTheMonth.summary}',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: COLOR_NAVY,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Divider(),
                      Align(
                        alignment: Alignment.center,
                        child: Container(
                          margin: EdgeInsets.only(top: 20),
                          height: 200,
                          width: screenWidth * 0.9,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(10),
                                topRight: Radius.circular(10),
                                bottomLeft: Radius.circular(10),
                                bottomRight: Radius.circular(10)),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.5),
                                spreadRadius: 5,
                                blurRadius: 7,
                                offset:
                                    Offset(0, 3), // changes position of shadow
                              ),
                            ],
                          ),
                          child: InkWell(
                            onTap: () {
                              locator<ModalService>().showAlert(
                                context: context,
                                title: 'To Do',
                                message: 'Play Video',
                              );
                            },
                            child: Stack(
                              children: [
                                Image.network(
                                  'https://goodereader.com/blog/uploads/images/AdobeStock_118516528-e1559744022425.jpeg',
                                  fit: BoxFit.fitWidth,
                                  width: screenWidth * 0.9,
                                ),
                                Center(
                                  child: Image.asset(
                                    ASSET_play_button,
                                    height: 50,
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                      Divider(),
                      Padding(
                        padding: EdgeInsets.all(20),
                        child: Text(
                          'Conversation Starters:',
                          style: TextStyle(
                            color: COLOR_NAVY,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Column(
                        children: conversationStarters,
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
    locator<ModalService>()
        .showInSnackBar(scaffoldKey: _scaffoldKey, message: message);
  }
}
