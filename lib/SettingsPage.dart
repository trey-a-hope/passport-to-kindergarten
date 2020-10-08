import 'package:flutter/material.dart';
import 'package:p/models/UserModel.dart';
import 'package:p/services/ModalService.dart';
import 'package:p/widgets/DrawerWidget.dart';
import 'package:settings_ui/settings_ui.dart';

import 'ServiceLocator.dart';
import 'constants.dart';

class SettingsPage extends StatelessWidget {
  SettingsPage({Key key}) : super(key: key);
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final Color _iconChevronColor = Colors.grey;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black),
        backgroundColor: COLOR_CREAM,
      ),
      body: Container(
        width: screenWidth,
        height: screenHeight,
        color: COLOR_CREAM,
        child: SafeArea(
          child: Column(
            children: [
              Container(
                width: screenWidth,
                height: 80,
                color: COLOR_ORANGE,
                child: Center(
                  child: Text(
                    'Settings',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 21,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: SettingsList(
                  backgroundColor: COLOR_CREAM,
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
              )
            ],
          ),
        ),
      ),
    );
  }
}
