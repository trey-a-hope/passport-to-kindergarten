import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:p/ServiceLocator.dart';
import 'package:p/constants.dart';
import 'package:p/models/UserModel.dart';
import 'package:p/services/ModalService.dart';
import 'package:p/services/ValidatorService.dart';
import 'package:p/widgets/AppBarWidget.dart';
import 'package:p/widgets/FullWidthButtonWidget.dart';
import 'package:p/widgets/ImageUploadWidget.dart';
import 'package:p/widgets/SpinnerWidget.dart';
import 'Bloc.dart';
import 'package:p/blocs/searchTeachers/Bloc.dart' as SEARCH_TEACHERS_BP;

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
  final TextEditingController _teacherController = TextEditingController();
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
          final UserModel currentUser = state.user;
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
                    child: ListView(
                      children: [
                        AppBarWidget(title: 'Edit Profile'),
                        Center(
                          child: ImageUploadWidget(
                            imgUrl: currentUser.imgUrl,
                            showSelectImageDialog: showSelectImageDialog,
                          ),
                        ),
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
                            textCapitalization: TextCapitalization.sentences,
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            cursorColor: Colors.black,
                            validator: locator<ValidatorService>().isEmpty,
                            keyboardType: TextInputType.text,
                            textInputAction: TextInputAction.done,
                            controller: _firstNameController,
                            style: TextStyle(
                                color: Colors.black, fontFamily: 'SFUIDisplay'),
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
                            textCapitalization: TextCapitalization.sentences,
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            cursorColor: Colors.black,
                            validator: locator<ValidatorService>().isEmpty,
                            keyboardType: TextInputType.text,
                            textInputAction: TextInputAction.done,
                            controller: _lastNameController,
                            style: TextStyle(
                                color: Colors.black, fontFamily: 'SFUIDisplay'),
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
                            textCapitalization: TextCapitalization.sentences,
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            cursorColor: Colors.black,
                            validator: locator<ValidatorService>().isEmpty,
                            keyboardType: TextInputType.text,
                            textInputAction: TextInputAction.done,
                            controller: _schoolController,
                            style: TextStyle(
                                color: Colors.black, fontFamily: 'SFUIDisplay'),
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'School',
                              prefixIcon: Icon(Icons.person),
                              labelStyle: TextStyle(fontSize: 15),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Padding(
                          padding: EdgeInsets.all(10),
                          child: FullWidthButtonWidget(
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
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        }

        if (state is ParentLoadedState) {
          final UserModel currentUser = state.user;
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
                    child: ListView(
                      children: [
                        AppBarWidget(title: 'Edit Profile'),
                        Center(
                          child: ImageUploadWidget(
                            imgUrl: currentUser.imgUrl,
                            showSelectImageDialog: showSelectImageDialog,
                          ),
                        ),
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
                            textCapitalization: TextCapitalization.sentences,
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            cursorColor: Colors.black,
                            validator: locator<ValidatorService>().isEmpty,
                            keyboardType: TextInputType.text,
                            textInputAction: TextInputAction.done,
                            controller: _firstNameController,
                            style: TextStyle(
                                color: Colors.black, fontFamily: 'SFUIDisplay'),
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
                            textCapitalization: TextCapitalization.sentences,
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            cursorColor: Colors.black,
                            validator: locator<ValidatorService>().isEmpty,
                            keyboardType: TextInputType.text,
                            textInputAction: TextInputAction.done,
                            controller: _lastNameController,
                            style: TextStyle(
                                color: Colors.black, fontFamily: 'SFUIDisplay'),
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
                              final DateTime now = DateTime.now();

                              final DateTime picked = await showDatePicker(
                                context: context,
                                initialDate: state.user.dob,
                                firstDate: DateTime(now.year - 7),
                                lastDate: DateTime(now.year - 2),
                              );

                              if (picked != null && picked != state.user.dob) {
                                _editProfileBloc.add(
                                  UpdateChildDOBEvent(childDOB: picked),
                                );

                                String formattedDate =
                                    DateFormat('MMMM dd, yyyy').format(picked);
                                _dobController.text = formattedDate;
                              }
                            },
                            cursorColor: Colors.black,
                            validator: locator<ValidatorService>().isEmpty,
                            keyboardType: TextInputType.text,
                            textInputAction: TextInputAction.done,
                            controller: _dobController,
                            style: TextStyle(
                                color: Colors.black, fontFamily: 'SFUIDisplay'),
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
                            textCapitalization: TextCapitalization.sentences,
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            cursorColor: Colors.black,
                            validator: locator<ValidatorService>().isEmpty,
                            keyboardType: TextInputType.text,
                            textInputAction: TextInputAction.done,
                            controller: _primaryParentFirstNameController,
                            style: TextStyle(
                                color: Colors.black, fontFamily: 'SFUIDisplay'),
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
                            textCapitalization: TextCapitalization.sentences,
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            cursorColor: Colors.black,
                            validator: locator<ValidatorService>().isEmpty,
                            keyboardType: TextInputType.text,
                            textInputAction: TextInputAction.done,
                            controller: _primaryParentLastNameController,
                            style: TextStyle(
                                color: Colors.black, fontFamily: 'SFUIDisplay'),
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
                            textCapitalization: TextCapitalization.sentences,
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            cursorColor: Colors.black,
                            keyboardType: TextInputType.text,
                            textInputAction: TextInputAction.done,
                            controller: _secondaryParentFirstNameController,
                            style: TextStyle(
                                color: Colors.black, fontFamily: 'SFUIDisplay'),
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
                            textCapitalization: TextCapitalization.sentences,
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            cursorColor: Colors.black,
                            keyboardType: TextInputType.text,
                            textInputAction: TextInputAction.done,
                            controller: _secondaryParentLastNameController,
                            style: TextStyle(
                                color: Colors.black, fontFamily: 'SFUIDisplay'),
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Secondary Parent Last Name',
                              prefixIcon: Icon(Icons.person),
                              labelStyle: TextStyle(fontSize: 15),
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(10),
                          child: Text(
                            'Teacher',
                            textAlign: TextAlign.center,
                            style: TextStyle(color: COLOR_NAVY),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                          child: TextFormField(
                            onTap: () async {
                              final SEARCH_TEACHERS_BP.SearchTeachersRepository
                                  _searchTeachersRepository =
                                  SEARCH_TEACHERS_BP.SearchTeachersRepository(
                                cache: SEARCH_TEACHERS_BP.SearchTeachersCache(),
                              );

                              Route route = MaterialPageRoute(
                                builder: (BuildContext context) => BlocProvider(
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

                              _editProfileBloc.add(
                                SelectTeacherEvent(
                                    selectedTeacher: selectedTeacher),
                              );

                              _teacherController.text =
                                  '${selectedTeacher.firstName} ${selectedTeacher.lastName}';
                            },
                            controller: _teacherController,
                            style: TextStyle(
                                color: Colors.black, fontFamily: 'SFUIDisplay'),
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Teacher',
                              prefixIcon: Icon(Icons.person),
                              labelStyle: TextStyle(fontSize: 15),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Padding(
                          padding: EdgeInsets.all(10),
                          child: FullWidthButtonWidget(
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
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        }

        if (state is SuperAdminLoadedState) {
          final UserModel currentUser = state.user;
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
                    child: ListView(
                      children: [
                        AppBarWidget(title: 'Edit Profile'),
                        Center(
                          child: ImageUploadWidget(
                            imgUrl: currentUser.imgUrl,
                            showSelectImageDialog: showSelectImageDialog,
                          ),
                        ),
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
                            textCapitalization: TextCapitalization.sentences,
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            cursorColor: Colors.black,
                            validator: locator<ValidatorService>().isEmpty,
                            keyboardType: TextInputType.text,
                            textInputAction: TextInputAction.done,
                            controller: _firstNameController,
                            style: TextStyle(
                                color: Colors.black, fontFamily: 'SFUIDisplay'),
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
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            cursorColor: Colors.black,
                            validator: locator<ValidatorService>().isEmpty,
                            keyboardType: TextInputType.text,
                            textInputAction: TextInputAction.done,
                            controller: _lastNameController,
                            style: TextStyle(
                                color: Colors.black, fontFamily: 'SFUIDisplay'),
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Super Admin Last Name',
                              prefixIcon: Icon(Icons.person),
                              labelStyle: TextStyle(fontSize: 15),
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(10),
                          child: FullWidthButtonWidget(
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
                        )
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

      File image = await ImageCropper.cropImage(
        sourcePath: file.path,
        aspectRatio: CropAspectRatio(
          ratioX: 100,
          ratioY: 100,
        ),
      );

      if (image == null) return;

      _editProfileBloc.add(
        UploadPictureEvent(image: image),
      );
    } catch (error) {
      print(error);
    }
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
    UserModel student,
    UserModel teacher,
  }) {
    _firstNameController.text = student.firstName;
    _lastNameController.text = student.lastName;
    _dobController.text = DateFormat('MMMM dd, yyyy').format(student.dob);
    _primaryParentFirstNameController.text = student.primaryParentFirstName;
    _primaryParentLastNameController.text = student.primaryParentLastName;
    _secondaryParentFirstNameController.text = student.secondaryParentFirstName;
    _secondaryParentLastNameController.text = student.secondaryParentLastName;
    _teacherController.text = '${teacher.firstName} ${teacher.lastName}';
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
