import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:getwidget/getwidget.dart';
import 'package:p/ServiceLocator.dart';
import 'package:p/constants.dart';
import 'package:p/models/BookOfTheMonthModel.dart';
import 'package:p/services/ModalService.dart';
import 'package:p/widgets/DrawerWidget.dart';
import 'package:p/widgets/SpinnerWidget.dart';
import 'Bloc.dart' as BOOK_OF_THE_MONTH_BP;
import 'package:p/blocs/bookOfTheMonthDetails/Bloc.dart'
    as BOOK_OF_THE_MONTH_DETAILS_BP;

class BookOfTheMonthPage extends StatefulWidget {
  @override
  State createState() => BookOfTheMonthPageState();
}

class BookOfTheMonthPageState extends State<BookOfTheMonthPage>
    implements BOOK_OF_THE_MONTH_BP.BookOfTheMonthDelegate {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  BOOK_OF_THE_MONTH_BP.BookOfTheMonthBloc _bookOfTheMonthBloc;

  @override
  void initState() {
    _bookOfTheMonthBloc =
        BlocProvider.of<BOOK_OF_THE_MONTH_BP.BookOfTheMonthBloc>(context);
    _bookOfTheMonthBloc.setDelegate(delegate: this);
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BOOK_OF_THE_MONTH_BP.BookOfTheMonthBloc,
        BOOK_OF_THE_MONTH_BP.BookOfTheMonthState>(
      builder: (BuildContext context,
          BOOK_OF_THE_MONTH_BP.BookOfTheMonthState state) {
        if (state is BOOK_OF_THE_MONTH_BP.LoadingState) {
          return Container(
            color: Colors.white,
            child: SpinnerWidget(),
          );
        }

        if (state is BOOK_OF_THE_MONTH_BP.LoadedState) {
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
                                'Book of The Month',
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
                          'Tap each icon for a video and reading tips!',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: COLOR_NAVY,
                            fontWeight: FontWeight.bold,
                            fontSize: 21,
                          ),
                        ),
                      ),
                      Expanded(
                        child: GridView.builder(
                          itemCount: BOOKS_OF_THE_MONTH.length,
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2),
                          itemBuilder: (BuildContext context, int index) {
                            final BookOfTheMonthModel bookOfTheMonth =
                                BOOKS_OF_THE_MONTH[index];

                            return Padding(
                              padding: EdgeInsets.all(10),
                              child: InkWell(
                                child: Container(
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                      // colorFilter: ColorFilter.mode(
                                      //     Colors.black.withOpacity(0.3),
                                      //     BlendMode.darken),
                                      fit: BoxFit.fill,
                                      image: Image.asset(
                                              bookOfTheMonth.assetImagePath)
                                          .image,
                                    ),
                                    color: Colors.green,
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(20),
                                    ),
                                  ),
                                  // child: Center(
                                  //   child: Text(
                                  //     '${bookOfTheMonth.title}',
                                  //     style: TextStyle(
                                  //         color: Colors.white,
                                  //         fontWeight: FontWeight.bold),
                                  //     textAlign: TextAlign.center,
                                  //   ),
                                  // ),
                                ),
                                onTap: () {
                                  Route route = MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        BlocProvider(
                                      create: (BuildContext context) =>
                                          BOOK_OF_THE_MONTH_DETAILS_BP
                                              .BookOfTheMonthDetailsBloc()
                                            ..add(
                                              BOOK_OF_THE_MONTH_DETAILS_BP
                                                  .LoadPageEvent(),
                                            ),
                                      child: BOOK_OF_THE_MONTH_DETAILS_BP
                                          .BookOfTheMonthDetailsPage(),
                                    ),
                                  );
                                  Navigator.push(context, route);
                                },
                              ),
                            );
                          },
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          );
        }

        if (state is BOOK_OF_THE_MONTH_BP.ErrorState) {
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
