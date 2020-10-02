import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:p/ServiceLocator.dart';
import 'package:p/constants.dart';
import 'package:p/models/UserModel.dart';
import 'package:p/services/ModalService.dart';
import 'package:p/widgets/DrawerWidget.dart';
import 'package:p/widgets/FullWidthButtonWidget.dart';
import 'package:p/widgets/SpinnerWidget.dart';
import 'Bloc.dart';

class EditProfilePage extends StatefulWidget {
  @override
  State createState() => EditProfilePageState();
}

class EditProfilePageState extends State<EditProfilePage>
    implements EditProfileBlocDelegate {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _dobController = TextEditingController();
  final TextEditingController _schoolController = TextEditingController();

  EditProfileBloc _editProfileBloc;

  @override
  void initState() {
    _editProfileBloc = BlocProvider.of<EditProfileBloc>(context);
    _editProfileBloc.setDelegate(delegate: this);

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EditProfileBloc, EditProfileState>(
      builder: (BuildContext context, EditProfileState state) {
        if (state is LoadingState) {
          return Container(
            color: Colors.white,
            child: SpinnerWidget(),
          );
        }

        if (state is TeacherLoadedState) {
          return Scaffold(
            key: _scaffoldKey,
            appBar: AppBar(
              title: Text('Edit Profile'),
            ),
            drawer: DrawerWidget(
              currentUser: state.user,
              page: APP_PAGES.EDIT_PROFILE,
            ),
            body: AnnotatedRegion<SystemUiOverlayStyle>(
              value: SystemUiOverlayStyle.light,
              child: SafeArea(
                child: Form(
                  child: Column(
                    children: [
                      Expanded(
                        child: ListView(
                          children: [
                            Padding(
                              padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
                              child: TextFormField(
                                controller: _firstNameController,
                                decoration: InputDecoration(
                                    prefixIcon: Icon(
                                      Icons.person,
                                    ),
                                    border: OutlineInputBorder(
                                      // width: 0.0 produces a thin "hairline" border
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(90.0),
                                      ),
                                      borderSide: BorderSide.none,

                                      //borderSide: const BorderSide(),
                                    ),
                                    hintStyle:
                                        TextStyle(fontFamily: "WorkSansLight"),
                                    filled: true,
                                    hintText: 'Teacher\'s First name'),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
                              child: TextFormField(
                                controller: _lastNameController,
                                decoration: InputDecoration(
                                    prefixIcon: Icon(
                                      Icons.person,
                                    ),
                                    border: OutlineInputBorder(
                                      // width: 0.0 produces a thin "hairline" border
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(90.0),
                                      ),
                                      borderSide: BorderSide.none,

                                      //borderSide: const BorderSide(),
                                    ),
                                    hintStyle:
                                        TextStyle(fontFamily: "WorkSansLight"),
                                    filled: true,
                                    hintText: 'Teacher\'s Last name'),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
                              child: TextFormField(
                                controller: _schoolController,
                                decoration: InputDecoration(
                                    prefixIcon: Icon(
                                      Icons.school,
                                    ),
                                    border: OutlineInputBorder(
                                      // width: 0.0 produces a thin "hairline" border
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(90.0),
                                      ),
                                      borderSide: BorderSide.none,

                                      //borderSide: const BorderSide(),
                                    ),
                                    hintStyle:
                                        TextStyle(fontFamily: "WorkSansLight"),
                                    filled: true,
                                    hintText: 'School'),
                              ),
                            ),
                          ],
                        ),
                      ),
                      FullWidthButtonWidget(
                        text: 'Update',
                        buttonColor: Colors.blue,
                        onPressed: () {
                          _editProfileBloc.add(
                            TeacherSubmitEvent(
                              firstName: _firstNameController.text,
                              lastName: _lastNameController.text,
                              school: _schoolController.text,
                            ),
                          );
                        },
                        textColor: Colors.white,
                      )
                    ],
                  ),
                ),
              ),
            ),
          );
        }

        if (state is ParentLoadedState) {
          return Scaffold(
            key: _scaffoldKey,
            appBar: AppBar(
              title: Text('Edit Profile'),
            ),
            drawer: DrawerWidget(
              currentUser: state.user,
              page: APP_PAGES.EDIT_PROFILE,
            ),
            body: AnnotatedRegion<SystemUiOverlayStyle>(
              value: SystemUiOverlayStyle.light,
              child: SafeArea(
                child: Form(
                  child: Column(
                    children: [
                      Expanded(
                        child: ListView(
                          children: [
                            Padding(
                              padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
                              child: TextFormField(
                                controller: _firstNameController,
                                decoration: InputDecoration(
                                    prefixIcon: Icon(
                                      Icons.person,
                                    ),
                                    border: OutlineInputBorder(
                                      // width: 0.0 produces a thin "hairline" border
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(90.0),
                                      ),
                                      borderSide: BorderSide.none,

                                      //borderSide: const BorderSide(),
                                    ),
                                    hintStyle:
                                        TextStyle(fontFamily: "WorkSansLight"),
                                    filled: true,
                                    hintText: 'Child\'s First name'),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
                              child: TextFormField(
                                controller: _lastNameController,
                                decoration: InputDecoration(
                                    prefixIcon: Icon(
                                      Icons.person,
                                    ),
                                    border: OutlineInputBorder(
                                      // width: 0.0 produces a thin "hairline" border
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(90.0),
                                      ),
                                      borderSide: BorderSide.none,

                                      //borderSide: const BorderSide(),
                                    ),
                                    hintStyle:
                                        TextStyle(fontFamily: "WorkSansLight"),
                                    filled: true,
                                    hintText: 'Child\'s Last name'),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.all(20),
                              child: TextFormField(
                                autovalidate: state.autoValidate,
                                onTap: () async {
                                  final DateTime picked = await showDatePicker(
                                    context: context,
                                    initialDate: state.user.dob,
                                    firstDate: DateTime(2000, 1),
                                    lastDate: DateTime.now(),
                                  );

                                  if (picked != null &&
                                      picked != state.user.dob) {
                                    _editProfileBloc.add(
                                      UpdateChildDOBEvent(childDOB: picked),
                                    );

                                    String formattedDate =
                                        DateFormat('MMMM dd, yyyy')
                                            .format(picked);
                                    _dobController.text = formattedDate;
                                  }
                                },
                                controller: _dobController,
                                decoration: InputDecoration(
                                    prefixIcon: Icon(
                                      Icons.calendar_today,
                                    ),
                                    border: OutlineInputBorder(
                                      // width: 0.0 produces a thin "hairline" border
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(90.0),
                                      ),
                                      borderSide: BorderSide.none,

                                      //borderSide: const BorderSide(),
                                    ),
                                    hintStyle:
                                        TextStyle(fontFamily: "WorkSansLight"),
                                    filled: true,
                                    hintText: 'Child\'s DOB'),
                              ),
                            ),
                          ],
                        ),
                      ),
                      FullWidthButtonWidget(
                        text: 'Update',
                        buttonColor: Colors.blue,
                        onPressed: () {
                          _editProfileBloc.add(
                            ParentSubmitEvent(
                              firstName: _firstNameController.text,
                              lastName: _lastNameController.text,
                            ),
                          );
                        },
                        textColor: Colors.white,
                      )
                    ],
                  ),
                ),
              ),
            ),
          );
        }

        if (state is SuperAdminLoadedState) {
          return Scaffold(
            key: _scaffoldKey,
            appBar: AppBar(
              title: Text('Edit Profile'),
            ),
            drawer: DrawerWidget(
              currentUser: state.user,
              page: APP_PAGES.EDIT_PROFILE,
            ),
            body: AnnotatedRegion<SystemUiOverlayStyle>(
              value: SystemUiOverlayStyle.light,
              child: SafeArea(
                child: Form(
                  child: Column(
                    children: [
                      Expanded(
                        child: ListView(
                          children: [
                            Padding(
                              padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
                              child: TextFormField(
                                controller: _firstNameController,
                                decoration: InputDecoration(
                                    prefixIcon: Icon(
                                      Icons.person,
                                    ),
                                    border: OutlineInputBorder(
                                      // width: 0.0 produces a thin "hairline" border
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(90.0),
                                      ),
                                      borderSide: BorderSide.none,

                                      //borderSide: const BorderSide(),
                                    ),
                                    hintStyle:
                                        TextStyle(fontFamily: "WorkSansLight"),
                                    filled: true,
                                    hintText: 'First name'),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
                              child: TextFormField(
                                controller: _lastNameController,
                                decoration: InputDecoration(
                                    prefixIcon: Icon(
                                      Icons.person,
                                    ),
                                    border: OutlineInputBorder(
                                      // width: 0.0 produces a thin "hairline" border
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(90.0),
                                      ),
                                      borderSide: BorderSide.none,

                                      //borderSide: const BorderSide(),
                                    ),
                                    hintStyle:
                                        TextStyle(fontFamily: "WorkSansLight"),
                                    filled: true,
                                    hintText: 'Last name'),
                              ),
                            ),
                          ],
                        ),
                      ),
                      FullWidthButtonWidget(
                        text: 'Update',
                        buttonColor: Colors.blue,
                        onPressed: () {
                          _editProfileBloc.add(
                            SuperAdminSubmitEvent(
                              firstName: _firstNameController.text,
                              lastName: _lastNameController.text,
                            ),
                          );
                        },
                        textColor: Colors.white,
                      )
                    ],
                  ),
                ),
              ),
            ),
          );
        }

        if (state is ErrorState) {
          return Container(
            child: Center(
              child: Text(
                state.error.toString(),
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
    locator<ModalService>().showInSnackBar(
      scaffoldKey: _scaffoldKey,
      message: message,
    );
  }

  @override
  void parentSetTextFields({UserModel user}) {
    _firstNameController.text = user.firstName;
    _lastNameController.text = user.lastName;
    _dobController.text = DateFormat('MMMM dd, yyyy').format(user.dob);
  }

  @override
  void superAdminSetTextFields({UserModel user}) {
    _firstNameController.text = user.firstName;
    _lastNameController.text = user.lastName;
  }

  @override
  void teacherSetTextFields({UserModel user}) {
    _firstNameController.text = user.firstName;
    _lastNameController.text = user.lastName;
    _schoolController.text = user.school;
  }
}