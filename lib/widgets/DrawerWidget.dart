import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:p/AboutPage.dart';
import 'package:p/SettingsPage.dart';
import 'package:p/constants.dart';
import 'package:p/models/UserModel.dart';
import 'package:p/services/AuthService.dart';
import 'package:p/services/ModalService.dart';
import 'package:p/services/StorageService.dart';
import 'package:p/services/UserService.dart';
import '../ServiceLocator.dart';
import 'package:p/blocs/myPassport/Bloc.dart' as MY_PASSPORT_BP;
import 'package:p/blocs/home/Bloc.dart' as HOME_BP;
import 'package:p/blocs/bookOfTheMonth/Bloc.dart' as BOOK_OF_THE_MONTH_BP;
import 'package:p/blocs/visitingLog/Bloc.dart' as VISITING_LOG_BP;
import 'package:p/blocs/readingLogBooks/Bloc.dart' as READING_LOG_BOOKS_BP;
import 'package:p/blocs/admin/Bloc.dart' as ADMIN_LOG_BP;
import 'package:p/blocs/editProfile/Bloc.dart' as EDIT_PROFILE_BP;
import 'package:p/blocs/awesomeReadingTips/Bloc.dart'
    as AWESOME_READING_TIPS_BP;

class DrawerWidget extends StatefulWidget {
  const DrawerWidget({
    Key key,
    @required this.currentUser,
    @required this.page,
  }) : super(key: key);

  final UserModel currentUser;
  final APP_PAGES page;
  @override
  State createState() => DrawerWidgetState(
        currentUser: currentUser,
        page: page,
      );
}

class DrawerWidgetState extends State<DrawerWidget> {
  DrawerWidgetState({
    @required this.currentUser,
    @required this.page,
  });

  final _drawerIconColor = Colors.blueGrey;
  final UserModel currentUser;
  final APP_PAGES page;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: _buildLayout(),
    );
  }

  Widget _buildLayout() {
    if (currentUser.profileType == PROFILE_TYPE.TEACHER.name)
      return _buildTeacherLayout();
    else if (currentUser.profileType == PROFILE_TYPE.PARENT.name)
      return _buildParentLayout();
    else if (currentUser.profileType == PROFILE_TYPE.ADMIN.name)
      return _buildSuperAdminLayout();
    else
      return Container();
  }

  void logout() async {
    bool confirm = await locator<ModalService>().showConfirmation(
        context: context, title: 'Logout', message: 'Are you sure?');

    if (!confirm) return;

    await locator<AuthService>().signOut();
    Navigator.of(context).popUntil((route) => route.isFirst);
  }

  ListTile _homeListTile() {
    return ListTile(
      leading: Icon(
        Icons.home,
        color: _drawerIconColor,
      ),
      title: Text(
        'Home',
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      onTap: () async {
        if (page == APP_PAGES.HOME) return;

        Route route = MaterialPageRoute(
          builder: (BuildContext context) => BlocProvider(
            create: (BuildContext context) => HOME_BP.HomeBloc()
              ..add(
                HOME_BP.LoadPageEvent(),
              ),
            child: HOME_BP.HomePage(),
          ),
        );
        Navigator.push(context, route);
      },
    );
  }

  ListTile _bookOfTheMonthListTile() {
    return ListTile(
      leading: Icon(Icons.book, color: _drawerIconColor),
      title: Text(
        'Book of The Month',
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      onTap: () {
        if (page == APP_PAGES.BOOK_OF_THE_MONTH) return;

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

  ListTile _myPassportListTile() {
    return ListTile(
      leading: Icon(
        Icons.person,
        color: _drawerIconColor,
      ),
      title: Text(
        'My Passport',
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      onTap: () async {
        if (page == APP_PAGES.MY_PASSPORT) return;

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

  ListTile _readingLogListTile() {
    return ListTile(
      leading: Icon(Icons.bookmark, color: _drawerIconColor),
      title: Text(
        'Read Log',
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      onTap: () {
        if (page == APP_PAGES.READ_LOG) return;

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

  ListTile _visitingLogListTile() {
    return ListTile(
      leading: Icon(Icons.location_on, color: _drawerIconColor),
      title: Text(
        'Visit Log',
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      onTap: () {
        if (page == APP_PAGES.VISIT_LOG) return;

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

  ListTile _aboutListTile() {
    return ListTile(
      leading: Icon(MdiIcons.information, color: _drawerIconColor),
      title: Text(
        'About',
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      onTap: () {
        if (page == APP_PAGES.ABOUT) return;

        Route route = MaterialPageRoute(
          builder: (BuildContext context) => AboutPage(
            currentUser: currentUser,
          ),
        );

        Navigator.push(context, route);
      },
    );
  }

  ListTile _settingsListTile() {
    return ListTile(
      leading: Icon(Icons.settings, color: _drawerIconColor),
      title: Text(
        'Settings',
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      onTap: () {
        if (page == APP_PAGES.SETTINGS) return;

        Route route = MaterialPageRoute(
          builder: (BuildContext context) => SettingsPage(
            currentUser: currentUser,
          ),
        );

        Navigator.push(context, route);
      },
    );
  }

  ListTile _adminListTile() {
    return ListTile(
      leading: Icon(MdiIcons.accountBox, color: _drawerIconColor),
      title: Text(
        'Admin',
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      onTap: () {
        if (page == APP_PAGES.ADMIN) return;

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

  ListTile _editProfileListTile() {
    return ListTile(
      leading: Icon(Icons.edit, color: _drawerIconColor),
      title: Text(
        'Edit Profile',
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      onTap: () {
        if (page == APP_PAGES.EDIT_PROFILE) return;

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

  ListTile _awesomeReadingTipsListTile() {
    return ListTile(
      leading: Icon(Icons.collections_bookmark, color: _drawerIconColor),
      title: Text(
        'AWEsome Reading Tips',
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      onTap: () {
        if (page == APP_PAGES.AWESOME_READING_TIPS) return;

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

  ListTile _logOutListTile() {
    return ListTile(
      leading: Icon(MdiIcons.logout, color: _drawerIconColor),
      title: Text(
        'Logout',
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      onTap: logout,
    );
  }

  UserAccountsDrawerHeader _userAccountsDrawerHeader({
    @required UserModel user,
    @required String profileType,
  }) {
    return UserAccountsDrawerHeader(
      accountName: Text(
        '${user.firstName} ${user.lastName}',
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      accountEmail: Text(profileType),
      currentAccountPicture: InkWell(
        child: CircleAvatar(
            backgroundImage: NetworkImage('${user.imgUrl}'),
            backgroundColor: Colors.transparent,
            radius: 10.0),
        onTap: showSelectImageDialog,
      ),
      decoration: BoxDecoration(
        color: Colors.black,
      ),
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
    //Remove previous pop up.
    Navigator.pop(context);

    try {
      //Pick an image.
      PickedFile file = await ImagePicker().getImage(source: source);

      //Check that user picked an image.
      if (file == null) return;

      //Crop an image.
      File image = await ImageCropper.cropImage(sourcePath: file.path);

      //Check that user cropped the image.
      if (image == null) return;

      //Get image upload url.
      final String newImgUrl = await locator<StorageService>().uploadImage(
          file: image, path: 'Images/Users/${currentUser.uid}/Profile');

      //Save image upload url.
      await locator<UserService>()
          .updateUser(uid: currentUser.uid, data: {'imgUrl': newImgUrl});

      setState(() {
        currentUser.imgUrl = newImgUrl;
      });
    } catch (error) {
      print(error);
    }
  }

  Widget _buildTeacherLayout() {
    return Column(
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        _userAccountsDrawerHeader(user: currentUser, profileType: 'Teacher'),
        _bookOfTheMonthListTile(),
        _adminListTile(),
        _editProfileListTile(),
        _awesomeReadingTipsListTile(),
        _aboutListTile(),
        _settingsListTile(),
        Spacer(),
        _logOutListTile(),
        SizedBox(
          height: 40,
        )
      ],
    );
  }

  Widget _buildParentLayout() {
    return Column(
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        _userAccountsDrawerHeader(user: currentUser, profileType: 'Student'),
        _homeListTile(),
        _bookOfTheMonthListTile(),
        _myPassportListTile(),
        _readingLogListTile(),
        _visitingLogListTile(),
        _editProfileListTile(),
        _awesomeReadingTipsListTile(),
        _aboutListTile(),
        _settingsListTile(),
        Spacer(),
        _logOutListTile(),
        SizedBox(
          height: 40,
        )
      ],
    );
  }

  Widget _buildSuperAdminLayout() {
    return Column(
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        _userAccountsDrawerHeader(
            user: currentUser, profileType: 'Super Admin'),
        _adminListTile(),
        _editProfileListTile(),
        _awesomeReadingTipsListTile(),
        _aboutListTile(),
        _settingsListTile(),
        Spacer(),
        _logOutListTile(),
        SizedBox(
          height: 40,
        )
      ],
    );
  }
}
