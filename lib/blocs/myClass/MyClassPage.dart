import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:p/ServiceLocator.dart';
import 'package:p/constants.dart';
import 'package:p/models/UserModel.dart';
import 'package:p/services/ModalService.dart';
import 'package:p/services/ValidatorService.dart';
import 'package:p/widgets/FullWidthButtonWidget.dart';
import 'package:p/widgets/SpinnerWidget.dart';
import 'Bloc.dart';

class MyClassPage extends StatefulWidget {
  @override
  State createState() => MyClassPageState();
}

class MyClassPageState extends State<MyClassPage>
    implements MyClassBlocDelegate {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  MyClassBloc _myClassBloc;
  final TextEditingController _titleConController = TextEditingController();
  final TextEditingController _authorConController = TextEditingController();

  @override
  void initState() {
    _myClassBloc = BlocProvider.of<MyClassBloc>(context);
    _myClassBloc.setDelegate(delegate: this);
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;

    return BlocBuilder<MyClassBloc, MyClassState>(
      builder: (BuildContext context, MyClassState state) {
        if (state is LoadingState) {
          return Container(
            color: Colors.white,
            child: SpinnerWidget(),
          );
        }

        if (state is LoadedState) {
          final UserModel currentUser = state.user;
          final List<UserModel> students = state.students;

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
                                'My Class',
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
                          'Tap a student\'s  name to see a list of their Passport stamps and to log reading or partner visits.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: COLOR_NAVY,
                            fontWeight: FontWeight.bold,
                            fontSize: 21,
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
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Type: Preschool',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: COLOR_NAVY),
                            ),
                            Text(
                              'Passport Number: 2020-2021',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: COLOR_NAVY),
                            )
                          ],
                        ),
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
                      Padding(
                        padding: EdgeInsets.all(10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              'ABC Child Development Center',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: COLOR_NAVY),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: ListView.builder(
                          itemCount: students.length,
                          itemBuilder: (BuildContext context, int index) {
                            final UserModel student = students[index];

                            return ExpansionTile(
                              backgroundColor: COLOR_NAVY,
                              leading: CircleAvatar(
                                backgroundImage: NetworkImage(
                                  '${student.imgUrl}',
                                ),
                              ),
                              title: Text(
                                '${student.firstName} ${student.lastName}',
                              ),
                              trailing: Icon(Icons.chevron_right),
                              children: [
                                ExpansionTile(
                                  backgroundColor: Colors.white,
                                  title: Text(
                                    'List of passport stamps',
                                    style: TextStyle(
                                      color: Colors.white,
                                    ),
                                  ),
                                  children: [
                                    Container(
                                      height: 300,
                                      child: StaggeredGridView.countBuilder(
                                        crossAxisCount: 4,
                                        itemCount: stamps.length,
                                        itemBuilder:
                                            (BuildContext context, int index) {
                                          return stamps[index];
                                        },
                                        staggeredTileBuilder: (int index) =>
                                            StaggeredTile.count(
                                                2, index.isEven ? 2 : 1),
                                        mainAxisSpacing: 4.0,
                                        crossAxisSpacing: 4.0,
                                      ),
                                    )
                                  ],
                                ),
                                ExpansionTile(
                                  backgroundColor: COLOR_YELLOW,
                                  title: Text(
                                    'Add a new title',
                                    style: TextStyle(
                                      color: Colors.white,
                                    ),
                                  ),
                                  children: [
                                    Container(
                                      height: 360,
                                      child: Column(
                                        children: [
                                          Text(
                                            'Add a new book that your student hasn\'t already logged here.',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              color: COLOR_NAVY,
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.fromLTRB(
                                                20, 30, 20, 0),
                                            child: TextFormField(
                                              autovalidateMode: AutovalidateMode
                                                  .onUserInteraction,
                                              cursorColor: Colors.black,
                                              validator:
                                                  locator<ValidatorService>()
                                                      .isEmpty,
                                              keyboardType: TextInputType.text,
                                              textInputAction:
                                                  TextInputAction.done,
                                              controller: _titleConController,
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontFamily: 'SFUIDisplay'),
                                              decoration: InputDecoration(
                                                border: OutlineInputBorder(),
                                                labelText: 'Title',
                                                prefixIcon:
                                                    Icon(Icons.speaker_notes),
                                                labelStyle:
                                                    TextStyle(fontSize: 15),
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.fromLTRB(
                                                20, 30, 20, 0),
                                            child: TextFormField(
                                              autovalidateMode: AutovalidateMode
                                                  .onUserInteraction,
                                              cursorColor: Colors.black,
                                              validator:
                                                  locator<ValidatorService>()
                                                      .isEmpty,
                                              keyboardType: TextInputType.text,
                                              textInputAction:
                                                  TextInputAction.done,
                                              controller: _authorConController,
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontFamily: 'SFUIDisplay'),
                                              decoration: InputDecoration(
                                                border: OutlineInputBorder(),
                                                labelText: 'Author',
                                                prefixIcon:
                                                    Icon(Icons.speaker_notes),
                                                labelStyle:
                                                    TextStyle(fontSize: 15),
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            height: 20,
                                          ),
                                          FullWidthButtonWidget(
                                            buttonColor: COLOR_NAVY,
                                            text: 'Add',
                                            textColor: Colors.white,
                                            onPressed: () async {
                                              final bool confirm =
                                                  await locator<ModalService>()
                                                      .showConfirmation(
                                                          context: context,
                                                          title: 'Add Book',
                                                          message:
                                                              'Are you sure?');

                                              if (!confirm) return;

                                              _myClassBloc.add(
                                                CreateBookForStudentEvent(
                                                  studentUID: student.uid,
                                                  title:
                                                      _titleConController.text,
                                                  author:
                                                      _authorConController.text,
                                                ),
                                              );
                                            },
                                          )
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                                ExpansionTile(
                                  title: Text(
                                    'Log a reading',
                                    style: TextStyle(
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                                ExpansionTile(
                                  title: Text(
                                    'Log a visit',
                                    style: TextStyle(
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ],
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

        if (state is ErrorState) {
          return Scaffold(
            backgroundColor: COLOR_CREAM,
            body: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(state.error.toString()),
              ],
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
  }
}
