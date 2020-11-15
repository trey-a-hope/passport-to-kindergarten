import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:p/ServiceLocator.dart';
import 'package:p/constants.dart';
import 'package:p/models/UserModel.dart';
import 'package:p/services/ModalService.dart';
import 'package:p/services/ValidatorService.dart';
import 'package:p/widgets/AppBarWidget.dart';
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
  final TextEditingController _primaryParentFirstNameController =
      TextEditingController();
  final TextEditingController _primaryParentLastNameController =
      TextEditingController();
  final TextEditingController _secondaryParentFirstNameController =
      TextEditingController();
  final TextEditingController _secondaryParentLastNameController =
      TextEditingController();
  final TextEditingController _dobController = TextEditingController();
  final TextEditingController _schoolController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

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
            body: AnnotatedRegion<SystemUiOverlayStyle>(
              value: SystemUiOverlayStyle.light,
              child: Container(
                width: screenWidth,
                height: screenHeight,
                color: COLOR_CREAM,
                child: SafeArea(
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        AppBarWidget(title: 'Edit Profile'),
                        Expanded(
                          child: ListView(
                            children: [
                              Padding(
                                padding: EdgeInsets.all(10),
                                child: Text(
                                  'Teacher Info',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(color: COLOR_NAVY),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                                child: TextFormField(
                                  textCapitalization:
                                      TextCapitalization.sentences,
                                  autovalidateMode:
                                      AutovalidateMode.onUserInteraction,
                                  cursorColor: Colors.black,
                                  validator:
                                      locator<ValidatorService>().isEmpty,
                                  keyboardType: TextInputType.text,
                                  textInputAction: TextInputAction.done,
                                  controller: _firstNameController,
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontFamily: 'SFUIDisplay'),
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(),
                                    labelText: 'Teacher First Name',
                                    prefixIcon: Icon(Icons.person),
                                    labelStyle: TextStyle(fontSize: 15),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
                                child: TextFormField(
                                  textCapitalization:
                                      TextCapitalization.sentences,
                                  autovalidateMode:
                                      AutovalidateMode.onUserInteraction,
                                  cursorColor: Colors.black,
                                  validator:
                                      locator<ValidatorService>().isEmpty,
                                  keyboardType: TextInputType.text,
                                  textInputAction: TextInputAction.done,
                                  controller: _lastNameController,
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontFamily: 'SFUIDisplay'),
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(),
                                    labelText: 'Teacher Last Name',
                                    prefixIcon: Icon(Icons.person),
                                    labelStyle: TextStyle(fontSize: 15),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
                                child: TextFormField(
                                  textCapitalization:
                                      TextCapitalization.sentences,
                                  autovalidateMode:
                                      AutovalidateMode.onUserInteraction,
                                  cursorColor: Colors.black,
                                  validator:
                                      locator<ValidatorService>().isEmpty,
                                  keyboardType: TextInputType.text,
                                  textInputAction: TextInputAction.done,
                                  controller: _schoolController,
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontFamily: 'SFUIDisplay'),
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(),
                                    labelText: 'School',
                                    prefixIcon: Icon(Icons.person),
                                    labelStyle: TextStyle(fontSize: 15),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        FullWidthButtonWidget(
                          text: 'Update',
                          buttonColor: COLOR_NAVY,
                          onPressed: () async {
                            if (!_formKey.currentState.validate()) return;

                            bool confirm = await locator<ModalService>()
                                .showConfirmation(
                                    context: context,
                                    title: 'Submit',
                                    message: 'Are you sure?');

                            if (!confirm) return;

                            _editProfileBloc.add(
                              TeacherSubmitEvent(
                                firstName: _firstNameController.text,
                                lastName: _lastNameController.text,
                                school: _schoolController.text,
                              ),
                            );
                          },
                          textColor: Colors.white,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        }

        if (state is ParentLoadedState) {
          return Scaffold(
            key: _scaffoldKey,
            body: AnnotatedRegion<SystemUiOverlayStyle>(
              value: SystemUiOverlayStyle.light,
              child: Container(
                width: screenWidth,
                height: screenHeight,
                color: COLOR_CREAM,
                child: SafeArea(
                  child: Form(
                    key: state.formKey,
                    child: Column(
                      children: [
                        AppBarWidget(title: 'Edit Profile'),
                        Expanded(
                          child: ListView(
                            children: [
                              Padding(
                                padding: EdgeInsets.all(10),
                                child: Text(
                                  'Child Info',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(color: COLOR_NAVY),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                                child: TextFormField(
                                  textCapitalization:
                                      TextCapitalization.sentences,
                                  autovalidateMode:
                                      AutovalidateMode.onUserInteraction,
                                  cursorColor: Colors.black,
                                  validator:
                                      locator<ValidatorService>().isEmpty,
                                  keyboardType: TextInputType.text,
                                  textInputAction: TextInputAction.done,
                                  controller: _firstNameController,
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontFamily: 'SFUIDisplay'),
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(),
                                    labelText: 'Child First Name',
                                    prefixIcon: Icon(Icons.person),
                                    labelStyle: TextStyle(fontSize: 15),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
                                child: TextFormField(
                                  textCapitalization:
                                      TextCapitalization.sentences,
                                  autovalidateMode:
                                      AutovalidateMode.onUserInteraction,
                                  cursorColor: Colors.black,
                                  validator:
                                      locator<ValidatorService>().isEmpty,
                                  keyboardType: TextInputType.text,
                                  textInputAction: TextInputAction.done,
                                  controller: _lastNameController,
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontFamily: 'SFUIDisplay'),
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(),
                                    labelText: 'Child First Last',
                                    prefixIcon: Icon(Icons.person),
                                    labelStyle: TextStyle(fontSize: 15),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
                                child: TextFormField(
                                  onTap: () async {
                                    final DateTime picked =
                                        await showDatePicker(
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
                                  cursorColor: Colors.black,
                                  validator:
                                      locator<ValidatorService>().isEmpty,
                                  keyboardType: TextInputType.text,
                                  textInputAction: TextInputAction.done,
                                  controller: _dobController,
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontFamily: 'SFUIDisplay'),
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(),
                                    labelText: 'Child DOB',
                                    prefixIcon: Icon(Icons.calendar_today),
                                    labelStyle: TextStyle(fontSize: 15),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.all(10),
                                child: Text(
                                  'Primary Parent Info',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(color: COLOR_NAVY),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                                child: TextFormField(
                                  textCapitalization:
                                      TextCapitalization.sentences,
                                  autovalidateMode:
                                      AutovalidateMode.onUserInteraction,
                                  cursorColor: Colors.black,
                                  validator:
                                      locator<ValidatorService>().isEmpty,
                                  keyboardType: TextInputType.text,
                                  textInputAction: TextInputAction.done,
                                  controller: _primaryParentFirstNameController,
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontFamily: 'SFUIDisplay'),
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(),
                                    labelText: 'Primary Parent First Name',
                                    prefixIcon: Icon(Icons.person),
                                    labelStyle: TextStyle(fontSize: 15),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
                                child: TextFormField(
                                  textCapitalization:
                                      TextCapitalization.sentences,
                                  autovalidateMode:
                                      AutovalidateMode.onUserInteraction,
                                  cursorColor: Colors.black,
                                  validator:
                                      locator<ValidatorService>().isEmpty,
                                  keyboardType: TextInputType.text,
                                  textInputAction: TextInputAction.done,
                                  controller: _primaryParentLastNameController,
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontFamily: 'SFUIDisplay'),
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(),
                                    labelText: 'Primary Parent Last Name',
                                    prefixIcon: Icon(Icons.person),
                                    labelStyle: TextStyle(fontSize: 15),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.all(10),
                                child: Text(
                                  'Secondary Parent Info',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(color: COLOR_NAVY),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                                child: TextFormField(
                                  textCapitalization:
                                      TextCapitalization.sentences,
                                  autovalidateMode:
                                      AutovalidateMode.onUserInteraction,
                                  cursorColor: Colors.black,
                                  keyboardType: TextInputType.text,
                                  textInputAction: TextInputAction.done,
                                  controller:
                                      _secondaryParentFirstNameController,
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontFamily: 'SFUIDisplay'),
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(),
                                    labelText: 'Secondary Parent First Name',
                                    prefixIcon: Icon(Icons.person),
                                    labelStyle: TextStyle(fontSize: 15),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
                                child: TextFormField(
                                  textCapitalization:
                                      TextCapitalization.sentences,
                                  autovalidateMode:
                                      AutovalidateMode.onUserInteraction,
                                  cursorColor: Colors.black,
                                  keyboardType: TextInputType.text,
                                  textInputAction: TextInputAction.done,
                                  controller:
                                      _secondaryParentLastNameController,
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontFamily: 'SFUIDisplay'),
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(),
                                    labelText: 'Secondary Parent Last Name',
                                    prefixIcon: Icon(Icons.person),
                                    labelStyle: TextStyle(fontSize: 15),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        FullWidthButtonWidget(
                          text: 'Update',
                          buttonColor: COLOR_NAVY,
                          onPressed: () async {
                            if (!_formKey.currentState.validate()) return;

                            bool confirm = await locator<ModalService>()
                                .showConfirmation(
                                    context: context,
                                    title: 'Submit',
                                    message: 'Are you sure?');

                            if (!confirm) return;
                            _editProfileBloc.add(
                              ParentSubmitEvent(
                                firstName: _firstNameController.text,
                                lastName: _lastNameController.text,
                                primaryParentFirstName:
                                    _primaryParentFirstNameController.text,
                                primaryParentLastName:
                                    _primaryParentLastNameController.text,
                                secondaryParentFirstName:
                                    _secondaryParentFirstNameController.text,
                                secondaryParentLastName:
                                    _secondaryParentLastNameController.text,
                              ),
                            );
                          },
                          textColor: Colors.white,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        }

        if (state is SuperAdminLoadedState) {
          return Scaffold(
            key: _scaffoldKey,
            body: AnnotatedRegion<SystemUiOverlayStyle>(
              value: SystemUiOverlayStyle.light,
              child: Container(
                width: screenWidth,
                height: screenHeight,
                color: COLOR_CREAM,
                child: SafeArea(
                  child: Form(
                    key: state.formKey,
                    child: Column(
                      children: [
                        AppBarWidget(title: 'Edit Profile'),
                        Expanded(
                          child: ListView(
                            children: [
                              Padding(
                                padding: EdgeInsets.all(10),
                                child: Text(
                                  'Super Admin Info',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(color: COLOR_NAVY),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                                child: TextFormField(
                                  textCapitalization:
                                      TextCapitalization.sentences,
                                  autovalidateMode:
                                      AutovalidateMode.onUserInteraction,
                                  cursorColor: Colors.black,
                                  validator:
                                      locator<ValidatorService>().isEmpty,
                                  keyboardType: TextInputType.text,
                                  textInputAction: TextInputAction.done,
                                  controller: _firstNameController,
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontFamily: 'SFUIDisplay'),
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(),
                                    labelText: 'Super Admin First Name',
                                    prefixIcon: Icon(Icons.person),
                                    labelStyle: TextStyle(fontSize: 15),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
                                child: TextFormField(
                                  autovalidate: state.autoValidate,
                                  cursorColor: Colors.black,
                                  validator:
                                      locator<ValidatorService>().isEmpty,
                                  keyboardType: TextInputType.text,
                                  textInputAction: TextInputAction.done,
                                  controller: _lastNameController,
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontFamily: 'SFUIDisplay'),
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(),
                                    labelText: 'Super Admin Last Name',
                                    prefixIcon: Icon(Icons.person),
                                    labelStyle: TextStyle(fontSize: 15),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        FullWidthButtonWidget(
                          text: 'Update',
                          buttonColor: COLOR_NAVY,
                          onPressed: () async {
                            if (!_formKey.currentState.validate()) return;

                            bool confirm = await locator<ModalService>()
                                .showConfirmation(
                                    context: context,
                                    title: 'Submit',
                                    message: 'Are you sure?');

                            if (!confirm) return;
                            _editProfileBloc.add(
                              SuperAdminSubmitEvent(
                                firstName: _firstNameController.text,
                                lastName: _lastNameController.text,
                              ),
                            );
                          },
                          textColor: Colors.white,
                        ),
                      ],
                    ),
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
  void parentSetTextFields({
    UserModel user,
  }) {
    _firstNameController.text = user.firstName;
    _lastNameController.text = user.lastName;
    _dobController.text = DateFormat('MMMM dd, yyyy').format(user.dob);
    _primaryParentFirstNameController.text = user.primaryParentFirstName;
    _primaryParentLastNameController.text = user.primaryParentLastName;
    _secondaryParentFirstNameController.text = user.secondaryParentFirstName;
    _secondaryParentLastNameController.text = user.secondaryParentLastName;
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
