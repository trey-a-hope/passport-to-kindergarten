import 'package:confetti/confetti.dart';
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
import '../../SettingsPage.dart';
import 'Bloc.dart';
import 'package:p/blocs/bookOfTheMonth/Bloc.dart' as BOOK_OF_THE_MONTH_BP;
import 'package:p/blocs/myPassport/Bloc.dart' as MY_PASSPORT_BP;
import 'package:p/blocs/home/Bloc.dart' as HOME_BP;
import 'package:p/blocs/bookOfTheMonth/Bloc.dart' as BOOK_OF_THE_MONTH_BP;
import 'package:p/blocs/visitingLog/Bloc.dart' as VISITING_LOG_BP;
import 'package:p/blocs/readingLogBooks/Bloc.dart' as READING_LOG_BOOKS_BP;
import 'package:p/blocs/admin/Bloc.dart' as ADMIN_LOG_BP;
import 'package:p/blocs/editProfile/Bloc.dart' as EDIT_PROFILE_BP;
import 'package:p/blocs/awesomeReadingTips/Bloc.dart'
    as AWESOME_READING_TIPS_BP;

class MenuPage extends StatefulWidget {
  @override
  State createState() => MenuPageState();
}

class MenuPageState extends State<MenuPage> implements MenuBlocDelegate {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
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

  ListTile myPassportListTile() {
    return ListTile(
      leading: Icon(
        Icons.person,
        color: Colors.white,
      ),
      title: Text(
        'My Passport',
        style: TextStyle(color: Colors.white),
      ),
      onTap: () async {
        HapticFeedback.vibrate();

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
      leading: Icon(Icons.bookmark, color: Colors.white),
      title: Text(
        'Reading Log',
        style: TextStyle(color: Colors.white),
      ),
      onTap: () {
        HapticFeedback.vibrate();

        Route route = MaterialPageRoute(
          builder: (BuildContext context) => BlocProvider(
            create: (BuildContext context) =>
                READING_LOG_BOOKS_BP.ReadingLogBooksBloc()
                  ..add(
                    READING_LOG_BOOKS_BP.LoadPageEvent(),
                  ),
            child: READING_LOG_BOOKS_BP.ReadingLogBooksPage(),
          ),
        );
        Navigator.push(context, route);
      },
    );
  }

  ListTile visitLogListTile() {
    return ListTile(
      leading: Icon(Icons.location_on, color: Colors.white),
      title: Text(
        'Visit Log',
        style: TextStyle(color: Colors.white),
      ),
      onTap: () {
        HapticFeedback.vibrate();

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
      leading: Icon(
        Icons.book,
        color: Colors.white,
      ),
      title: Text(
        'Book of The Month',
        style: TextStyle(color: Colors.white),
      ),
      onTap: () {
        HapticFeedback.vibrate();

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
      leading: Icon(Icons.collections_bookmark, color: Colors.white),
      title: Text(
        'AWEsome Reading Tips',
        style: TextStyle(color: Colors.white),
      ),
      onTap: () {
        HapticFeedback.vibrate();

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
      leading: Icon(Icons.edit, color: Colors.white),
      title: Text(
        'Edit Profile',
        style: TextStyle(color: Colors.white),
      ),
      onTap: () {
        HapticFeedback.vibrate();

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
        HapticFeedback.vibrate();

        Route route = MaterialPageRoute(
          builder: (BuildContext context) => BlocProvider(
            create: (BuildContext context) => ADMIN_LOG_BP.AdminBloc()
              ..add(
                ADMIN_LOG_BP.LoadPageEvent(),
              ),
            child: ADMIN_LOG_BP.AdminPage(),
          ),
        );
        Navigator.push(context, route);
      },
    );
  }

  ListTile aboutListTile() {
    return ListTile(
      leading: Icon(MdiIcons.information, color: Colors.white),
      title: Text(
        'About',
        style: TextStyle(color: Colors.white),
      ),
      onTap: () {
        HapticFeedback.vibrate();

        Route route = MaterialPageRoute(
          builder: (BuildContext context) => AboutPage(),
        );

        Navigator.push(context, route);
      },
    );
  }

  ListTile settingsListTile() {
    return ListTile(
      leading: Icon(Icons.settings, color: Colors.white),
      title: Text(
        'Settings',
        style: TextStyle(color: Colors.white),
      ),
      onTap: () {
        HapticFeedback.vibrate();

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

  @override
  Widget build(BuildContext context) {
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
                color: COLOR_NAVY,
                child: SafeArea(
                  child: Column(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: COLOR_ORANGE
                        ),
                        height: 80,
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundImage: NetworkImage(
                              user.imgUrl,
                            ),
                          ),
                          title: Text(
                            'Good $greetingMessage',
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                          subtitle: Text(
                            '${user.firstName} ${user.lastName}',
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      Spacer(),
                      bookOfTheMonthListTile(),
                      awesomeReadingTipsListTile(),
                      editProfileListTile(),
                      adminListTile(),
                      aboutListTile(),
                      settingsListTile(),
                      logOutListTile(),
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
                color: COLOR_NAVY,
                child: SafeArea(
                  child: Column(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: COLOR_ORANGE,
                        ),
                        height: 80,
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundImage: NetworkImage(
                              user.imgUrl,
                            ),
                          ),
                          title: Text(
                            'Good $greetingMessage',
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                          subtitle: Text(
                            '${user.firstName} ${user.lastName}',
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      Spacer(),
                      myPassportListTile(),
                      readingLogListTile(),
                      visitLogListTile(),
                      bookOfTheMonthListTile(),
                      awesomeReadingTipsListTile(),
                      editProfileListTile(),
                      adminListTile(),
                      aboutListTile(),
                      settingsListTile(),
                      logOutListTile(),
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
                color: COLOR_NAVY,
                child: SafeArea(
                  child: Column(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: COLOR_ORANGE
                        ),
                        height: 80,
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundImage: NetworkImage(
                              user.imgUrl,
                            ),
                          ),
                          title: Text(
                            'Good $greetingMessage',
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                          subtitle: Text(
                            '${user.firstName} ${user.lastName}',
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      Spacer(),
                      bookOfTheMonthListTile(),
                      awesomeReadingTipsListTile(),
                      editProfileListTile(),
                      adminListTile(),
                      aboutListTile(),
                      settingsListTile(),
                      logOutListTile(),
                    ],
                  ),
                ),
              ),
            ),
          );
        }

        if (state is ErrorState) {
          return Scaffold(
            backgroundColor: COLOR_CREAM,
            body: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(state.error.toString()),
                  RaisedButton(
                    color: COLOR_ORANGE,
                    textColor: Colors.white,
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

  @override
  void showMessage({String message}) {
    locator<ModalService>()
        .showInSnackBar(scaffoldKey: _scaffoldKey, message: message);
  }
}
