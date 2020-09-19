import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:p/ServiceLocator.dart';
import 'package:p/services/ModalService.dart';
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
          return Scaffold(
            key: _scaffoldKey,
            appBar: AppBar(
              title: Text('Book of The Month Details'),
            ),
            body: AnnotatedRegion<SystemUiOverlayStyle>(
                value: SystemUiOverlayStyle.light,
                child: Center(
                  child: Text('book 1'),
                )),
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
