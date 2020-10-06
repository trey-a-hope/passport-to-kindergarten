import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:p/constants.dart';
import 'package:p/extensions/HexColorExtension.dart';
import 'package:p/models/UserModel.dart';
import 'package:p/services/ModalService.dart';
import 'package:p/services/StorageService.dart';
import 'package:p/services/ValidatorService.dart';
import 'package:p/widgets/FullWidthButtonWidget.dart';
import 'package:p/widgets/SpinnerWidget.dart';
import '../../ServiceLocator.dart';
import 'Bloc.dart';
import 'package:p/blocs/login/Bloc.dart' as LOGIN_BP;
import 'package:p/blocs/searchTeachers/Bloc.dart' as SEARCH_TEACHERS_BP;

class SignupPage extends StatefulWidget {
  @override
  State createState() => SignupPageState();
}

class SignupPageState extends State<SignupPage>
    with SingleTickerProviderStateMixin
    implements SignupBlocDelegate {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _schoolController = TextEditingController();
  final TextEditingController _dobController = TextEditingController();
  final TextEditingController _teacherController = TextEditingController();
  final TextEditingController _superAdminSecretKeyController =
      TextEditingController();

  final TextEditingController _firstParentFirstNameController =
      TextEditingController();

  final TextEditingController _firstParentLastNameController =
      TextEditingController();

  final TextEditingController _secondParentFirstNameController =
      TextEditingController();

  final TextEditingController _secondParentLastNameController =
      TextEditingController();

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _autoValidate = false;
  File _image;

  SignupBloc _signupBloc;

  void fillFormsWithDummyData() {
    this._firstNameController.text = 'Trey';
    this._lastNameController.text = 'Hope';
    this._schoolController.text = 'Trotwood-Madison';
    this._emailController.text = 'trey.a.hope@gmail.com';
    this._passwordController.text = 'Peachy33';
    this._firstParentFirstNameController.text = 'Sonya';
    this._firstParentLastNameController.text = 'Hawkins';
    this._secondParentFirstNameController.text = 'Tim';
    this._secondParentLastNameController.text = 'Borrows';
    this._superAdminSecretKeyController.text = 'XXX';
  }

  @override
  void initState() {
    _signupBloc = BlocProvider.of<SignupBloc>(context);
    _signupBloc.setDelegate(delegate: this);
    super.initState();
  }

  Widget _buttonRowWidget({
    @required PROFILE_TYPE profile_type,
  }) {
    bool isTeacher = profile_type.name == PROFILE_TYPE.TEACHER.name;
    bool isParent = profile_type.name == PROFILE_TYPE.PARENT.name;
    bool isSuperAdmin = profile_type.name == PROFILE_TYPE.SUPER_ADMIN.name;

    return Column(
      children: [
        Text(
          'I am a...',
          style: TextStyle(color: Colors.white, fontSize: 21),
        ),
        Row(
          children: [
            Expanded(
              child: Padding(
                padding: EdgeInsets.all(10),
                child: FullWidthButtonWidget(
                  buttonColor: isTeacher ? Colors.white : Colors.red,
                  text: 'Teacher',
                  textColor: isTeacher ? Colors.red : Colors.white,
                  onPressed: () {
                    _signupBloc.add(
                      ToggleProfileTypeEvent(profileType: PROFILE_TYPE.TEACHER),
                    );
                  },
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.all(10),
                child: FullWidthButtonWidget(
                  buttonColor: isParent ? Colors.white : Colors.red,
                  text: 'Parent',
                  textColor: isParent ? Colors.red : Colors.white,
                  onPressed: () {
                    _signupBloc.add(
                      ToggleProfileTypeEvent(profileType: PROFILE_TYPE.PARENT),
                    );
                  },
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.all(10),
                child: FullWidthButtonWidget(
                  buttonColor: isSuperAdmin ? Colors.white : Colors.red,
                  text: 'Admin',
                  textColor: isSuperAdmin ? Colors.red : Colors.white,
                  onPressed: () {
                    _signupBloc.add(
                      ToggleProfileTypeEvent(
                          profileType: PROFILE_TYPE.SUPER_ADMIN),
                    );
                  },
                ),
              ),
            )
          ],
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      key: _scaffoldKey,
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: Container(
          width: screenWidth,
          height: screenHeight,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(ASSET_IMAGE_SPLASH_BACKGROUND),
              fit: BoxFit.cover,
            ),
          ),
          child: SafeArea(
            child: BlocBuilder<SignupBloc, SignupState>(
              builder: (BuildContext context, SignupState state) {
                if (state is SigningIn) {
                  return SpinnerWidget();
                }

                if (state is TeacherState) {
                  return Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        InkWell(
                          onTap: () {
                            fillFormsWithDummyData();
                          },
                          child: Column(
                            children: [
                              Image.asset(ASSET_IMAGE_P2K_LOGO),
                              const SizedBox(
                                height: 50,
                              ),
                            ],
                          ),
                        ),
                        _buttonRowWidget(profile_type: PROFILE_TYPE.TEACHER),
                        Expanded(
                          child: ListView(
                            children: [
                              Text(
                                'Teacher Info',
                                textAlign: TextAlign.center,
                                style: TextStyle(color: Colors.white),
                              ),
                              Row(
                                children: [
                                  Expanded(
                                    child: Padding(
                                      padding: EdgeInsets.all(10),
                                      child: TextFormField(
                                        autovalidate: _autoValidate,
                                        validator:
                                            locator<ValidatorService>().isEmpty,
                                        keyboardType: TextInputType.text,
                                        textInputAction: TextInputAction.done,
                                        controller: _firstNameController,
                                        style: TextStyle(color: Colors.white),
                                        onChanged: (val) {
                                          _formKey.currentState.validate();
                                        },
                                        decoration: InputDecoration(
                                            prefixIcon: Icon(
                                              Icons.person,
                                              color: Colors.white,
                                            ),
                                            border: OutlineInputBorder(
                                              // width: 0.0 produces a thin "hairline" border
                                              borderRadius: BorderRadius.all(
                                                Radius.circular(90.0),
                                              ),
                                              borderSide: BorderSide.none,

                                              //borderSide: const BorderSide(),
                                            ),
                                            hintStyle: TextStyle(
                                                color: Colors.white,
                                                fontFamily: "WorkSansLight"),
                                            filled: true,
                                            fillColor: Colors.white24,
                                            hintText: 'First Name'),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Padding(
                                      padding: EdgeInsets.all(10),
                                      child: TextFormField(
                                        autovalidate: _autoValidate,
                                        validator:
                                            locator<ValidatorService>().isEmpty,
                                        keyboardType: TextInputType.text,
                                        textInputAction: TextInputAction.done,
                                        onChanged: (val) {
                                          _formKey.currentState.validate();
                                        },
                                        controller: _lastNameController,
                                        style: TextStyle(color: Colors.white),
                                        decoration: InputDecoration(
                                            prefixIcon: Icon(
                                              Icons.person,
                                              color: Colors.white,
                                            ),
                                            border: OutlineInputBorder(
                                              // width: 0.0 produces a thin "hairline" border
                                              borderRadius: BorderRadius.all(
                                                Radius.circular(90.0),
                                              ),
                                              borderSide: BorderSide.none,

                                              //borderSide: const BorderSide(),
                                            ),
                                            hintStyle: TextStyle(
                                                color: Colors.white,
                                                fontFamily: "WorkSansLight"),
                                            filled: true,
                                            fillColor: Colors.white24,
                                            hintText: 'Last Name'),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Padding(
                                padding: EdgeInsets.all(10),
                                child: TextFormField(
                                  autovalidate: _autoValidate,
                                  validator:
                                      locator<ValidatorService>().isEmpty,
                                  keyboardType: TextInputType.text,
                                  textInputAction: TextInputAction.done,
                                  onChanged: (val) {
                                    _formKey.currentState.validate();
                                  },
                                  controller: _schoolController,
                                  style: TextStyle(color: Colors.white),
                                  decoration: InputDecoration(
                                      prefixIcon: Icon(
                                        Icons.school,
                                        color: Colors.white,
                                      ),
                                      border: OutlineInputBorder(
                                        // width: 0.0 produces a thin "hairline" border
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(90.0),
                                        ),
                                        borderSide: BorderSide.none,

                                        //borderSide: const BorderSide(),
                                      ),
                                      hintStyle: TextStyle(
                                          color: Colors.white,
                                          fontFamily: "WorkSansLight"),
                                      filled: true,
                                      fillColor: Colors.white24,
                                      hintText: 'School'),
                                ),
                              ),
                              Text(
                                'Basic Info',
                                textAlign: TextAlign.center,
                                style: TextStyle(color: Colors.white),
                              ),
                              Padding(
                                padding: EdgeInsets.all(10),
                                child: TextFormField(
                                  autovalidate: _autoValidate,
                                  validator: locator<ValidatorService>().email,
                                  keyboardType: TextInputType.emailAddress,
                                  textInputAction: TextInputAction.done,
                                  onChanged: (val) {
                                    _formKey.currentState.validate();
                                  },
                                  controller: _emailController,
                                  style: TextStyle(color: Colors.white),
                                  decoration: InputDecoration(
                                      prefixIcon: Icon(
                                        Icons.alternate_email,
                                        color: Colors.white,
                                      ),
                                      border: OutlineInputBorder(
                                        // width: 0.0 produces a thin "hairline" border
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(90.0),
                                        ),
                                        borderSide: BorderSide.none,

                                        //borderSide: const BorderSide(),
                                      ),
                                      hintStyle: TextStyle(
                                          color: Colors.white,
                                          fontFamily: "WorkSansLight"),
                                      filled: true,
                                      fillColor: Colors.white24,
                                      hintText: 'Email'),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.all(10),
                                child: TextFormField(
                                  obscureText: true,
                                  autovalidate: _autoValidate,
                                  validator:
                                      locator<ValidatorService>().password,
                                  keyboardType: TextInputType.visiblePassword,
                                  textInputAction: TextInputAction.done,
                                  onChanged: (val) {
                                    _formKey.currentState.validate();
                                  },
                                  controller: _passwordController,
                                  style: TextStyle(color: Colors.white),
                                  decoration: InputDecoration(
                                      prefixIcon: Icon(
                                        Icons.lock,
                                        color: Colors.white,
                                      ),
                                      border: OutlineInputBorder(
                                        // width: 0.0 produces a thin "hairline" border
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(90.0),
                                        ),
                                        borderSide: BorderSide.none,

                                        //borderSide: const BorderSide(),
                                      ),
                                      hintStyle: TextStyle(
                                          color: Colors.white,
                                          fontFamily: "WorkSansLight"),
                                      filled: true,
                                      fillColor: Colors.white24,
                                      hintText: 'Password'),
                                ),
                              ),
                            ],
                          ),
                        ),
                        FullWidthButtonWidget(
                          buttonColor: HexColorExtension('ff4880'),
                          text: 'Sign Up',
                          textColor: Colors.white,
                          onPressed: () async {
                            bool confirm = await locator<ModalService>()
                                .showConfirmation(
                                    context: context,
                                    title: 'Submit',
                                    message: 'Are you sure?');

                            if (!confirm) return;

                            _signupBloc.add(
                              TeacherSignupEvent(
                                email: _emailController.text,
                                password: _passwordController.text,
                                firstName: _firstNameController.text,
                                lastName: _lastNameController.text,
                                school: _schoolController.text,
                              ),
                            );
                          },
                        ),
                        Padding(
                          padding: EdgeInsets.all(10),
                          child: InkWell(
                            onTap: () {
                              Route route = MaterialPageRoute(
                                builder: (BuildContext context) => BlocProvider(
                                  create: (BuildContext context) =>
                                      LOGIN_BP.LoginBloc()
                                        ..add(
                                          LOGIN_BP.LoadPageEvent(),
                                        ),
                                  child: LOGIN_BP.LoginPage(),
                                ),
                              );
                              Navigator.pushReplacement(context, route);
                            },
                            child: RichText(
                              text: TextSpan(
                                style: TextStyle(fontWeight: FontWeight.bold),
                                children: [
                                  TextSpan(
                                      text: 'Already have an account?',
                                      style: TextStyle(color: Colors.grey)),
                                  TextSpan(text: ' Log in')
                                ],
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  );
                }

                if (state is ParentState) {
                  return Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        InkWell(
                          onTap: () {
                            fillFormsWithDummyData();
                          },
                          child: Column(
                            children: [
                              Image.asset(ASSET_IMAGE_P2K_LOGO),
                              const SizedBox(
                                height: 50,
                              ),
                            ],
                          ),
                        ),
                        _buttonRowWidget(profile_type: PROFILE_TYPE.PARENT),
                        Expanded(
                          child: ListView(
                            children: [
                              Text(
                                'Child Info',
                                textAlign: TextAlign.center,
                                style: TextStyle(color: Colors.white),
                              ),
                              //CHILD FIRST AND LAST NAME
                              Row(
                                children: [
                                  Expanded(
                                    child: Padding(
                                      padding: EdgeInsets.all(10),
                                      child: TextFormField(
                                        autovalidate: _autoValidate,
                                        validator:
                                            locator<ValidatorService>().isEmpty,
                                        keyboardType: TextInputType.text,
                                        textInputAction: TextInputAction.done,
                                        onChanged: (val) {
                                          _formKey.currentState.validate();
                                        },
                                        controller: _firstNameController,
                                        style: TextStyle(color: Colors.white),
                                        decoration: InputDecoration(
                                            prefixIcon: Icon(
                                              Icons.person,
                                              color: Colors.white,
                                            ),
                                            border: OutlineInputBorder(
                                              // width: 0.0 produces a thin "hairline" border
                                              borderRadius: BorderRadius.all(
                                                Radius.circular(90.0),
                                              ),
                                              borderSide: BorderSide.none,

                                              //borderSide: const BorderSide(),
                                            ),
                                            hintStyle: TextStyle(
                                                color: Colors.white,
                                                fontFamily: "WorkSansLight"),
                                            filled: true,
                                            fillColor: Colors.white24,
                                            hintText: 'First Name'),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Padding(
                                      padding: EdgeInsets.all(10),
                                      child: TextFormField(
                                        autovalidate: _autoValidate,
                                        validator:
                                            locator<ValidatorService>().isEmpty,
                                        keyboardType: TextInputType.text,
                                        textInputAction: TextInputAction.done,
                                        onChanged: (val) {
                                          _formKey.currentState.validate();
                                        },
                                        controller: _lastNameController,
                                        style: TextStyle(color: Colors.white),
                                        decoration: InputDecoration(
                                            prefixIcon: Icon(
                                              Icons.person,
                                              color: Colors.white,
                                            ),
                                            border: OutlineInputBorder(
                                              // width: 0.0 produces a thin "hairline" border
                                              borderRadius: BorderRadius.all(
                                                Radius.circular(90.0),
                                              ),
                                              borderSide: BorderSide.none,

                                              //borderSide: const BorderSide(),
                                            ),
                                            hintStyle: TextStyle(
                                                color: Colors.white,
                                                fontFamily: "WorkSansLight"),
                                            filled: true,
                                            fillColor: Colors.white24,
                                            hintText: 'Last Name'),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                              //Last Name
                              Padding(
                                padding: EdgeInsets.all(10),
                                child: TextFormField(
                                  keyboardType: TextInputType.text,
                                  textInputAction: TextInputAction.done,
                                  onChanged: (val) {
                                    _formKey.currentState.validate();
                                  },
                                  onTap: () async {
                                    final DateTime now = DateTime.now();

                                    final DateTime picked =
                                        await showDatePicker(
                                      context: context,
                                      initialDate: state.selectedDate,
                                      firstDate: DateTime(now.year - 5),
                                      lastDate: DateTime(now.year - 2),
                                    );

                                    if (picked != null &&
                                        picked != state.selectedDate) {
                                      _signupBloc.add(
                                        SelectDateEvent(selectedDate: picked),
                                      );
                                      print(picked.toString());

                                      String formattedDate =
                                          DateFormat('MMMM dd, yyyy')
                                              .format(picked);
                                      _dobController.text = formattedDate;
                                    }
                                  },
                                  controller: _dobController,
                                  style: TextStyle(color: Colors.white),
                                  decoration: InputDecoration(
                                      prefixIcon: Icon(
                                        Icons.calendar_today,
                                        color: Colors.white,
                                      ),
                                      border: OutlineInputBorder(
                                        // width: 0.0 produces a thin "hairline" border
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(90.0),
                                        ),
                                        borderSide: BorderSide.none,

                                        //borderSide: const BorderSide(),
                                      ),
                                      hintStyle: TextStyle(
                                          color: Colors.white,
                                          fontFamily: "WorkSansLight"),
                                      filled: true,
                                      fillColor: Colors.white24,
                                      hintText: 'Child\'s DOB'),
                                ),
                              ),
                              Text(
                                'Primary Parent Info',
                                textAlign: TextAlign.center,
                                style: TextStyle(color: Colors.white),
                              ),
                              Row(
                                children: [
                                  Expanded(
                                    child: Padding(
                                      padding: EdgeInsets.all(10),
                                      child: TextFormField(
                                        autovalidate: _autoValidate,
                                        validator:
                                            locator<ValidatorService>().isEmpty,
                                        keyboardType: TextInputType.text,
                                        textInputAction: TextInputAction.done,
                                        onChanged: (val) {
                                          _formKey.currentState.validate();
                                        },
                                        controller:
                                            _firstParentFirstNameController,
                                        style: TextStyle(color: Colors.white),
                                        decoration: InputDecoration(
                                            prefixIcon: Icon(
                                              Icons.person,
                                              color: Colors.white,
                                            ),
                                            border: OutlineInputBorder(
                                              // width: 0.0 produces a thin "hairline" border
                                              borderRadius: BorderRadius.all(
                                                Radius.circular(90.0),
                                              ),
                                              borderSide: BorderSide.none,

                                              //borderSide: const BorderSide(),
                                            ),
                                            hintStyle: TextStyle(
                                                color: Colors.white,
                                                fontFamily: "WorkSansLight"),
                                            filled: true,
                                            fillColor: Colors.white24,
                                            hintText: 'First Name'),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Padding(
                                      padding: EdgeInsets.all(10),
                                      child: TextFormField(
                                        keyboardType: TextInputType.text,
                                        textInputAction: TextInputAction.done,
                                        controller:
                                            _firstParentLastNameController,
                                        style: TextStyle(color: Colors.white),
                                        decoration: InputDecoration(
                                            prefixIcon: Icon(
                                              Icons.person,
                                              color: Colors.white,
                                            ),
                                            border: OutlineInputBorder(
                                              // width: 0.0 produces a thin "hairline" border
                                              borderRadius: BorderRadius.all(
                                                Radius.circular(90.0),
                                              ),
                                              borderSide: BorderSide.none,

                                              //borderSide: const BorderSide(),
                                            ),
                                            hintStyle: TextStyle(
                                                color: Colors.white,
                                                fontFamily: "WorkSansLight"),
                                            filled: true,
                                            fillColor: Colors.white24,
                                            hintText: 'Last Name'),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                              Text(
                                'Secondary Parent Info',
                                textAlign: TextAlign.center,
                                style: TextStyle(color: Colors.white),
                              ),
                              Row(
                                children: [
                                  Expanded(
                                    child: Padding(
                                      padding: EdgeInsets.all(10),
                                      child: TextFormField(
                                        autovalidate: _autoValidate,
                                        validator:
                                            locator<ValidatorService>().isEmpty,
                                        keyboardType: TextInputType.text,
                                        textInputAction: TextInputAction.done,
                                        onChanged: (val) {
                                          _formKey.currentState.validate();
                                        },
                                        controller:
                                            _secondParentFirstNameController,
                                        style: TextStyle(color: Colors.white),
                                        decoration: InputDecoration(
                                            prefixIcon: Icon(
                                              Icons.person,
                                              color: Colors.white,
                                            ),
                                            border: OutlineInputBorder(
                                              // width: 0.0 produces a thin "hairline" border
                                              borderRadius: BorderRadius.all(
                                                Radius.circular(90.0),
                                              ),
                                              borderSide: BorderSide.none,

                                              //borderSide: const BorderSide(),
                                            ),
                                            hintStyle: TextStyle(
                                                color: Colors.white,
                                                fontFamily: "WorkSansLight"),
                                            filled: true,
                                            fillColor: Colors.white24,
                                            hintText: 'First Name'),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Padding(
                                      padding: EdgeInsets.all(10),
                                      child: TextFormField(
                                        autovalidate: _autoValidate,
                                        validator:
                                            locator<ValidatorService>().isEmpty,
                                        keyboardType: TextInputType.text,
                                        textInputAction: TextInputAction.done,
                                        onChanged: (val) {
                                          _formKey.currentState.validate();
                                        },
                                        controller:
                                            _secondParentLastNameController,
                                        style: TextStyle(color: Colors.white),
                                        decoration: InputDecoration(
                                            prefixIcon: Icon(
                                              Icons.person,
                                              color: Colors.white,
                                            ),
                                            border: OutlineInputBorder(
                                              // width: 0.0 produces a thin "hairline" border
                                              borderRadius: BorderRadius.all(
                                                Radius.circular(90.0),
                                              ),
                                              borderSide: BorderSide.none,

                                              //borderSide: const BorderSide(),
                                            ),
                                            hintStyle: TextStyle(
                                                color: Colors.white,
                                                fontFamily: "WorkSansLight"),
                                            filled: true,
                                            fillColor: Colors.white24,
                                            hintText: 'Last Name'),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                              Text(
                                'Basic Info',
                                textAlign: TextAlign.center,
                                style: TextStyle(color: Colors.white),
                              ),
                              Padding(
                                padding: EdgeInsets.all(10),
                                child: TextFormField(
                                  autovalidate: _autoValidate,
                                  validator: locator<ValidatorService>().email,
                                  keyboardType: TextInputType.text,
                                  textInputAction: TextInputAction.done,
                                  onChanged: (val) {
                                    _formKey.currentState.validate();
                                  },
                                  controller: _emailController,
                                  style: TextStyle(color: Colors.white),
                                  decoration: InputDecoration(
                                      prefixIcon: Icon(
                                        Icons.alternate_email,
                                        color: Colors.white,
                                      ),
                                      border: OutlineInputBorder(
                                        // width: 0.0 produces a thin "hairline" border
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(90.0),
                                        ),
                                        borderSide: BorderSide.none,

                                        //borderSide: const BorderSide(),
                                      ),
                                      hintStyle: TextStyle(
                                          color: Colors.white,
                                          fontFamily: "WorkSansLight"),
                                      filled: true,
                                      fillColor: Colors.white24,
                                      hintText: 'Email'),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.all(10),
                                child: TextFormField(
                                  obscureText: true,
                                  autovalidate: _autoValidate,
                                  validator:
                                      locator<ValidatorService>().password,
                                  keyboardType: TextInputType.visiblePassword,
                                  textInputAction: TextInputAction.done,
                                  onChanged: (val) {
                                    _formKey.currentState.validate();
                                  },
                                  controller: _passwordController,
                                  style: TextStyle(color: Colors.white),
                                  decoration: InputDecoration(
                                      prefixIcon: Icon(
                                        Icons.lock,
                                        color: Colors.white,
                                      ),
                                      border: OutlineInputBorder(
                                        // width: 0.0 produces a thin "hairline" border
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(90.0),
                                        ),
                                        borderSide: BorderSide.none,

                                        //borderSide: const BorderSide(),
                                      ),
                                      hintStyle: TextStyle(
                                          color: Colors.white,
                                          fontFamily: "WorkSansLight"),
                                      filled: true,
                                      fillColor: Colors.white24,
                                      hintText: 'Password'),
                                ),
                              ),

                              Padding(
                                padding: EdgeInsets.all(10),
                                child: TextFormField(
                                  autovalidate: _autoValidate,
                                  onTap: () async {
                                    final SEARCH_TEACHERS_BP
                                            .SearchTeachersRepository
                                        _searchTeachersRepository =
                                        SEARCH_TEACHERS_BP
                                            .SearchTeachersRepository(
                                      cache: SEARCH_TEACHERS_BP
                                          .SearchTeachersCache(),
                                    );

                                    Route route = MaterialPageRoute(
                                      builder: (BuildContext context) =>
                                          BlocProvider(
                                        create: (BuildContext context) =>
                                            SEARCH_TEACHERS_BP.SearchTeachersBloc(
                                                searchTeachersRepository:
                                                    _searchTeachersRepository)
                                              ..add(
                                                SEARCH_TEACHERS_BP
                                                    .LoadPageEvent(),
                                              ),
                                        child: SEARCH_TEACHERS_BP
                                            .SearchTeachersPage(),
                                      ),
                                    );

                                    final result =
                                        await Navigator.push(context, route);

                                    final selectedTeacher = result as UserModel;

                                    _signupBloc.add(
                                      SelectTeacherEvent(
                                          selectedTeacher: selectedTeacher),
                                    );

                                    _teacherController.text =
                                        '${selectedTeacher.firstName} ${selectedTeacher.lastName}';
                                  },
                                  controller: _teacherController,
                                  style: TextStyle(color: Colors.white),
                                  decoration: InputDecoration(
                                      prefixIcon: Icon(
                                        Icons.book,
                                        color: Colors.white,
                                      ),
                                      border: OutlineInputBorder(
                                        // width: 0.0 produces a thin "hairline" border
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(90.0),
                                        ),
                                        borderSide: BorderSide.none,

                                        //borderSide: const BorderSide(),
                                      ),
                                      hintStyle: TextStyle(
                                          color: Colors.white,
                                          fontFamily: "WorkSansLight"),
                                      filled: true,
                                      fillColor: Colors.white24,
                                      hintText: 'Teacher'),
                                ),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  CircleAvatar(
                                    radius: 40,
                                    backgroundImage: _image == null
                                        ? NetworkImage(DUMMY_PROFILE_PHOTO_URL)
                                        : Image.file(_image).image,
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  RaisedButton(
                                    color: Colors.teal,
                                    onPressed: () {
                                      showSelectImageDialog();
                                    },
                                    child: Text(
                                      'Upload Photo of Child',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  )
                                ],
                              ),
                              SizedBox(
                                height: 20,
                              ),
                            ],
                          ),
                        ),
                        FullWidthButtonWidget(
                          buttonColor: HexColorExtension('ff4880'),
                          text: 'Sign Up',
                          textColor: Colors.white,
                          onPressed: () async {
                            bool confirm = await locator<ModalService>()
                                .showConfirmation(
                                    context: context,
                                    title: 'Submit',
                                    message: 'Are you sure?');

                            if (!confirm) return;

                            _signupBloc.add(
                              ParentSignupEvent(
                                email: _emailController.text,
                                password: _passwordController.text,
                                firstName: _firstNameController.text,
                                lastName: _lastNameController.text,
                                school: null,
                                firstParentFirstName:
                                    _firstParentFirstNameController.text,
                                firstParentLastName:
                                    _firstParentLastNameController.text,
                                secondParentFirstName:
                                    _secondParentFirstNameController.text,
                                secondParentLastName:
                                    _secondParentLastNameController.text,
                              ),
                            );
                          },
                        ),
                        Padding(
                          padding: EdgeInsets.all(10),
                          child: InkWell(
                            onTap: () {
                              Navigator.of(context).pop();
                            },
                            child: RichText(
                              text: TextSpan(
                                style: TextStyle(fontWeight: FontWeight.bold),
                                children: [
                                  TextSpan(
                                      text: 'Already have an account?',
                                      style: TextStyle(color: Colors.grey)),
                                  TextSpan(text: ' Log in')
                                ],
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  );
                }

                if (state is SuperAdminState) {
                  return Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        InkWell(
                          onTap: () {
                            fillFormsWithDummyData();
                          },
                          child: Column(
                            children: [
                              Image.asset(ASSET_IMAGE_P2K_LOGO),
                              const SizedBox(
                                height: 50,
                              ),
                            ],
                          ),
                        ),
                        _buttonRowWidget(
                            profile_type: PROFILE_TYPE.SUPER_ADMIN),
                        Expanded(
                          child: ListView(
                            children: [
                              Text(
                                'Super Admin Info',
                                textAlign: TextAlign.center,
                                style: TextStyle(color: Colors.white),
                              ),
                              Row(
                                children: [
                                  Expanded(
                                    child: Padding(
                                      padding: EdgeInsets.all(10),
                                      child: TextFormField(
                                        autovalidate: _autoValidate,
                                        validator:
                                            locator<ValidatorService>().isEmpty,
                                        keyboardType: TextInputType.text,
                                        textInputAction: TextInputAction.done,
                                        onChanged: (val) {
                                          _formKey.currentState.validate();
                                        },
                                        controller: _firstNameController,
                                        style: TextStyle(color: Colors.white),
                                        decoration: InputDecoration(
                                            prefixIcon: Icon(
                                              Icons.person,
                                              color: Colors.white,
                                            ),
                                            border: OutlineInputBorder(
                                              // width: 0.0 produces a thin "hairline" border
                                              borderRadius: BorderRadius.all(
                                                Radius.circular(90.0),
                                              ),
                                              borderSide: BorderSide.none,

                                              //borderSide: const BorderSide(),
                                            ),
                                            hintStyle: TextStyle(
                                                color: Colors.white,
                                                fontFamily: "WorkSansLight"),
                                            filled: true,
                                            fillColor: Colors.white24,
                                            hintText: 'First Name'),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Padding(
                                      padding: EdgeInsets.all(10),
                                      child: TextFormField(
                                        autovalidate: _autoValidate,
                                        validator:
                                            locator<ValidatorService>().isEmpty,
                                        keyboardType: TextInputType.text,
                                        textInputAction: TextInputAction.done,
                                        onChanged: (val) {
                                          _formKey.currentState.validate();
                                        },
                                        controller: _lastNameController,
                                        style: TextStyle(color: Colors.white),
                                        decoration: InputDecoration(
                                            prefixIcon: Icon(
                                              Icons.person,
                                              color: Colors.white,
                                            ),
                                            border: OutlineInputBorder(
                                              // width: 0.0 produces a thin "hairline" border
                                              borderRadius: BorderRadius.all(
                                                Radius.circular(90.0),
                                              ),
                                              borderSide: BorderSide.none,

                                              //borderSide: const BorderSide(),
                                            ),
                                            hintStyle: TextStyle(
                                                color: Colors.white,
                                                fontFamily: "WorkSansLight"),
                                            filled: true,
                                            fillColor: Colors.white24,
                                            hintText: 'Last Name'),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Text(
                                'Basic Info',
                                textAlign: TextAlign.center,
                                style: TextStyle(color: Colors.white),
                              ),
                              Padding(
                                padding: EdgeInsets.all(10),
                                child: TextFormField(
                                  autovalidate: _autoValidate,
                                  validator: locator<ValidatorService>().email,
                                  keyboardType: TextInputType.text,
                                  textInputAction: TextInputAction.done,
                                  onChanged: (val) {
                                    _formKey.currentState.validate();
                                  },
                                  controller: _emailController,
                                  style: TextStyle(color: Colors.white),
                                  decoration: InputDecoration(
                                      prefixIcon: Icon(
                                        Icons.alternate_email,
                                        color: Colors.white,
                                      ),
                                      border: OutlineInputBorder(
                                        // width: 0.0 produces a thin "hairline" border
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(90.0),
                                        ),
                                        borderSide: BorderSide.none,

                                        //borderSide: const BorderSide(),
                                      ),
                                      hintStyle: TextStyle(
                                          color: Colors.white,
                                          fontFamily: "WorkSansLight"),
                                      filled: true,
                                      fillColor: Colors.white24,
                                      hintText: 'Email'),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.all(10),
                                child: TextFormField(
                                  obscureText: true,
                                  autovalidate: _autoValidate,
                                  validator:
                                      locator<ValidatorService>().password,
                                  keyboardType: TextInputType.text,
                                  textInputAction: TextInputAction.done,
                                  onChanged: (val) {
                                    _formKey.currentState.validate();
                                  },
                                  controller: _passwordController,
                                  style: TextStyle(color: Colors.white),
                                  decoration: InputDecoration(
                                      prefixIcon: Icon(
                                        Icons.lock,
                                        color: Colors.white,
                                      ),
                                      border: OutlineInputBorder(
                                        // width: 0.0 produces a thin "hairline" border
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(90.0),
                                        ),
                                        borderSide: BorderSide.none,

                                        //borderSide: const BorderSide(),
                                      ),
                                      hintStyle: TextStyle(
                                          color: Colors.white,
                                          fontFamily: "WorkSansLight"),
                                      filled: true,
                                      fillColor: Colors.white24,
                                      hintText: 'Password'),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.all(10),
                                child: TextFormField(
                                  autovalidate: _autoValidate,
                                  validator:
                                      locator<ValidatorService>().isEmpty,
                                  keyboardType: TextInputType.text,
                                  textInputAction: TextInputAction.done,
                                  onChanged: (val) {
                                    _formKey.currentState.validate();
                                  },
                                  controller: _superAdminSecretKeyController,
                                  style: TextStyle(color: Colors.white),
                                  decoration: InputDecoration(
                                      prefixIcon: Icon(
                                        Icons.security,
                                        color: Colors.white,
                                      ),
                                      border: OutlineInputBorder(
                                        // width: 0.0 produces a thin "hairline" border
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(90.0),
                                        ),
                                        borderSide: BorderSide.none,

                                        //borderSide: const BorderSide(),
                                      ),
                                      hintStyle: TextStyle(
                                          color: Colors.white,
                                          fontFamily: "WorkSansLight"),
                                      filled: true,
                                      fillColor: Colors.white24,
                                      hintText: 'Secret Key'),
                                ),
                              ),
                            ],
                          ),
                        ),
                        FullWidthButtonWidget(
                          buttonColor: HexColorExtension('ff4880'),
                          text: 'Sign Up',
                          textColor: Colors.white,
                          onPressed: () async {
                            if (_superAdminSecretKeyController.text !=
                                SECRET_SUPER_ADMIN_SIGNUP_KEY) {
                              locator<ModalService>().showAlert(
                                  context: context,
                                  title: 'Error',
                                  message: 'Secret Key Incorrect');
                              return;
                            }

                            bool confirm = await locator<ModalService>()
                                .showConfirmation(
                                    context: context,
                                    title: 'Submit',
                                    message: 'Are you sure?');

                            if (!confirm) return;

                            _signupBloc.add(
                              SuperAdminSignupEvent(
                                email: _emailController.text,
                                password: _passwordController.text,
                                firstName: _firstNameController.text,
                                lastName: _lastNameController.text,
                              ),
                            );
                          },
                        ),
                        Padding(
                          padding: EdgeInsets.all(10),
                          child: InkWell(
                            onTap: () {
                              Navigator.of(context).pop();
                            },
                            child: RichText(
                              text: TextSpan(
                                style: TextStyle(fontWeight: FontWeight.bold),
                                children: [
                                  TextSpan(
                                      text: 'Already have an account?',
                                      style: TextStyle(color: Colors.grey)),
                                  TextSpan(text: ' Log in')
                                ],
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  );
                }

                return Container();
              },
            ),
          ),
        ),
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
    Navigator.pop(context);

    try {
      final PickedFile file = await ImagePicker().getImage(source: source);

      if (file == null) return;

      _image = await ImageCropper.cropImage(sourcePath: file.path);

      if (_image == null) return;

      _signupBloc.add(
        UploadPictureEvent(image: _image),
      );
    } catch (error) {
      print(error);
    }
  }

  @override
  void navigateHome() {
    Navigator.of(context).popUntil((route) => route.isFirst);
  }

  @override
  void showMessage({String message}) {
    locator<ModalService>()
        .showAlert(context: context, title: 'Error', message: message);
  }

  @override
  void clearForm() {
    this._firstNameController.clear();
    this._lastNameController.clear();
    this._emailController.clear();
    this._passwordController.clear();
  }
}
