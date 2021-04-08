import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:p/ServiceLocator.dart';
import 'package:p/blocs/student_details/student_details_bloc.dart';
import 'package:p/constants.dart';
import 'package:p/models/UserModel.dart';
import 'package:p/services/ModalService.dart';
import 'package:p/widgets/AppBarWidget.dart';
import 'package:p/widgets/SpinnerWidget.dart';
import 'package:table_calendar/table_calendar.dart';
import 'Bloc.dart';

class MyClassPage extends StatefulWidget {
  @override
  State createState() => MyClassPageState();
}

class MyClassPageState extends State<MyClassPage>
    implements MyClassBlocDelegate {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final TextEditingController _titleConController = TextEditingController();
  final TextEditingController _authorConController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  CalendarController _calendarController = CalendarController();
  MyClassBloc _myClassBloc;

  @override
  void initState() {
    _myClassBloc = BlocProvider.of<MyClassBloc>(context);
    _myClassBloc.setDelegate(delegate: this);
    super.initState();
  }

  @override
  void dispose() {
    _calendarController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;

    return BlocBuilder<MyClassBloc, MyClassState>(
      builder: (BuildContext context, MyClassState state) {
        if (state is LoadingState) {
          final String text = state.text;
          return Container(
            color: Colors.white,
            child: SpinnerWidget(
              text: text,
            ),
          );
        }

        if (state is LoadedState) {
          final UserModel currentUser = state.user;
          final List<UserModel> students = state.students;
          final List<String> visitIDs = state.visitsIDs;
          final List<String> bookOfTheMonthIDs = state.booksOfTheMonthIDs;

          return Scaffold(
            key: _scaffoldKey,
            floatingActionButton: FloatingActionButton(
              backgroundColor: COLOR_NAVY,
              child: Icon(Icons.note),
              onPressed: () async {
                final bool confirm =
                    await locator<ModalService>().showConfirmation(
                  context: context,
                  title: 'Generate Report?',
                  message:
                      'This will list all books, visits, and stamps for all students of your class.',
                );

                if (!confirm) return;

                context.read<MyClassBloc>().add(GenerateClassReportEvent());
              },
            ),
            body: AnnotatedRegion<SystemUiOverlayStyle>(
              value: SystemUiOverlayStyle.light,
              child: Container(
                width: screenWidth,
                height: screenHeight,
                color: COLOR_CREAM,
                child: SafeArea(
                  child: ListView(
                    shrinkWrap: true,
                    children: [
                      AppBarWidget(title: 'My Class'),
                      Column(
                        children: [
                          Padding(
                            padding: EdgeInsets.all(20),
                            child: Text(
                              'Tap a student\'s  name to see a list of their Passport stamps and to log reading or partner visits.',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: COLOR_NAVY,
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                          ),
                          Image.asset(
                            ASSET_p2k20_app_dotted_line,
                            width: screenWidth,
                          ),
                          Padding(
                            padding: EdgeInsets.all(10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  '${currentUser.firstName} ${currentUser.lastName}',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: COLOR_NAVY),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      ListView.builder(
                        shrinkWrap: true,
                        physics: ClampingScrollPhysics(),
                        itemCount: students.length,
                        itemBuilder: (BuildContext context, int index) {
                          final UserModel student = students[index];

                          return ListTile(
                            leading: CircleAvatar(
                              backgroundImage: NetworkImage(
                                '${student.imgUrl}',
                              ),
                            ),
                            title: Text(
                                '${student.firstName} ${student.lastName}'),
                            onTap: () {
                              Route route = MaterialPageRoute(
                                builder: (BuildContext context) => BlocProvider(
                                  create: (BuildContext context) =>
                                      StudentDetailsBloc(
                                    student: student,
                                    visitIDs: visitIDs,
                                    bookOfTheMonthIDs: bookOfTheMonthIDs,
                                  )..add(
                                          StudentDetailsLoadPageEvent(),
                                        ),
                                  child: StudentDetailsPage(),
                                ),
                              );
                              Navigator.push(context, route);
                            },
                            trailing: Icon(Icons.chevron_right),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        }

        if (state is ErrorState) {
          return Scaffold(
            backgroundColor: COLOR_CREAM,
            body: Center(
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
  void clearAddTitleForm() {
    _titleConController.clear();
    _authorConController.clear();
    _formKey.currentState.reset();
  }
}
