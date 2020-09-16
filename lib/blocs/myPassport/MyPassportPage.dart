import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:p/constants.dart';
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
            appBar: AppBar(
              title: Text('My Passport'),
            ),
            drawer: DrawerWidget(
              currentUser: child,
              page: APP_PAGES.MY_PASSPORT,
            ),
            body: AnnotatedRegion<SystemUiOverlayStyle>(
              value: SystemUiOverlayStyle.light,
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.all(20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Type: Preschool',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text(
                          'Passport Number: 2019-2020',
                          style: TextStyle(fontWeight: FontWeight.bold),
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
                              Text('Parent Name'),
                              Text(
                                '${child.parentFirstName} ${child.parentLastName}',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 18),
                              ),
                              Divider(),
                              Text('Child Name'),
                              Text(
                                '${child.firstName} ${child.lastName}',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 18),
                              ),
                              Divider(),
                              Text('Child DOB'),
                              Text(
                                DateFormat('MMMM dd, yyyy').format(child.dob),
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 18),
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
                        Text('Teacher Name'),
                        Text(
                          '${teacher.firstName} ${teacher.lastName}',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 18),
                        ),
                        Divider(),
                        Text('School'),
                        Text(
                          '${teacher.school}',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 18),
                        ),
                        Divider(),
                      ],
                    ),
                  ),
                  Text(
                    'Stamps',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Expanded(
                    child: ListView.separated(
                      separatorBuilder: (BuildContext context, int index) {
                        return Divider();
                      },
                      itemCount: stamps.length,
                      itemBuilder: (BuildContext context, int index) {
                        final StampModel stamp = stamps[index];

                        return ListTile(
                          leading: CircleAvatar(
                            backgroundImage:
                                NetworkImage(DUMMY_PROFILE_PHOTO_URL),
                          ),
                          title: Text(stamp.name),
                          subtitle: Text(
                              'Received: ${DateFormat('MMMM dd, yyyy').format(child.dob)}'),
                          trailing: Icon(Icons.chevron_right),
                          onTap: () {
                            locator<ModalService>().showAlert(
                              context: context,
                              title: 'Stamp Clicked',
                              message: 'Open ${stamp.name}',
                            );
                          },
                        );
                      },
                    ),
                  )
                ],
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
        .showAlert(context: context, title: 'Error', message: message);
  }
}
