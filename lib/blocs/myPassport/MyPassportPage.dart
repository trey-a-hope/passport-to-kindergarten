import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:p/constants.dart';
import 'package:p/extensions/HexColorExtension.dart';
import 'package:p/models/StampModel.dart';
import 'package:p/models/UserModel.dart';
import 'package:p/services/ModalService.dart';
import 'package:p/widgets/DrawerWidget.dart';
import 'package:p/widgets/SpinnerWidget.dart';
import '../../ServiceLocator.dart';
import 'Bloc.dart';

class MyPassportPage extends StatefulWidget {
  @override
  State createState() => MyPassportPageState();
}

class MyPassportPageState extends State<MyPassportPage>
    with SingleTickerProviderStateMixin
    implements MyPassportBlocDelegate {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  MyPassportBloc _myPassportBloc;

  final List<StampModel> stamps = [
    StampModel(
        id: 'aaa',
        name: 'Visited Dayton Metro Library',
        created: DateTime.now().toString()),
    StampModel(
        id: 'aaa', name: 'Read 15 Books', created: DateTime.now().toString()),
    StampModel(
        id: 'aaa',
        name: 'Visited Boonshoft Museum',
        created: DateTime.now().toString()),
  ];

  @override
  void initState() {
    _myPassportBloc = BlocProvider.of<MyPassportBloc>(context);
    _myPassportBloc.setDelegate(delegate: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return BlocBuilder<MyPassportBloc, MyPassportState>(
      builder: (BuildContext context, MyPassportState state) {
        if (state is LoadingState) {
          return Container(
            color: Colors.white,
            child: SpinnerWidget(),
          );
        }

        if (state is LoadedState) {
          final UserModel child = state.childUser;
          final UserModel teacher = state.teacherUser;

          return Scaffold(
            key: _scaffoldKey,
            drawer: DrawerWidget(
              currentUser: child,
              page: APP_PAGES.MY_PASSPORT,
            ),
            floatingActionButton: FloatingActionButton(
              child: Icon(Icons.menu),
              backgroundColor: Colors.deepOrange,
              onPressed: () {
                locator<ModalService>().showMenu(context: context, user: child);
              },
            ),
            body: AnnotatedRegion<SystemUiOverlayStyle>(
              value: SystemUiOverlayStyle.light,
              child: Container(
                width: screenWidth,
                height: screenHeight,
                color: COLOR_CREAM,
                child: SafeArea(
                  child: Column(
                    children: [
                      Container(
                        width: screenWidth,
                        height: 80,
                        color: Colors.deepOrange,
                        child: Center(
                          child: Text(
                            'My Passport',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 21,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(20),
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
                              'Passport Number: 2019-2020',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: COLOR_NAVY),
                            )
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            CircleAvatar(
                              backgroundImage: NetworkImage(child.imgUrl),
                              radius: 75,
                            ),
                            SizedBox(
                              width: 20,
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Parent Name',
                                    style: TextStyle(color: COLOR_NAVY),
                                  ),
                                  Text(
                                    'JOHN DOE',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: COLOR_NAVY,
                                        fontSize: 18),
                                  ),
                                  Divider(),
                                  Text(
                                    'Child Name',
                                    style: TextStyle(color: COLOR_NAVY),
                                  ),
                                  Text(
                                    '${child.firstName} ${child.lastName}',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: COLOR_NAVY,
                                        fontSize: 18),
                                  ),
                                  Divider(),
                                  Text(
                                    'Child DOB',
                                    style: TextStyle(color: COLOR_NAVY),
                                  ),
                                  Text(
                                    DateFormat('MMMM dd, yyyy')
                                        .format(child.dob),
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: COLOR_NAVY,
                                        fontSize: 18),
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Divider(),
                            Text(
                              'Teacher Name',
                              style: TextStyle(color: COLOR_NAVY),
                            ),
                            Text(
                              '${teacher.firstName} ${teacher.lastName}',
                              style: TextStyle(
                                color: COLOR_NAVY,
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                            Divider(),
                            Text(
                              'School',
                              style: TextStyle(color: COLOR_NAVY),
                            ),
                            Text(
                              '${teacher.school}',
                              style: TextStyle(
                                color: COLOR_NAVY,
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                            Divider(),
                          ],
                        ),
                      ),
                      Text(
                        'Stamps',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: COLOR_NAVY,
                        ),
                      ),
                      Expanded(
                        child: ListView(children: [
                          
                        ],)
                        
                        // ListView.separated(
                        //   separatorBuilder: (BuildContext context, int index) {
                        //     return Divider();
                        //   },
                        //   itemCount: stamps.length,
                        //   itemBuilder: (BuildContext context, int index) {
                        //     final StampModel stamp = stamps[index];

                        //     return ListTile(
                        //       leading: CircleAvatar(
                        //         backgroundImage:
                        //             NetworkImage(DUMMY_PROFILE_PHOTO_URL),
                        //       ),
                        //       title: Text(stamp.name),
                        //       subtitle: Text(
                        //           'Received: ${DateFormat('MMMM dd, yyyy').format(child.dob)}'),
                        //       trailing: Icon(Icons.chevron_right),
                        //       onTap: () {
                        //         locator<ModalService>().showAlert(
                        //           context: context,
                        //           title: 'Stamp Clicked',
                        //           message: 'Open ${stamp.name}',
                        //         );
                        //       },
                        //     );
                        //   },
                        // ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          );
        }

        if (state is ErrorState) {
          return Container(
            color: Colors.white,
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
        .showAlert(context: context, title: 'Error', message: message);
  }
}
