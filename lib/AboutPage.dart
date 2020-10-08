import 'package:flutter/material.dart';
import 'package:p/models/UserModel.dart';
import 'package:p/services/ModalService.dart';
import 'package:p/widgets/DrawerWidget.dart';
import 'package:settings_ui/settings_ui.dart';

import 'ServiceLocator.dart';
import 'constants.dart';

class AboutPage extends StatelessWidget {
  AboutPage({Key key}) : super(key: key);
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
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
                    'About',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 21,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: ListView(
                  children: [
                    Padding(
                      padding: EdgeInsets.all(20),
                      child: Text(
                        'Welcome to',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: COLOR_NAVY,
                          fontSize: 28,
                        ),
                      ),
                    ),
                    Image.asset(
                      ASSET_IMAGE_P2K_LOGO,
                      height: 100,
                    ),
                    Divider(),
                    Padding(
                      padding: EdgeInsets.all(20),
                      child: RichText(
                        text: TextSpan(
                          style: TextStyle(
                            color: COLOR_NAVY,
                            fontSize: 18,
                          ),
                          children: [
                            TextSpan(
                                text:
                                    'Passport to Kindergarten is a program funded by PNC to help Dayton area preschoolers prepare for kindergarten. The program partners with schools, care centers, community organization, and families to create'),
                            TextSpan(
                              text: ' AWEsome Moments',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            TextSpan(
                                text:
                                    '. AWEsome moments will provide your child with rich experiences to build vocabulary and language skills critical to reading success.')
                          ],
                        ),
                      ),
                    ),
                    Divider(),
                    Padding(
                      padding: EdgeInsets.all(20),
                      child: Column(
                        children: [
                          Text(
                            'There are three key parts of Passort to Kindergarten:',
                            style: TextStyle(
                              fontSize: 18,
                              color: COLOR_NAVY,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(
                            height: 30,
                          ),
                          Row(
                            children: [
                              Expanded(
                                flex: 1,
                                child: Text(
                                  '1.',
                                  style: TextStyle(
                                    color: COLOR_ORANGE,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 9,
                                child: Text(
                                  'Reading aloud at home-monthly books you can share with your child at home and suggestions for questions to ask as you talk with your child.',
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: COLOR_NAVY,
                                  ),
                                ),
                              )
                            ],
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Row(
                            children: [
                              Expanded(
                                flex: 1,
                                child: Text(
                                  '2.',
                                  style: TextStyle(
                                    color: COLOR_ORANGE,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 9,
                                child: Text(
                                  'Preschool-activities during the school day that your child\'s teacher will provide.',
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: COLOR_NAVY,
                                  ),
                                ),
                              )
                            ],
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Row(
                            children: [
                              Expanded(
                                flex: 1,
                                child: Text(
                                  '3.',
                                  style: TextStyle(
                                    color: COLOR_ORANGE,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 9,
                                child: Text(
                                  'Family Events-free special events for you to attend with your child throughout the year.',
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: COLOR_NAVY,
                                  ),
                                ),
                              )
                            ],
                          )
                        ],
                      ),
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
