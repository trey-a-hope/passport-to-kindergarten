import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:p/SettingsPage.dart';
import 'package:p/constants.dart';
import 'package:p/models/UserModel.dart';
import 'package:p/services/AuthService.dart';
import 'package:p/services/ModalService.dart';
import '../ServiceLocator.dart';
import 'package:p/blocs/myPassport/Bloc.dart' as MY_PASSPORT_BP;
import 'package:p/blocs/home/Bloc.dart' as HOME_BP;
import 'package:p/blocs/bookOfTheMonth/Bloc.dart' as BOOK_OF_THE_MONTH_BP;
import 'package:p/blocs/visitingLog/Bloc.dart' as VISITING_LOG_BP;
import 'package:p/blocs/readingLog/Bloc.dart' as READING_LOG_BP;

class DrawerWidget extends StatefulWidget {
  const DrawerWidget({
    Key key,
    @required this.currentUser,
    @required this.page,
  }) : super(key: key);

  final UserModel currentUser;
  final APP_PAGES page;
  @override
  State createState() => DrawerWidgetState(
        currentUser: currentUser,
        page: page,
      );
}

class DrawerWidgetState extends State<DrawerWidget> {
  DrawerWidgetState({
    @required this.currentUser,
    @required this.page,
  });

  final _drawerIconColor = Colors.blueGrey;
  final UserModel currentUser;
  final APP_PAGES page;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: _buildLayout(),
    );
  }

  Widget _buildLayout() {
    if (currentUser.profileType == PROFILE_TYPE.TEACHER.name)
      return _buildTeacherLayout();
    else if (currentUser.profileType == PROFILE_TYPE.PARENT.name)
      return _buildParentLayout();
    else if (currentUser.profileType == PROFILE_TYPE.ADMIN.name)
      return _buildSuperAdminLayout();
    else
      return Container();
  }

  void logout() async {
    bool confirm = await locator<ModalService>().showConfirmation(
        context: context, title: 'Logout', message: 'Are you sure?');

    if (!confirm) return;

    Navigator.popUntil(
      context,
      ModalRoute.withName(Navigator.defaultRouteName),
    );
    locator<AuthService>().signOut();
  }

  ListTile _homeListTile() {
    return ListTile(
      leading: Icon(
        Icons.home,
        color: _drawerIconColor,
      ),
      title: Text(
        'Home',
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      onTap: () async {
        if (page == APP_PAGES.HOME) return;

        Route route = MaterialPageRoute(
          builder: (BuildContext context) => BlocProvider(
            create: (BuildContext context) => HOME_BP.HomeBloc()
              ..add(
                HOME_BP.LoadPageEvent(),
              ),
            child: HOME_BP.HomePage(),
          ),
        );
        Navigator.push(context, route);
      },
    );
  }

  ListTile _bookOfTheMonthListTile() {
    return ListTile(
      leading: Icon(Icons.book, color: _drawerIconColor),
      title: Text(
        'Book of The Month',
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      onTap: () {
        if (page == APP_PAGES.BOOK_OF_THE_MONTH) return;

        Route route = MaterialPageRoute(
          builder: (BuildContext context) => BlocProvider(
            create: (BuildContext context) =>
                BOOK_OF_THE_MONTH_BP.BookOfTheMonthBloc()
                  ..add(
                    BOOK_OF_THE_MONTH_BP.LoadPageEvent(),
                  ),
            child: BOOK_OF_THE_MONTH_BP.BookOfTheMonthPage(),
          ),
        );
        Navigator.push(context, route);
      },
    );
  }

  ListTile _myPassportListTile() {
    return ListTile(
      leading: Icon(
        Icons.person,
        color: _drawerIconColor,
      ),
      title: Text(
        'My Passport',
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      onTap: () async {
        if (page == APP_PAGES.MY_PASSPORT) return;

        Route route = MaterialPageRoute(
          builder: (BuildContext context) => BlocProvider(
            create: (BuildContext context) => MY_PASSPORT_BP.MyPassportBloc()
              ..add(
                MY_PASSPORT_BP.LoadPageEvent(),
              ),
            child: MY_PASSPORT_BP.MyPassportPage(),
          ),
        );
        Navigator.push(context, route);
      },
    );
  }

  ListTile _readingLogListTile() {
    return ListTile(
      leading: Icon(Icons.bookmark, color: _drawerIconColor),
      title: Text(
        'Read Log',
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      onTap: () {
        if (page == APP_PAGES.READ_LOG) return;

        Route route = MaterialPageRoute(
          builder: (BuildContext context) => BlocProvider(
            create: (BuildContext context) => READING_LOG_BP.ReadingLogBloc()
              ..add(
                READING_LOG_BP.LoadPageEvent(),
              ),
            child: READING_LOG_BP.ReadingLogPage(),
          ),
        );
        Navigator.push(context, route);
      },
    );
  }

  ListTile _visitingLogListTile() {
    return ListTile(
      leading: Icon(Icons.location_on, color: _drawerIconColor),
      title: Text(
        'Visit Log',
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      onTap: () {
        if (page == APP_PAGES.VISIT_LOG) return;

        Route route = MaterialPageRoute(
          builder: (BuildContext context) => BlocProvider(
            create: (BuildContext context) => VISITING_LOG_BP.VisitingLogBloc()
              ..add(
                VISITING_LOG_BP.LoadPageEvent(),
              ),
            child: VISITING_LOG_BP.VisitingLogPage(),
          ),
        );
        Navigator.push(context, route);
      },
    );
  }

  ListTile _settingsListTile() {
    return ListTile(
      leading: Icon(Icons.settings, color: _drawerIconColor),
      title: Text(
        'Settings',
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      onTap: () {
        if (page == APP_PAGES.SETTINGS) return;

        Route route = MaterialPageRoute(
          builder: (BuildContext context) => SettingsPage(
            currentUser: currentUser,
          ),
        );

        Navigator.push(context, route);
      },
    );
  }

  ListTile _logOutListTile() {
    return ListTile(
      leading: Icon(MdiIcons.logout, color: _drawerIconColor),
      title: Text(
        'Logout',
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      onTap: logout,
    );
  }

  Widget _buildTeacherLayout() {
    return Column(
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        UserAccountsDrawerHeader(
          accountName: Text(
            '${currentUser.firstName} ${currentUser.lastName}',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          accountEmail: Text('Teacher'),
          currentAccountPicture: GestureDetector(
            child: CircleAvatar(
                backgroundImage: NetworkImage(DUMMY_PROFILE_PHOTO_URL),
                backgroundColor: Colors.transparent,
                radius: 10.0),
          ),
          decoration: BoxDecoration(
            color: Colors.black,
          ),
        ),
        _bookOfTheMonthListTile(),
        _settingsListTile(),
        Spacer(),
        _logOutListTile(),
        SizedBox(
          height: 40,
        )
      ],
    );
  }

  Widget _buildParentLayout() {
    return Column(
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        UserAccountsDrawerHeader(
          accountName: Text(
            '${currentUser.firstName} ${currentUser.lastName}',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          accountEmail: Text('Student'),
          currentAccountPicture: GestureDetector(
            child: CircleAvatar(
                backgroundImage: NetworkImage(DUMMY_PROFILE_PHOTO_URL),
                backgroundColor: Colors.transparent,
                radius: 10.0),
          ),
          decoration: BoxDecoration(
            color: Colors.black,
          ),
        ),
        _homeListTile(),
        _bookOfTheMonthListTile(),
        _myPassportListTile(),
        _readingLogListTile(),
        _visitingLogListTile(),
        _settingsListTile(),
        Spacer(),
        _logOutListTile(),
        SizedBox(
          height: 40,
        )
      ],
    );
  }

  Widget _buildSuperAdminLayout() {
    return Column(
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        UserAccountsDrawerHeader(
          accountName: Text(
            '${currentUser.firstName} ${currentUser.lastName}',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          accountEmail: Text('Super Admin'),
          currentAccountPicture: GestureDetector(
            child: CircleAvatar(
                backgroundImage: NetworkImage(DUMMY_PROFILE_PHOTO_URL),
                backgroundColor: Colors.transparent,
                radius: 10.0),
          ),
          decoration: BoxDecoration(
            color: Colors.black,
          ),
        ),
        _settingsListTile(),
        Spacer(),
        _logOutListTile(),
        SizedBox(
          height: 40,
        )
      ],
    );
  }
}
