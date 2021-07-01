import 'package:flutter/material.dart';
import 'package:p/pdf_view.dart';
import 'package:p/services/ModalService.dart';
import 'package:p/widgets/AppBarWidget.dart';
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
      body: Container(
        width: screenWidth,
        height: screenHeight,
        color: Colors.grey.shade200,
        child: SafeArea(
          child: Column(
            children: [
              AppBarWidget(title: 'Settings'),
              Expanded(
                child: SettingsList(
                  sections: [
                    SettingsSection(
                      title: 'Personal',
                      tiles: [
                        SettingsTile(
                          title: 'Notifications',
                          leading: Icon(Icons.person),
                          onPressed: (context) {
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
                    SettingsSection(
                      title: 'Information',
                      tiles: [
                        SettingsTile(
                          title: 'Privacy Policy',
                          leading: Icon(Icons.policy),
                          onPressed: (context) async {
                            Route route = MaterialPageRoute(
                              builder: (BuildContext context) => PDFView(
                                assetPath: PRIVACY_POLICY_PATH,
                                appBarTitle: 'Privacy Policy',
                              ),
                            );

                            Navigator.push(context, route);
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
