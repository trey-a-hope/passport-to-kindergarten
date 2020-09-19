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
import 'Bloc.dart';

class BookOfTheMonthPage extends StatefulWidget {
  @override
  State createState() => BookOfTheMonthPageState();
}

class BookOfTheMonthPageState extends State<BookOfTheMonthPage>
    implements BookOfTheMonthDelegate {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  BookOfTheMonthBloc _bookOfTheMonthBloc;

  @override
  void initState() {
    _bookOfTheMonthBloc = BlocProvider.of<BookOfTheMonthBloc>(context);
    _bookOfTheMonthBloc.setDelegate(delegate: this);
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BookOfTheMonthBloc, BookOfTheMonthState>(
      builder: (BuildContext context, BookOfTheMonthState state) {
        if (state is LoadingState) {
          return Container(
            color: Colors.white,
            child: SpinnerWidget(),
          );
        }

        if (state is LoadedState) {
          return Scaffold(
            key: _scaffoldKey,
            appBar: AppBar(
              title: Text('Book of The Month'),
            ),
            drawer: DrawerWidget(
              currentUser: state.user,
              page: APP_PAGES.BOOK_OF_THE_MONTH,
            ),
            body: AnnotatedRegion<SystemUiOverlayStyle>(
              value: SystemUiOverlayStyle.light,
              child: GridView.builder(
                itemCount: BOOKS_OF_THE_MONTH.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
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
                            colorFilter: ColorFilter.mode(
                                Colors.black.withOpacity(0.3),
                                BlendMode.darken),
                            fit: BoxFit.cover,
                            image: NetworkImage('${bookOfTheMonth.imgUrl}'),
                          ),
                          color: Colors.green,
                          borderRadius: BorderRadius.all(
                            Radius.circular(20),
                          ),
                        ),
                        child: Center(
                          child: Text(
                            '${bookOfTheMonth.title}',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                      onTap: () {
                        print('hit');
                      },
                    ),
                  );
                },
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
