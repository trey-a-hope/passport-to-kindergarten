import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:p/AboutPage.dart';
import 'package:p/ServiceLocator.dart';
import 'package:p/constants.dart';
import 'package:p/models/UserModel.dart';
import 'package:p/services/AuthService.dart';
import 'package:p/services/ModalService.dart';
import 'package:p/widgets/SpinnerWidget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../SettingsPage.dart';
import 'Bloc.dart';
import 'package:p/blocs/book_of_the_month/book_of_the_month_bloc.dart'
    as BOOK_OF_THE_MONTH_BP;
import 'package:p/blocs/myPassport/Bloc.dart' as MY_PASSPORT_BP;
import 'package:p/blocs/readingLog/Bloc.dart' as READING_LOG_BP;
import 'package:p/blocs/visitingLog/Bloc.dart' as VISITING_LOG_BP;
import 'package:p/blocs/editProfile/Bloc.dart' as EDIT_PROFILE_BP;
import 'package:p/blocs/awesomeReadingTips/Bloc.dart'
    as AWESOME_READING_TIPS_BP;
import 'package:p/blocs/myClass/Bloc.dart' as MY_CLASS_BP;
import 'package:p/blocs/super_admin/super_admin_bloc.dart' as SUPER_ADMIN_BP;

class MenuPage extends StatefulWidget {
  @override
  State createState() => MenuPageState();
}

class MenuPageState extends State<MenuPage> implements MenuBlocDelegate {
  static GlobalKey myClassGlobalKey = GlobalKey();
  static GlobalKey exploreBookOfTheMonthGlobalKey = GlobalKey();
  static GlobalKey awesomeReadingTipsGlobalKey = GlobalKey();
  static GlobalKey editProfileGlobalKey = GlobalKey();
  static GlobalKey aboutGlobalKey = GlobalKey();
  static GlobalKey myPassportGlobalKey = GlobalKey();
  static GlobalKey logReadingGlobalKey = GlobalKey();
  static GlobalKey logVisitGlobalKey = GlobalKey();

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final double _menuBottomPadding = 50;
  MenuBloc _menuBloc;

  @override
  void initState() {
    _menuBloc = BlocProvider.of<MenuBloc>(context);
    _menuBloc.setDelegate(delegate: this);
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  ListTile myClassListTile() {
    return ListTile(
      leading: Image.asset(
        ASSET_icon_my_passport,
        key: myClassGlobalKey,
        width: 20,
      ),
      title: Text(
        'My Class',
        style: TextStyle(color: Colors.white),
      ),
      onTap: () async {
        Route route = MaterialPageRoute(
          builder: (BuildContext context) => BlocProvider(
            create: (BuildContext context) => MY_CLASS_BP.MyClassBloc()
              ..add(
                MY_CLASS_BP.LoadPageEvent(),
              ),
            child: MY_CLASS_BP.MyClassPage(),
          ),
        );
        Navigator.push(context, route);
      },
    );
  }

  ListTile myPassportListTile() {
    return ListTile(
      leading: Image.asset(
        ASSET_icon_my_passport,
        key: myPassportGlobalKey,
        width: 20,
      ),
      title: Text(
        'My Passport',
        style: TextStyle(color: Colors.white),
      ),
      onTap: () async {
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

  ListTile readingLogListTile() {
    return ListTile(
      leading: Image.asset(
        ASSET_icon_reading_log,
        key: logReadingGlobalKey,
        width: 20,
      ),
      title: Text(
        'Log Reading',
        style: TextStyle(color: Colors.white),
      ),
      onTap: () {
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

  ListTile visitLogListTile() {
    return ListTile(
      leading: Image.asset(
        ASSET_icon_visit_log,
        key: logVisitGlobalKey,
        width: 20,
      ),
      title: Text(
        'Log Visit',
        style: TextStyle(color: Colors.white),
      ),
      onTap: () {
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

  ListTile bookOfTheMonthListTile() {
    return ListTile(
      leading: Image.asset(
        ASSET_icon_book_of_the_month,
        key: exploreBookOfTheMonthGlobalKey,
        height: 20,
      ),
      title: Text(
        'Explore Book of The Month',
        style: TextStyle(color: Colors.white),
      ),
      onTap: () {
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

  ListTile awesomeReadingTipsListTile() {
    return ListTile(
      leading: Image.asset(
        ASSET_icon_awesome_reading_tips,
        key: awesomeReadingTipsGlobalKey,
        width: 20,
      ),
      title: Text(
        'AWEsome Reading Tips',
        style: TextStyle(color: Colors.white),
      ),
      onTap: () {
        Route route = MaterialPageRoute(
          builder: (BuildContext context) => BlocProvider(
            create: (BuildContext context) =>
                AWESOME_READING_TIPS_BP.AwesomeReadingTipsBloc()
                  ..add(
                    AWESOME_READING_TIPS_BP.LoadPageEvent(),
                  ),
            child: AWESOME_READING_TIPS_BP.AwesomeReadingTipsPage(),
          ),
        );
        Navigator.push(context, route);
      },
    );
  }

  ListTile editProfileListTile() {
    return ListTile(
      leading: Image.asset(
        ASSET_icon_edit_profile,
        key: editProfileGlobalKey,
        width: 20,
      ),
      title: Text(
        'Edit Profile',
        style: TextStyle(color: Colors.white),
      ),
      onTap: () {
        Route route = MaterialPageRoute(
          builder: (BuildContext context) => BlocProvider(
            create: (BuildContext context) => EDIT_PROFILE_BP.EditProfileBloc()
              ..add(
                EDIT_PROFILE_BP.LoadPageEvent(),
              ),
            child: EDIT_PROFILE_BP.EditProfilePage(),
          ),
        );
        Navigator.push(context, route);
      },
    );
  }

  ListTile adminListTile() {
    return ListTile(
      leading: Icon(MdiIcons.security, color: Colors.white),
      title: Text(
        'Admin',
        style: TextStyle(color: Colors.white),
      ),
      onTap: () {
        Route route = MaterialPageRoute(
          builder: (BuildContext context) => BlocProvider(
            create: (BuildContext context) => SUPER_ADMIN_BP.SuperAdminBloc()
              ..add(
                SUPER_ADMIN_BP.LoadPageEvent(),
              ),
            child: SUPER_ADMIN_BP.SuperAdminView(),
          ),
        );
        Navigator.push(context, route);
      },
    );
  }

  ListTile aboutListTile() {
    return ListTile(
      leading: Image.asset(
        ASSET_icon_about,
        key: aboutGlobalKey,
        width: 20,
      ),
      title: Text(
        'About',
        style: TextStyle(color: Colors.white),
      ),
      onTap: () {
        Route route = MaterialPageRoute(
          builder: (BuildContext context) => AboutPage(),
        );

        Navigator.push(context, route);
      },
    );
  }

  ListTile settingsListTile() {
    return ListTile(
      leading: Image.asset(
        ASSET_icon_settings,
        width: 20,
      ),
      title: Text(
        'Settings',
        style: TextStyle(color: Colors.white),
      ),
      onTap: () {
        Route route = MaterialPageRoute(
          builder: (BuildContext context) => SettingsPage(),
        );

        Navigator.push(context, route);
      },
    );
  }

  ListTile logOutListTile() {
    return ListTile(
      leading: Icon(MdiIcons.logout, color: Colors.white),
      title: Text(
        'Logout',
        style: TextStyle(
          color: Colors.white,
        ),
      ),
      onTap: () async {
        bool confirm = await locator<ModalService>().showConfirmation(
            context: context, title: 'Logout', message: 'Are you sure?');

        if (!confirm) return;

        await locator<AuthService>().signOut();
        Navigator.of(context).popUntil((route) => route.isFirst);
      },
    );
  }

  ListTile contactListTile() {
    return ListTile(
      title: RichText(
        text: TextSpan(
          style: TextStyle(fontSize: 16),
          children: [
            TextSpan(text: 'Contact us with any questions or concerns at '),
            TextSpan(
              text: COMPANY_EMAIL,
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            TextSpan(text: '\n\nApp Version: $version ($buildNumber)'),
          ],
        ),
      ),
      onTap: () async {
        final Uri emailLaunchUri = Uri(
          scheme: 'mailto',
          path: COMPANY_EMAIL,
          queryParameters: {
            'subject': 'Contact',
          },
        );

        if (await canLaunch(emailLaunchUri.toString())) {
          await launch(emailLaunchUri.toString());
        } else {
          locator<ModalService>().showAlert(
              context: context, title: 'Error', message: 'Could not open url.');
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;

    return BlocBuilder<MenuBloc, MenuState>(
      builder: (BuildContext context, MenuState state) {
        if (state is LoadingState) {
          return Container(
            color: Colors.white,
            child: SpinnerWidget(),
          );
        }

        if (state is TeacherState) {
          final UserModel user = state.user;
          final String greetingMessage = state.greetingMessage;

          return Scaffold(
            key: _scaffoldKey,
            body: AnnotatedRegion<SystemUiOverlayStyle>(
              value: SystemUiOverlayStyle.light,
              child: Container(
                width: screenWidth,
                height: screenHeight,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(ASSET_p2k20_app_blue_background),
                    fit: BoxFit.cover,
                  ),
                ),
                child: SafeArea(
                  child: ListView(
                    children: [
                      Stack(
                        children: [
                          Image.asset(
                            ASSET_p2k20_app_header_bar,
                            width: screenWidth,
                          ),
                          Positioned(
                            child: CircleAvatar(
                              radius: 30,
                              backgroundImage: NetworkImage(
                                user.imgUrl,
                              ),
                            ),
                            left: 20,
                            top: 10,
                          ),
                          Positioned(
                            child: Text(
                              'Good $greetingMessage',
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                            left: 100,
                            top: 20,
                          ),
                          Positioned(
                            child: Text(
                              '${user.firstName} ${user.lastName}',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 18),
                            ),
                            left: 100,
                            top: 40,
                          )
                        ],
                      ),
                      SizedBox(
                        height: _menuBottomPadding,
                      ),
                      myClassListTile(),
                      bookOfTheMonthListTile(),
                      awesomeReadingTipsListTile(),
                      editProfileListTile(),
                      aboutListTile(),
                      settingsListTile(),
                      logOutListTile(),
                      SizedBox(
                        height: _menuBottomPadding,
                      ),
                      contactListTile(),
                      SizedBox(
                        height: _menuBottomPadding,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        }

        if (state is ParentState) {
          final UserModel user = state.user;
          final String greetingMessage = state.greetingMessage;

          return Scaffold(
            key: _scaffoldKey,
            body: AnnotatedRegion<SystemUiOverlayStyle>(
              value: SystemUiOverlayStyle.light,
              child: Container(
                width: screenWidth,
                height: screenHeight,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(ASSET_p2k20_app_blue_background),
                    fit: BoxFit.cover,
                  ),
                ),
                child: SafeArea(
                  child: ListView(
                    children: [
                      Stack(
                        children: [
                          Image.asset(
                            ASSET_p2k20_app_header_bar,
                            width: screenWidth,
                          ),
                          Positioned(
                            child: CircleAvatar(
                              radius: 30,
                              backgroundImage: NetworkImage(
                                user.imgUrl,
                              ),
                            ),
                            left: 20,
                            top: 10,
                          ),
                          Positioned(
                            child: Text(
                              'Good $greetingMessage',
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                            left: 100,
                            top: 20,
                          ),
                          Positioned(
                            child: Text(
                              '${user.firstName} ${user.lastName}',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 18),
                            ),
                            left: 100,
                            top: 40,
                          )
                        ],
                      ),
                      SizedBox(
                        height: _menuBottomPadding,
                      ),
                      myPassportListTile(),
                      readingLogListTile(),
                      visitLogListTile(),
                      bookOfTheMonthListTile(),
                      awesomeReadingTipsListTile(),
                      editProfileListTile(),
                      aboutListTile(),
                      settingsListTile(),
                      logOutListTile(),
                      SizedBox(
                        height: _menuBottomPadding,
                      ),
                      contactListTile(),
                      SizedBox(
                        height: _menuBottomPadding,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        }

        if (state is SuperAdminState) {
          final UserModel user = state.user;
          final String greetingMessage = state.greetingMessage;

          return Scaffold(
            key: _scaffoldKey,
            body: AnnotatedRegion<SystemUiOverlayStyle>(
              value: SystemUiOverlayStyle.light,
              child: Container(
                width: screenWidth,
                height: screenHeight,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(ASSET_p2k20_app_blue_background),
                    fit: BoxFit.cover,
                  ),
                ),
                child: SafeArea(
                  child: ListView(
                    children: [
                      Stack(
                        children: [
                          Image.asset(
                            ASSET_p2k20_app_header_bar,
                            width: screenWidth,
                          ),
                          Positioned(
                            child: CircleAvatar(
                              radius: 30,
                              backgroundImage: NetworkImage(
                                user.imgUrl,
                              ),
                            ),
                            left: 20,
                            top: 10,
                          ),
                          Positioned(
                            child: Text(
                              'Good $greetingMessage',
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                            left: 100,
                            top: 20,
                          ),
                          Positioned(
                            child: Text(
                              '${user.firstName} ${user.lastName}',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 18),
                            ),
                            left: 100,
                            top: 40,
                          )
                        ],
                      ),
                      SizedBox(
                        height: _menuBottomPadding,
                      ),
                      adminListTile(),
                      bookOfTheMonthListTile(),
                      awesomeReadingTipsListTile(),
                      editProfileListTile(),
                      aboutListTile(),
                      settingsListTile(),
                      logOutListTile(),
                      SizedBox(
                        height: _menuBottomPadding,
                      ),
                      contactListTile(),
                      SizedBox(
                        height: _menuBottomPadding,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        }

        if (state is ErrorState) {
          return Scaffold(
            backgroundColor: colorCream,
            body: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(state.error.toString()),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: colorOrange,
                      textStyle: TextStyle(color: Colors.white),
                    ),
                    child: Text('Refresh Page'),
                    onPressed: () {
                      _menuBloc.add(
                        LoadPageEvent(),
                      );
                    },
                  )
                ],
              ),
            ),
          );
        }

        return Container();
      },
    );
  }

  List<TargetFocus> _buildTargetFocusPoints(
      {@required PROFILE_TYPE profileType}) {
    bool isTeacher = profileType.name == PROFILE_TYPE.TEACHER.name;
    bool isParent = profileType.name == PROFILE_TYPE.PARENT.name;
    bool isSuperAdmin = profileType.name == PROFILE_TYPE.SUPER_ADMIN.name;

    List<TargetFocus> targetFocusPoints = [];

    final TargetFocus myClassFocus = TargetFocus(
      enableOverlayTab: true,
      keyTarget: myClassGlobalKey,
      contents: [
        TargetContent(
          align: ContentAlign.bottom,
          child: Container(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  "My Class",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontSize: 20.0),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10.0),
                  child: Text(
                    "View students in your class and run reports.",
                    style: TextStyle(color: Colors.white),
                  ),
                )
              ],
            ),
          ),
        )
      ],
    );

    final TargetFocus exploreBookOfTheMonthFocus = TargetFocus(
      enableOverlayTab: true,
      keyTarget: exploreBookOfTheMonthGlobalKey,
      contents: [
        TargetContent(
          align: ContentAlign.bottom,
          child: Container(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  "Explore Book of The Month",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontSize: 20.0),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10.0),
                  child: Text(
                    "Learn more about this year's books of the month.",
                    style: TextStyle(color: Colors.white),
                  ),
                )
              ],
            ),
          ),
        )
      ],
    );

    final TargetFocus awesomeReadingTipsFocus = TargetFocus(
      enableOverlayTab: true,
      keyTarget: awesomeReadingTipsGlobalKey,
      contents: [
        TargetContent(
          align: ContentAlign.bottom,
          child: Container(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  "AWEsome Reading Tips",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontSize: 20.0),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10.0),
                  child: Text(
                    "Get tips on how to improve your reading experience.",
                    style: TextStyle(color: Colors.white),
                  ),
                )
              ],
            ),
          ),
        )
      ],
    );

    final TargetFocus editProfileFocus = TargetFocus(
      enableOverlayTab: true,
      keyTarget: editProfileGlobalKey,
      contents: [
        TargetContent(
          align: ContentAlign.bottom,
          child: Container(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  "Edit Profile",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontSize: 20.0),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10.0),
                  child: Text(
                    "Update your personal info.",
                    style: TextStyle(color: Colors.white),
                  ),
                )
              ],
            ),
          ),
        )
      ],
    );

    final TargetFocus aboutFocus = TargetFocus(
      enableOverlayTab: true,
      keyTarget: aboutGlobalKey,
      contents: [
        TargetContent(
          align: ContentAlign.bottom,
          child: Container(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  "About",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontSize: 20.0),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10.0),
                  child: Text(
                    "Learn more about Passport to Kindergarten.",
                    style: TextStyle(color: Colors.white),
                  ),
                )
              ],
            ),
          ),
        )
      ],
    );

    final TargetFocus myPassportFocus = TargetFocus(
      enableOverlayTab: true,
      keyTarget: myPassportGlobalKey,
      contents: [
        TargetContent(
          align: ContentAlign.bottom,
          child: Container(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  "My Passport",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontSize: 20.0),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10.0),
                  child: Text(
                    "View child information and stamps they've earned.",
                    style: TextStyle(color: Colors.white),
                  ),
                )
              ],
            ),
          ),
        )
      ],
    );

    final TargetFocus logReadingFocus = TargetFocus(
      enableOverlayTab: true,
      keyTarget: logReadingGlobalKey,
      contents: [
        TargetContent(
          align: ContentAlign.bottom,
          child: Container(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  "Log Reading",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontSize: 20.0),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10.0),
                  child: Text(
                    "Create new entry for reading log.",
                    style: TextStyle(color: Colors.white),
                  ),
                )
              ],
            ),
          ),
        )
      ],
    );
    final TargetFocus logVisitFocus = TargetFocus(
      enableOverlayTab: true,
      keyTarget: logVisitGlobalKey,
      contents: [
        TargetContent(
          align: ContentAlign.bottom,
          child: Container(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  "Log Visit",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontSize: 20.0),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10.0),
                  child: Text(
                    "Create new entry for visiting log.",
                    style: TextStyle(color: Colors.white),
                  ),
                )
              ],
            ),
          ),
        )
      ],
    );
    if (isTeacher) {
      targetFocusPoints.add(myClassFocus);
      targetFocusPoints.add(exploreBookOfTheMonthFocus);
      targetFocusPoints.add(awesomeReadingTipsFocus);
      targetFocusPoints.add(editProfileFocus);
      targetFocusPoints.add(aboutFocus);
    }

    if (isParent) {
      targetFocusPoints.add(myPassportFocus);
      targetFocusPoints.add(logReadingFocus);
      targetFocusPoints.add(logVisitFocus);
      targetFocusPoints.add(exploreBookOfTheMonthFocus);
      targetFocusPoints.add(awesomeReadingTipsFocus);
      targetFocusPoints.add(editProfileFocus);
      targetFocusPoints.add(aboutFocus);
    }

    if (isSuperAdmin) {
      targetFocusPoints.add(exploreBookOfTheMonthFocus);
      targetFocusPoints.add(awesomeReadingTipsFocus);
      targetFocusPoints.add(editProfileFocus);
      targetFocusPoints.add(aboutFocus);
    }

    return targetFocusPoints;
  }

  void _showTutorial({@required PROFILE_TYPE profileType}) async {
    final List<TargetFocus> targets =
        _buildTargetFocusPoints(profileType: profileType);

    TutorialCoachMark tutorial = TutorialCoachMark(
      context,
      targets: targets, // List<TargetFocus>
      colorShadow: Colors.black,
      onFinish: () {
        print("finish");
      },
      onClickTarget: (target) {
        print(target);
      },
    );

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final bool seenTutorial = prefs.getBool('seenTutorial') ?? false;

    if (!seenTutorial) {
      tutorial.show();
      prefs.setBool('seenTutorial', true);
    }
  }

  @override
  void showMessage({String message}) {
    locator<ModalService>().showInSnackBar(context: context, message: message);
  }

  @override
  void showTutorial({PROFILE_TYPE profileType}) {
    _showTutorial(profileType: profileType);
  }
}
