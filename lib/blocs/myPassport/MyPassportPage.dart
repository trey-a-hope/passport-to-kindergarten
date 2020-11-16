import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:intl/intl.dart';
import 'package:p/constants.dart';
import 'package:p/models/UserModel.dart';
import 'package:p/services/ModalService.dart';
import 'package:p/widgets/AppBarWidget.dart';
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
            body: AnnotatedRegion<SystemUiOverlayStyle>(
              value: const SystemUiOverlayStyle(statusBarColor: Colors.red),
              child: Container(
                width: screenWidth,
                height: screenHeight,
                color: COLOR_CREAM,
                child: SafeArea(
                  child: ListView(
                    children: [
                      AppBarWidget(title: 'My Passport'),
                      Padding(
                        padding: EdgeInsets.all(20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              width: 120,
                              height: 120,
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: COLOR_ORANGE,
                                  width: 5,
                                ),
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              child: Image.network(child.imgUrl),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Column(
                              children: [
                                Text(
                                  'Primary Parent Name',
                                  style: TextStyle(color: COLOR_NAVY),
                                ),
                                Text(
                                  '${child.primaryParentFirstName} ${child.primaryParentLastName}',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: COLOR_NAVY,
                                      fontSize: 18),
                                ),
                                Divider(),
                                Text(
                                  'Secondary Parent Name',
                                  style: TextStyle(color: COLOR_NAVY),
                                ),
                                Text(
                                  '${child.secondaryParentFirstName} ${child.secondaryParentFirstName}',
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
                                  DateFormat('MMMM dd, yyyy').format(child.dob),
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: COLOR_NAVY,
                                      fontSize: 18),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(20),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Divider(),
                            Text(
                              'Teacher Name',
                              style: TextStyle(color: COLOR_NAVY),
                              textAlign: TextAlign.start,
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
                      Image.asset(
                        ASSET_p2k20_app_dotted_line,
                        width: screenWidth,
                      ),
                      Padding(
                        padding: EdgeInsets.all(10),
                        child: Row(
                          children: [
                            Text(
                              'Stamps',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: COLOR_NAVY,
                                  fontSize: 21),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child: Expanded(
                          child: StaggeredGridView.countBuilder(
                            shrinkWrap: true,
                            crossAxisCount: 4,
                            itemCount: stamps.length,
                            itemBuilder: (BuildContext context, int index) {
                              return stamps[index];
                            },
                            staggeredTileBuilder: (int index) =>
                                StaggeredTile.count(2, index.isEven ? 2 : 1),
                            mainAxisSpacing: 4.0,
                            crossAxisSpacing: 4.0,
                          ),
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
