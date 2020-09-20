import 'package:flutter/material.dart';
import 'package:p/models/UserModel.dart';
import 'package:p/services/ModalService.dart';
import 'package:p/widgets/DrawerWidget.dart';
import 'package:settings_ui/settings_ui.dart';

import 'ServiceLocator.dart';
import 'constants.dart';

class AboutPage extends StatelessWidget {
  AboutPage({Key key, @required this.currentUser}) : super(key: key);
  final UserModel currentUser;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final Color _iconChevronColor = Colors.grey;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: DrawerWidget(
        currentUser: currentUser,
        page: APP_PAGES.ABOUT,
      ),
      backgroundColor: Colors.grey.shade200,
      appBar: AppBar(
        title: Text(
          'About',
        ),
      ),
      body: Center(
        child: Text('About Page'),
      ),
    );
  }
}
