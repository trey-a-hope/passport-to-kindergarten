import 'package:flutter/material.dart';
import 'package:p/models/UserModel.dart';
import 'package:p/services/ModalService.dart';
import 'package:p/widgets/DrawerWidget.dart';
import 'package:settings_ui/settings_ui.dart';

import 'ServiceLocator.dart';
import 'constants.dart';

class SettingsPage extends StatelessWidget {
  SettingsPage({Key key, @required this.currentUser}) : super(key: key);
  final UserModel currentUser;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final Color _iconChevronColor = Colors.grey;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: DrawerWidget(
        currentUser: currentUser,
        page: APP_PAGES.SETTINGS,
      ),
      backgroundColor: Colors.grey.shade200,
      appBar: AppBar(
        title: Text(
          'Settings',
        ),
      ),
      body: SettingsList(
        sections: [
          SettingsSection(
            title: 'Personal',
            tiles: [
              SettingsTile(
                title: 'Notifications',
                leading: Icon(Icons.person),
                onTap: () {
                  locator<ModalService>().showAlert(
                    context: context,
                    title: 'Notifications Clicked',
                    message: 'Coming soon...',
                  );
                },
                trailing: Icon(
                  Icons.chevron_right,
                  color: _iconChevronColor,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
