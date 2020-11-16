import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:p/AboutPage.dart';
import 'package:p/ServiceLocator.dart';
import 'package:p/constants.dart';
import 'package:p/models/UserModel.dart';
import 'package:p/services/AuthService.dart';
import 'package:p/services/ModalService.dart';
import 'package:p/widgets/ImageUploadWidget.dart';
import 'package:p/widgets/SpinnerWidget.dart';
import '../../SettingsPage.dart';
import 'Bloc.dart';
import 'package:p/blocs/bookOfTheMonth/Bloc.dart' as BOOK_OF_THE_MONTH_BP;
import 'package:p/blocs/myPassport/Bloc.dart' as MY_PASSPORT_BP;
import 'package:p/blocs/visitingLogVisits/Bloc.dart' as VISITING_LOG_VISITS_BP;
import 'package:p/blocs/readingLogBooks/Bloc.dart' as READING_LOG_BOOKS_BP;
import 'package:p/blocs/admin/Bloc.dart' as ADMIN_LOG_BP;
import 'package:p/blocs/editProfile/Bloc.dart' as EDIT_PROFILE_BP;
import 'package:p/blocs/awesomeReadingTips/Bloc.dart'
    as AWESOME_READING_TIPS_BP;
import 'package:p/blocs/myClass/Bloc.dart' as MY_CLASS_BP;

class MenuPage extends StatefulWidget {
  @override
  State createState() => MenuPageState();
}

class MenuPageState extends State<MenuPage> implements MenuBlocDelegate {
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
        width: 20,
      ),
      title: Text(
        'My Class',
        style: TextStyle(color: Colors.white),
      ),
      onTap: () async {
        HapticFeedback.vibrate();

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
        width: 20,
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
      leading: Image.asset(
        ASSET_icon_reading_log,
        width: 20,
      ),
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
      leading: Image.asset(
        ASSET_icon_visit_log,
        width: 20,
      ),
      title: Text(
        'Visit Log',
        style: TextStyle(color: Colors.white),
      ),
      onTap: () {
        HapticFeedback.vibrate();

        Route route = MaterialPageRoute(
          builder: (BuildContext context) => BlocProvider(
            create: (BuildContext context) =>
                VISITING_LOG_VISITS_BP.VisitingLogVisitsBloc()
                  ..add(
                    VISITING_LOG_VISITS_BP.LoadPageEvent(),
                  ),
            child: VISITING_LOG_VISITS_BP.VisitingLogVisitsPage(),
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
        height: 20,
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
      leading: Image.asset(
        ASSET_icon_awesome_reading_tips,
        width: 20,
      ),
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
      leading: Image.asset(
        ASSET_icon_edit_profile,
        width: 20,
      ),
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

  // ListTile adminListTile() {
  //   return ListTile(
  //     leading: Icon(MdiIcons.security, color: Colors.white),
  //     title: Text(
  //       'Admin',
  //       style: TextStyle(color: Colors.white),
  //     ),
  //     onTap: () {
  //       HapticFeedback.vibrate();

  //       Route route = MaterialPageRoute(
  //         builder: (BuildContext context) => BlocProvider(
  //           create: (BuildContext context) => ADMIN_LOG_BP.AdminBloc()
  //             ..add(
  //               ADMIN_LOG_BP.LoadPageEvent(),
  //             ),
  //           child: ADMIN_LOG_BP.AdminPage(),
  //         ),
  //       );
  //       Navigator.push(context, route);
  //     },
  //   );
  // }

  ListTile aboutListTile() {
    return ListTile(
      leading: Image.asset(
        ASSET_icon_about,
        width: 20,
      ),
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
      leading: Image.asset(
        ASSET_icon_settings,
        width: 20,
      ),
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
                      // adminListTile(),
                      aboutListTile(),
                      settingsListTile(),
                      logOutListTile(),
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
                            child: InkWell(
                              onTap: () {
                                showSelectImageDialog();
                              },
                              child: CircleAvatar(
                                radius: 30,
                                backgroundImage: NetworkImage(
                                  user.imgUrl,
                                ),
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
                      bookOfTheMonthListTile(),
                      awesomeReadingTipsListTile(),
                      editProfileListTile(),
                      // adminListTile(),
                      aboutListTile(),
                      settingsListTile(),
                      logOutListTile(),
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

  showSelectImageDialog() {
    return Platform.isIOS ? iOSBottomSheet() : androidDialog();
  }

  iOSBottomSheet() {
    showCupertinoModalPopup(
        context: context,
        builder: (BuildContext context) {
          return CupertinoActionSheet(
            title: Text('Add Photo'),
            actions: <Widget>[
              CupertinoActionSheetAction(
                child: Text('Take Photo'),
                onPressed: () => handleImage(source: ImageSource.camera),
              ),
              CupertinoActionSheetAction(
                child: Text('Choose From Gallery'),
                onPressed: () => handleImage(source: ImageSource.gallery),
              )
            ],
            cancelButton: CupertinoActionSheetAction(
              child: Text(
                'Cancel',
                style: TextStyle(color: Colors.redAccent),
              ),
              onPressed: () => Navigator.pop(context),
            ),
          );
        });
  }

  androidDialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return SimpleDialog(
            title: Text('Add Photo'),
            children: <Widget>[
              SimpleDialogOption(
                child: Text('Take Photo'),
                onPressed: () => handleImage(source: ImageSource.camera),
              ),
              SimpleDialogOption(
                child: Text('Choose From Gallery'),
                onPressed: () => handleImage(source: ImageSource.gallery),
              ),
              SimpleDialogOption(
                child: Text(
                  'Cancel',
                  style: TextStyle(color: Colors.redAccent),
                ),
                onPressed: () => Navigator.pop(context),
              )
            ],
          );
        });
  }

  handleImage({@required ImageSource source}) async {
    Navigator.pop(context);

    try {
      final PickedFile file = await ImagePicker().getImage(source: source);

      if (file == null) return;

      File image = await ImageCropper.cropImage(sourcePath: file.path);

      if (image == null) return;

      _menuBloc.add(
        UploadPictureEvent(image: image),
      );
    } catch (error) {
      print(error);
    }
  }

  @override
  void showMessage({String message}) {
    locator<ModalService>()
        .showInSnackBar(scaffoldKey: _scaffoldKey, message: message);
  }
}
