import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:p/AboutPage.dart';
import 'package:p/constants.dart';
import 'package:p/models/UserModel.dart';
import '../ServiceLocator.dart';
import '../SettingsPage.dart';
import 'ValidatorService.dart';
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

abstract class IModalService {
  void showInSnackBar(
      {@required GlobalKey<ScaffoldState> scaffoldKey,
      @required String message});

  void showAlert(
      {@required BuildContext context,
      @required String title,
      @required String message});
  Future<String> showPasswordResetEmail({@required BuildContext context});
  Future<String> showChangeEmail({@required BuildContext context});
  Future<bool> showConfirmation(
      {@required BuildContext context,
      @required String title,
      @required String message});
  Future<bool> showConfirmationWithImage(
      {@required BuildContext context,
      @required String title,
      @required String message,
      @required File file});

  Future<int> showOptions(
      {@required BuildContext context,
      @required String title,
      @required List<String> options});
}

class ModalService extends IModalService {
  @override
  void showInSnackBar(
      {@required GlobalKey<ScaffoldState> scaffoldKey,
      @required String message}) {
    scaffoldKey.currentState.showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }

  @override
  void showAlert(
      {@required BuildContext context,
      @required String title,
      @required String message}) {
    showDialog(
      context: context,
      builder: (BuildContext buildContext) {
        if (Platform.isIOS) {
          return CupertinoAlertDialog(
            title: Text(title),
            content: Text(message),
            actions: <Widget>[
              CupertinoDialogAction(
                isDefaultAction: true,
                child: Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        } else {
          return AlertDialog(
            title: Text(title),
            content: Text(message),
            actions: <Widget>[
              FlatButton(
                child: const Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        }
      },
    );
  }

  @override
  Future<String> showPasswordResetEmail({@required BuildContext context}) {
    final TextEditingController emailController = TextEditingController();
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();
    bool autovalidate = false;

    return showDialog<String>(
      barrierDismissible: false,
      context: context,
      child: AlertDialog(
        title: Text('Reset Password'),
        content: Form(
          key: formKey,
          autovalidate: autovalidate,
          child: TextFormField(
            controller: emailController,
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.done,
            maxLengthEnforced: true,
            onFieldSubmitted: (term) {},
            validator: locator<ValidatorService>().email,
            onSaved: (value) {},
            decoration: InputDecoration(
              hintText: 'Email',
              icon: Icon(Icons.email),
              fillColor: Colors.white,
            ),
          ),
        ),
        actions: <Widget>[
          FlatButton(
            child: const Text('CANCEL'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          FlatButton(
            child: const Text('SUBMIT'),
            onPressed: () {
              final FormState form = formKey.currentState;
              if (!form.validate()) {
                autovalidate = true;
              } else {
                Navigator.of(context).pop(emailController.text);
              }
            },
          )
        ],
      ),
    );
  }

  @override
  Future<String> showChangeEmail({@required BuildContext context}) {
    final TextEditingController emailController = TextEditingController();
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();
    bool autovalidate = false;

    return showDialog<String>(
      barrierDismissible: false,
      context: context,
      child: AlertDialog(
        title: Text('Change Email'),
        content: Form(
          key: formKey,
          autovalidate: autovalidate,
          child: TextFormField(
            controller: emailController,
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.done,
            maxLengthEnforced: true,
            onFieldSubmitted: (term) {},
            validator: locator<ValidatorService>().email,
            onSaved: (value) {},
            decoration: InputDecoration(
              hintText: 'New Email',
              icon: Icon(Icons.email),
              fillColor: Colors.white,
            ),
          ),
        ),
        actions: <Widget>[
          FlatButton(
            child: const Text('CANCEL'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          FlatButton(
            child: const Text('SUBMIT'),
            onPressed: () {
              final FormState form = formKey.currentState;
              if (!form.validate()) {
                autovalidate = true;
              } else {
                Navigator.of(context).pop(emailController.text);
              }
            },
          )
        ],
      ),
    );
  }

  @override
  Future<bool> showConfirmation(
      {@required BuildContext context,
      @required String title,
      @required String message}) {
    return showDialog<bool>(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        if (Platform.isIOS) {
          return CupertinoAlertDialog(
            title: Text(title),
            content: Text(message),
            actions: [
              CupertinoDialogAction(
                isDefaultAction: true,
                child: Text('Yes'),
                onPressed: () {
                  Navigator.of(context).pop(true);
                },
              ),
              CupertinoDialogAction(
                isDefaultAction: false,
                child: Text('No'),
                onPressed: () {
                  Navigator.of(context).pop(false);
                },
              )
            ],
          );
        } else {
          return AlertDialog(
            title: Text(title),
            content: Text(message),
            actions: <Widget>[
              FlatButton(
                child: const Text('YES', style: TextStyle(color: Colors.black)),
                onPressed: () {
                  Navigator.of(context).pop(true);
                },
              ),
              FlatButton(
                child: const Text('NO', style: TextStyle(color: Colors.black)),
                onPressed: () {
                  Navigator.of(context).pop(false);
                },
              ),
            ],
          );
        }
      },
    );
  }

  @override
  Future<bool> showConfirmationWithImage(
      {@required BuildContext context,
      @required String title,
      @required String message,
      @required File file}) {
    return showDialog<bool>(
      barrierDismissible: false,
      context: context,
      child: AlertDialog(
        title: Text(
          title,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        content: Center(
          child: Image.file(file),
        ),
        actions: <Widget>[
          FlatButton(
            child: const Text(
              'NO',
              style:
                  TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
            ),
            onPressed: () {
              Navigator.of(context).pop(false);
            },
          ),
          FlatButton(
            child: const Text(
              'YES',
              style:
                  TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
            ),
            onPressed: () {
              Navigator.of(context).pop(true);
            },
          )
        ],
      ),
    );
  }

  @override
  Future<int> showOptions(
      {@required BuildContext context,
      @required String title,
      @required List<String> options}) async {
    if (Platform.isIOS) {
      return showCupertinoModalPopup(
        context: context,
        builder: (BuildContext context) {
          List<CupertinoActionSheetAction> actions =
              List<CupertinoActionSheetAction>();

          //Build actions based on optino titles.
          for (var i = 0; i < options.length; i++) {
            actions.add(
              CupertinoActionSheetAction(
                child: Text(options[i]),
                onPressed: () {
                  Navigator.of(context).pop(i);
                },
              ),
            );
          }

          return CupertinoActionSheet(
            title: Text(title),
            actions: actions,
            cancelButton: CupertinoActionSheetAction(
              child: Text(
                'Cancel',
                style: TextStyle(color: Colors.redAccent),
              ),
              onPressed: () => Navigator.pop(context),
            ),
          );
        },
      );
    } else {
      return await showModalBottomSheet<int>(
        context: context,
        builder: (BuildContext context) {
          List<ListTile> actions = List<ListTile>();

          actions.add(
            ListTile(
              title: Text(title),
            ),
          );

          for (var i = 0; i < options.length; i++) {
            actions.add(
              ListTile(
                title: Text(options[i]),
                onTap: () {
                  Navigator.of(context).pop(i);
                  //return i;
                },
              ),
            );
          }

          return Column(
            mainAxisSize: MainAxisSize.min,
            children: actions,
          );
        },
      );
    }
  }

  void showMenu({
    @required BuildContext context,
    @required UserModel user,
  }) async {
    return await showModalBottomSheet<dynamic>(
      isDismissible: false,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      context: context,
      builder: (BuildContext bc) {
        final DateTime now = DateTime.now();

        String greetingMessage;
        if (now.hour < 12) {
          greetingMessage = 'Morning';
        } else if (now.hour < 17) {
          greetingMessage = 'Afternoon';
        } else {
          greetingMessage = 'Evening';
        }

        return Wrap(
          children: <Widget>[
            Container(
              child: Container(
                height: screenHeight * 0.8,
                decoration: BoxDecoration(
                  color: COLOR_NAVY,
                  borderRadius: new BorderRadius.only(
                    topLeft: const Radius.circular(25.0),
                    topRight: const Radius.circular(25.0),
                  ),
                ),
                child: ListView(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.deepOrange,
                        borderRadius: new BorderRadius.only(
                          topLeft: const Radius.circular(25.0),
                          topRight: const Radius.circular(25.0),
                        ),
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
                        trailing: IconButton(
                          icon: Icon(
                            Icons.cancel,
                            color: Colors.white,
                          ),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    ListTile(
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
                            create: (BuildContext context) =>
                                MY_PASSPORT_BP.MyPassportBloc()
                                  ..add(
                                    MY_PASSPORT_BP.LoadPageEvent(),
                                  ),
                            child: MY_PASSPORT_BP.MyPassportPage(),
                          ),
                        );
                        Navigator.push(context, route);
                      },
                    ),
                    ListTile(
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
                    ),
                    ListTile(
                      leading: Icon(Icons.location_on, color: Colors.white),
                      title: Text(
                        'Visit Log',
                        style: TextStyle(color: Colors.white),
                      ),
                      onTap: () {
                        HapticFeedback.vibrate();

                        Route route = MaterialPageRoute(
                          builder: (BuildContext context) => BlocProvider(
                            create: (BuildContext context) =>
                                VISITING_LOG_BP.VisitingLogBloc()
                                  ..add(
                                    VISITING_LOG_BP.LoadPageEvent(),
                                  ),
                            child: VISITING_LOG_BP.VisitingLogPage(),
                          ),
                        );
                        Navigator.push(context, route);
                      },
                    ),
                    ListTile(
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
                    ),
                    ListTile(
                      leading:
                          Icon(Icons.collections_bookmark, color: Colors.white),
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
                            child: AWESOME_READING_TIPS_BP
                                .AwesomeReadingTipsPage(),
                          ),
                        );
                        Navigator.push(context, route);
                      },
                    ),
                    ListTile(
                      leading: Icon(Icons.edit, color: Colors.white),
                      title: Text(
                        'Edit Profile',
                        style: TextStyle(color: Colors.white),
                      ),
                      onTap: () {
                        HapticFeedback.vibrate();

                        Route route = MaterialPageRoute(
                          builder: (BuildContext context) => BlocProvider(
                            create: (BuildContext context) =>
                                EDIT_PROFILE_BP.EditProfileBloc()
                                  ..add(
                                    EDIT_PROFILE_BP.LoadPageEvent(),
                                  ),
                            child: EDIT_PROFILE_BP.EditProfilePage(),
                          ),
                        );
                        Navigator.push(context, route);
                      },
                    ),
                    ListTile(
                      leading: Icon(MdiIcons.security, color: Colors.white),
                      title: Text(
                        'Admin',
                        style: TextStyle(color: Colors.white),
                      ),
                      onTap: () {
                        HapticFeedback.vibrate();

                        Route route = MaterialPageRoute(
                          builder: (BuildContext context) => BlocProvider(
                            create: (BuildContext context) =>
                                ADMIN_LOG_BP.AdminBloc()
                                  ..add(
                                    ADMIN_LOG_BP.LoadPageEvent(),
                                  ),
                            child: ADMIN_LOG_BP.AdminPage(),
                          ),
                        );
                        Navigator.push(context, route);
                      },
                    ),
                    ListTile(
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
                    ),
                    ListTile(
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
                    )
                  ],
                ),
              ),
            )
          ],
        );
      },
    );
  }
}
