import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:p/constants.dart';
import 'package:p/extensions/HexColorExtension.dart';
import 'package:p/models/UserModel.dart';
import 'package:p/services/ModalService.dart';
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

  final TextEditingController _parentFirstNameController =
      TextEditingController();

  final TextEditingController _parentLastNameController =
      TextEditingController();

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  SignupBloc _signupBloc;

  @override
  void initState() {
    _signupBloc = BlocProvider.of<SignupBloc>(context);
    _signupBloc.setDelegate(delegate: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;

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
                  return SingleChildScrollView(
                    child: Form(
                      autovalidate: state.autoValidate,
                      key: state.formKey,
                      child: Column(
                        children: [
                          Image.asset(ASSET_IMAGE_P2K_LOGO),
                          const SizedBox(
                            height: 50,
                          ),
                          SwitchListTile(
                            title: RichText(
                              text: TextSpan(
                                style: TextStyle(fontSize: 18),
                                children: [
                                  TextSpan(text: 'I am a '),
                                  TextSpan(
                                    text: 'teacher.',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  )
                                ],
                              ),
                            ),
                            value: true,
                            onChanged: (bool value) {
                              _signupBloc.add(ToggleProfileTypeEvent());
                            },
                            secondary: const Icon(
                              Icons.book,
                              color: Colors.white,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.all(20),
                            child: TextFormField(
                              autovalidate: state.autoValidate,
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
                          Padding(
                            padding: EdgeInsets.all(20),
                            child: TextFormField(
                              autovalidate: state.autoValidate,
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
                          Padding(
                            padding: EdgeInsets.all(20),
                            child: TextFormField(
                              autovalidate: state.autoValidate,
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
                          Padding(
                            padding: EdgeInsets.all(20),
                            child: TextFormField(
                              autovalidate: state.autoValidate,
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
                            padding: EdgeInsets.all(20),
                            child: TextFormField(
                              autovalidate: state.autoValidate,
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
                          Divider(
                            color: Colors.white,
                            thickness: 1,
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

                              final String email = _emailController.text;
                              final String password = _passwordController.text;
                              final String firstName =
                                  _firstNameController.text;
                              final String lastName = _lastNameController.text;
                              final String school = _schoolController.text;

                              _signupBloc.add(
                                Signup(
                                  email: email,
                                  password: password,
                                  firstName: firstName,
                                  lastName: lastName,
                                  formKey: state.formKey,
                                  school: school,
                                  parentFirstName: null,
                                  parentLastName: null,
                                ),
                              );
                            },
                          ),
                          Padding(
                            padding: EdgeInsets.all(20),
                            child: InkWell(
                              onTap: () {
                                Route route = MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      BlocProvider(
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
                    ),
                  );
                }

                if (state is ParentState) {
                  return SingleChildScrollView(
                    child: Form(
                      autovalidate: state.autoValidate,
                      key: state.formKey,
                      child: Column(
                        children: [
                          Image.asset(ASSET_IMAGE_P2K_LOGO),
                          SizedBox(
                            height: 50,
                          ),
                          SwitchListTile(
                            title: RichText(
                              text: TextSpan(
                                style: TextStyle(fontSize: 18),
                                children: [
                                  TextSpan(text: 'I am a '),
                                  TextSpan(
                                    text: 'parent/guardian.',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  )
                                ],
                              ),
                            ),
                            value: false,
                            onChanged: (bool value) {
                              _signupBloc.add(ToggleProfileTypeEvent());
                            },
                            secondary: const Icon(
                              Icons.book,
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            'Child\s Info',
                            style: TextStyle(color: Colors.white),
                          ),
                          Padding(
                            padding: EdgeInsets.all(20),
                            child: TextFormField(
                              autovalidate: state.autoValidate,
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
                                  hintText: 'Child\'s First Name'),
                            ),
                          ),
                          //Last Name
                          Padding(
                            padding: EdgeInsets.all(20),
                            child: TextFormField(
                              autovalidate: state.autoValidate,
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
                                  hintText: 'Child\'s Last Name'),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.all(20),
                            child: TextFormField(
                              autovalidate: state.autoValidate,
                              onTap: () async {
                                final DateTime picked = await showDatePicker(
                                  context: context,
                                  initialDate: state.selectedDate,
                                  firstDate: DateTime(2000, 1),
                                  lastDate: DateTime.now(),
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
                            'Parent/Guardian Info',
                            style: TextStyle(color: Colors.white),
                          ),

                          Padding(
                            padding: EdgeInsets.all(20),
                            child: TextFormField(
                              autovalidate: state.autoValidate,
                              controller: _parentFirstNameController,
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
                                  hintText: 'Parent/Guardian First Name'),
                            ),
                          ),

                          Padding(
                            padding: EdgeInsets.all(20),
                            child: TextFormField(
                              autovalidate: state.autoValidate,
                              controller: _parentLastNameController,
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
                                  hintText: 'Parent/Guardian Last Name'),
                            ),
                          ),

                          Padding(
                            padding: EdgeInsets.all(20),
                            child: TextFormField(
                              autovalidate: state.autoValidate,
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
                            padding: EdgeInsets.all(20),
                            child: TextFormField(
                              autovalidate: state.autoValidate,
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
                          Text(
                            'Other Info',
                            style: TextStyle(color: Colors.white),
                          ),
                          Padding(
                            padding: EdgeInsets.all(20),
                            child: TextFormField(
                              autovalidate: state.autoValidate,
                              onTap: () async {
                                final SEARCH_TEACHERS_BP
                                        .SearchTeachersRepository
                                    _searchTeachersRepository =
                                    SEARCH_TEACHERS_BP.SearchTeachersRepository(
                                  cache:
                                      SEARCH_TEACHERS_BP.SearchTeachersCache(),
                                );

                                Route route = MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      BlocProvider(
                                    create: (BuildContext context) =>
                                        SEARCH_TEACHERS_BP.SearchTeachersBloc(
                                            searchTeachersRepository:
                                                _searchTeachersRepository)
                                          ..add(
                                            SEARCH_TEACHERS_BP.LoadPageEvent(),
                                          ),
                                    child:
                                        SEARCH_TEACHERS_BP.SearchTeachersPage(),
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
                          Divider(
                            color: Colors.white,
                            thickness: 1,
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

                              final String email = _emailController.text;
                              final String password = _passwordController.text;
                              final String firstName =
                                  _firstNameController.text;
                              final String lastName = _lastNameController.text;

                              _signupBloc.add(
                                Signup(
                                  email: email,
                                  password: password,
                                  firstName: firstName,
                                  lastName: lastName,
                                  formKey: state.formKey,
                                  school: null,
                                  parentFirstName:
                                      _parentFirstNameController.text,
                                  parentLastName:
                                      _parentLastNameController.text,
                                ),
                              );
                            },
                          ),
                          Padding(
                            padding: EdgeInsets.all(20),
                            child: InkWell(
                              onTap: () {
                                Route route = MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      BlocProvider(
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

  @override
  void navigateHome() {
    Navigator.pop(context);
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
