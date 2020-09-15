import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:p/constants.dart';
import 'package:p/models/UserModel.dart';
import 'package:p/services/AuthService.dart';
import 'package:p/services/ModalService.dart';
import 'package:p/widgets/SpinnerWidget.dart';

import '../ServiceLocator.dart';

class DrawerWidget extends StatefulWidget {
  const DrawerWidget({Key key}) : super(key: key);

  @override
  State createState() => DrawerWidgetState();
}

class DrawerWidgetState extends State<DrawerWidget> {
  final _drawerIconColor = Colors.blueGrey;
  UserModel _currentUser;
  bool _isLoading = true;

  @override
  void initState() {
    load();
    super.initState();
  }

  void load() async {
    _currentUser = await locator<AuthService>().getCurrentUser();

    setState(() {
      _isLoading = false;
    });
  }

  Widget _buildUserAccountsDrawerHeader() {
    return UserAccountsDrawerHeader(
      accountName: Text(
        '${_currentUser.firstName} ${_currentUser.lastName}',
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      accountEmail: Text('Dayton has more to offer...'),
      currentAccountPicture: GestureDetector(
        child: CircleAvatar(
            backgroundImage: NetworkImage(DUMMY_PROFILE_PHOTO_URL),
            backgroundColor: Colors.transparent,
            radius: 10.0),
      ),
      decoration: BoxDecoration(
        color: Colors.black,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: _isLoading
          ? SpinnerWidget(
              text: 'Loading...',
            )
          : Column(
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                _buildUserAccountsDrawerHeader(),
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
                    bool confirm = await locator<ModalService>()
                        .showConfirmation(
                            context: context,
                            title: 'Logout',
                            message: 'Are you sure?');

                    if (!confirm) return;

                    locator<AuthService>().signOut();
                  },
                ),
                SizedBox(
                  height: 40,
                )
              ],
            ),
    );
  }
}
