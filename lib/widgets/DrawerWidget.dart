import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:p/constants.dart';
import 'package:p/models/UserModel.dart';
import 'package:p/services/AuthService.dart';
import 'package:p/services/ModalService.dart';
import '../ServiceLocator.dart';
import 'package:p/blocs/myPassport/Bloc.dart' as MY_PASSPORT_BP;
import 'package:p/blocs/home/Bloc.dart' as HOME_BP;

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
        ListTile(
          leading: Icon(MdiIcons.email, color: _drawerIconColor),
          title: Text(
            'Messages',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          onTap: () {
            // Navigator.push(
            //   context,
            //   MaterialPageRoute(
            //     builder: (context) => MessagesPage(),
            //   ),
            // );
          },
        ),
        ListTile(
          leading: Icon(MdiIcons.accountEdit, color: _drawerIconColor),
          title: Text(
            'Edit Profile',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          onTap: () async {},
        ),
        Spacer(),
        ListTile(
          leading: Icon(MdiIcons.logout, color: _drawerIconColor),
          title: Text(
            'Logout',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          onTap: () async {
            bool confirm = await locator<ModalService>().showConfirmation(
                context: context, title: 'Logout', message: 'Are you sure?');

            if (!confirm) return;

            locator<AuthService>().signOut();
          },
        ),
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
        ListTile(
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
        ),
        ListTile(
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
                create: (BuildContext context) =>
                    MY_PASSPORT_BP.MyPassportBloc()
                      ..add(
                        MY_PASSPORT_BP.LoadPageEvent(),
                      ),
                child: MY_PASSPORT_BP.MyPassportPage(),
              ),
            );
            Navigator.push(context, route);
          },
        ),
        Spacer(),
        ListTile(
          leading: Icon(MdiIcons.logout, color: _drawerIconColor),
          title: Text(
            'Logout',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          onTap: () async {
            bool confirm = await locator<ModalService>().showConfirmation(
                context: context, title: 'Logout', message: 'Are you sure?');

            if (!confirm) return;

            locator<AuthService>().signOut();
          },
        ),
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
        ListTile(
          leading: Icon(MdiIcons.email, color: _drawerIconColor),
          title: Text(
            'Messages',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          onTap: () {
            // Navigator.push(
            //   context,
            //   MaterialPageRoute(
            //     builder: (context) => MessagesPage(),
            //   ),
            // );
          },
        ),
        ListTile(
          leading: Icon(MdiIcons.accountEdit, color: _drawerIconColor),
          title: Text(
            'Edit Profile',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          onTap: () async {},
        ),
        Spacer(),
        ListTile(
          leading: Icon(MdiIcons.logout, color: _drawerIconColor),
          title: Text(
            'Logout',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          onTap: () async {
            bool confirm = await locator<ModalService>().showConfirmation(
                context: context, title: 'Logout', message: 'Are you sure?');

            if (!confirm) return;

            locator<AuthService>().signOut();
          },
        ),
        SizedBox(
          height: 40,
        )
      ],
    );
  }
}
