part of 'super_admin_bloc.dart';

class SuperAdminView extends StatefulWidget {
  @override
  State createState() => SuperAdminViewState();
}

class SuperAdminViewState extends State<SuperAdminView> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: colorOrange,
        title: Text('Super Admin'),
      ),
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: Container(
          width: screenWidth,
          height: screenHeight,
          color: colorCream,
          child: SafeArea(
            child: BlocConsumer<SuperAdminBloc, SuperAdminState>(
              listener: (context, state) {
                if (state is ErrorState) {
                  print(state.error.toString());
                }
              },
              builder: (BuildContext context, SuperAdminState state) {
                if (state is LoadingState) {
                  final String text = state.text;
                  return Container(
                    child: SpinnerWidget(text: text),
                  );
                }

                if (state is LoadedState) {
                  final List<BookModel> booksOfTheMonth = state.booksOfTheMonth;
                  final Map<UserModel, List<UserModel>> teacherStudentMap =
                      state.teacherStudentMap;

                  return DefaultTabController(
                    length: 2,
                    child: Scaffold(
                      appBar: TabBar(
                        tabs: [
                          Tab(
                            child: Text(
                              'Books Of The Month',
                              style: TextStyle(
                                color: Colors.black,
                              ),
                            ),
                          ),
                          Tab(
                            child: Text(
                              'Generate Reports',
                              style: TextStyle(
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ],
                      ),
                      key: _scaffoldKey,
                      body: TabBarView(
                        children: [
                          ListView.builder(
                            shrinkWrap: true,
                            itemCount: booksOfTheMonth.length,
                            itemBuilder: (context, index) {
                              final BookModel bookOfTheMonth =
                                  booksOfTheMonth[index];
                              return SwitchListTile(
                                secondary:
                                    Image.network('${bookOfTheMonth.imgUrl}'),
                                title: Text('${bookOfTheMonth.title}'),
                                value: bookOfTheMonth.given,
                                onChanged: (bool newValue) {
                                  context.read<SuperAdminBloc>().add(
                                        UpdateBookGivenEvent(
                                          bookID: bookOfTheMonth.id,
                                          given: newValue,
                                        ),
                                      );
                                  setState(() {
                                    bookOfTheMonth.given = newValue;
                                  });
                                },
                              );
                            },
                          ),
                          ListView.builder(
                            shrinkWrap: true,
                            itemCount: teacherStudentMap.keys.length,
                            itemBuilder: (context, index) {
                              final UserModel teacher =
                                  teacherStudentMap.keys.elementAt(index);

                              final List<UserModel> students =
                                  teacherStudentMap[teacher];

                              return ListTile(
                                title: Text(
                                    '${teacher.firstName} ${teacher.lastName}'),
                                subtitle: Text('${students.length} students'),
                                trailing: students.isEmpty
                                    ? SizedBox.shrink()
                                    : ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          primary: colorOrange,
                                          textStyle:
                                              TextStyle(color: Colors.white),
                                        ),
                                        child: Text('Generate'),
                                        onPressed: () async {
                                          final bool confirm = await locator<
                                                  ModalService>()
                                              .showConfirmation(
                                                  context: context,
                                                  title:
                                                      'Generate Report for ${teacher.firstName} ${teacher.lastName}',
                                                  message: 'Are you sure?');

                                          if (!confirm) return;

                                          context.read<SuperAdminBloc>().add(
                                                GenerateReportEvent(
                                                  teacher: teacher,
                                                  students: students,
                                                ),
                                              );
                                        },
                                      ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                }

                if (state is ErrorState) {
                  return Center(
                    child: Text(
                      state.error.toString(),
                    ),
                  );
                }

                return Container();
              },
            ),
          ),
        ),
      ),
    );
  }
}
