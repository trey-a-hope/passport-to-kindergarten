import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:p/ServiceLocator.dart';
import 'package:p/constants.dart';
import 'package:p/services/ModalService.dart';
import 'package:p/widgets/AppBarWidget.dart';
import 'package:p/widgets/DrawerWidget.dart';
import 'package:p/widgets/SpinnerWidget.dart';
import 'Bloc.dart';

class AwesomeReadingTipsPage extends StatefulWidget {
  @override
  State createState() => AwesomeReadingTipsPageState();
}

class AwesomeReadingTipsPageState extends State<AwesomeReadingTipsPage>
    implements AwesomeReadingTipsBlocDelegate {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  AwesomeReadingTipsBloc _awesomeReadingTipsBloc;

  @override
  void initState() {
    _awesomeReadingTipsBloc = BlocProvider.of<AwesomeReadingTipsBloc>(context);
    _awesomeReadingTipsBloc.setDelegate(delegate: this);

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AwesomeReadingTipsBloc, AwesomeReadingTipsState>(
      builder: (BuildContext context, AwesomeReadingTipsState state) {
        if (state is LoadingState) {
          return Container(
            color: Colors.white,
            child: SpinnerWidget(),
          );
        }

        if (state is LoadedState) {
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
                      AppBarWidget(title: 'AWEsome Reading Tips'),
                      Padding(
                        padding: EdgeInsets.all(30),
                        child: RichText(
                          text: TextSpan(
                            style: TextStyle(
                              color: COLOR_NAVY,
                              fontSize: 18,
                            ),
                            children: [
                              TextSpan(
                                text:
                                    'To make the most of the time you spend sharing books with your child, pause in your reading to have AWEsome conversations.  Use the acronym ',
                              ),
                              TextSpan(
                                text: 'A.W.E. ',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              TextSpan(text: 'to build your child\'s skills:')
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  flex: 1,
                                  child: Text(
                                    '-',
                                    style: TextStyle(
                                      color: COLOR_ORANGE,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 9,
                                  child: RichText(
                                    text: TextSpan(
                                      style: TextStyle(
                                        color: COLOR_NAVY,
                                        fontSize: 18,
                                      ),
                                      children: [
                                        TextSpan(
                                          text: 'A',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        TextSpan(
                                          text:
                                              'sk questions to get your child thinking and talking.',
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Row(
                              children: [
                                Expanded(
                                  flex: 1,
                                  child: Text(
                                    '-',
                                    style: TextStyle(
                                      color: COLOR_ORANGE,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 9,
                                  child: RichText(
                                    text: TextSpan(
                                      style: TextStyle(
                                        color: COLOR_NAVY,
                                        fontSize: 18,
                                      ),
                                      children: [
                                        TextSpan(
                                          text: 'W',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        TextSpan(
                                          text:
                                              'ait at least 5 seconds to give your child time to respond.',
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Row(
                              children: [
                                Expanded(
                                  flex: 1,
                                  child: Text(
                                    '-',
                                    style: TextStyle(
                                      color: COLOR_ORANGE,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 9,
                                  child: RichText(
                                    text: TextSpan(
                                      style: TextStyle(
                                        color: COLOR_NAVY,
                                        fontSize: 18,
                                      ),
                                      children: [
                                        TextSpan(
                                          text: 'E',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        TextSpan(
                                          text:
                                              'xpand on your child\'s response by repeating what they said and adding a bit more to it.',
                                        ),
                                      ],
                                    ),
                                  ),
                                )
                              ],
                            )
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Padding(
                        padding: EdgeInsets.all(30),
                        child: RichText(
                          text: TextSpan(
                            style: TextStyle(
                              color: COLOR_NAVY,
                              fontSize: 18,
                            ),
                            children: [
                              TextSpan(
                                text: 'AWE',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              TextSpan(
                                  text:
                                      'some moments can happen at any time: when you share a book, take a trip to the Boonshoft Museum of Discovery, play at the park or talk about their day at school.')
                            ],
                          ),
                        ),
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
