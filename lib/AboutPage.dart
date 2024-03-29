import 'package:flutter/material.dart';
import 'package:p/services/ModalService.dart';
import 'package:p/widgets/AppBarWidget.dart';
import 'package:p/widgets/FullWidthButtonWidget.dart';
import 'package:url_launcher/url_launcher.dart';

import 'ServiceLocator.dart';
import 'constants.dart';

class AboutPage extends StatelessWidget {
  AboutPage({Key key}) : super(key: key);
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: Container(
        width: screenWidth,
        height: screenHeight,
        color: colorCream,
        child: SafeArea(
          child: ListView(
            children: [
              AppBarWidget(title: 'About'),
              Padding(
                padding: EdgeInsets.all(20),
                child: Text(
                  'Welcome to',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: colorNavy,
                    fontSize: 28,
                  ),
                ),
              ),
              Image.asset(
                ASSET_about_page_logos,
                height: 150,
              ),
              Divider(),
              Padding(
                padding: EdgeInsets.all(30),
                child: RichText(
                  text: TextSpan(
                    style: TextStyle(
                      color: colorNavy,
                      fontSize: 18,
                    ),
                    children: [
                      TextSpan(
                        text: 'Passport to Kindergarten ',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextSpan(
                        text:
                            'is an initiative of Dayton-Montgomery County Preschool Promise and is funded by PNC Grow Up Great. It helps Preschoolers get ready for Kindergarten and start school on track.',
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(30, 0, 30, 30),
                child: RichText(
                  text: TextSpan(
                    style: TextStyle(
                      color: colorNavy,
                      fontSize: 18,
                    ),
                    children: [
                      TextSpan(
                        text:
                            'We partner with schools, child care centers, community organizations and families to create ',
                      ),
                      TextSpan(
                        text: 'AWEsome Moments ',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextSpan(
                        text:
                            'that build vocabulary and language skills that are critical to becoming a great reader.',
                      ),
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
                      'Passport to Kindergarten supports children and families by:',
                      style: TextStyle(
                        fontSize: 18,
                        color: colorNavy,
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
                              color: colorNavy,
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 9,
                          child: RichText(
                            text: TextSpan(
                              style: TextStyle(
                                color: colorNavy,
                                fontSize: 18,
                              ),
                              children: [
                                TextSpan(
                                  text:
                                      'Encouraging families to read aloud every day with their child. You\'ll receive ',
                                ),
                                TextSpan(
                                  text: 'FREE books ',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                TextSpan(
                                  text:
                                      'each month and suggested questions to ask your child as you read together.',
                                ),
                              ],
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
                              color: colorOrange,
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 9,
                          child: RichText(
                            text: TextSpan(
                              style: TextStyle(
                                color: colorNavy,
                                fontSize: 18,
                              ),
                              children: [
                                TextSpan(
                                  text: 'Providing ',
                                ),
                                TextSpan(
                                  text: 'FREE activities ',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                TextSpan(
                                  text:
                                      'to your child\'s Preschool for use in the classroom.',
                                ),
                              ],
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
                              color: colorOrange,
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 9,
                          child: RichText(
                            text: TextSpan(
                              style: TextStyle(
                                color: colorNavy,
                                fontSize: 18,
                              ),
                              children: [
                                TextSpan(
                                  text: 'Hosting ',
                                ),
                                TextSpan(
                                  text: 'FREE and fun family events.',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ),
              Divider(),
              Text(
                'Passport to Kindergarten\nis a program managed by',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontStyle: FontStyle.italic,
                  fontWeight: FontWeight.bold,
                  color: colorNavy,
                ),
              ),
              Padding(
                padding: EdgeInsets.all(20),
                child: Image.asset(
                  ASSET_pp_text_logo,
                  height: 100,
                ),
              ),
              Padding(
                padding: EdgeInsets.all(10),
                child: FullWidthButtonWidget(
                  buttonColor: colorNavy,
                  textColor: Colors.white,
                  text: 'Learn More',
                  onPressed: () async {
                    final String url = 'https://www.preschoolpromise.org/';
                    if (await canLaunch(url)) {
                      await launch(url);
                    } else {
                      locator<ModalService>().showAlert(
                          context: context,
                          title: 'Error',
                          message: 'Could not open url.');
                    }
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
