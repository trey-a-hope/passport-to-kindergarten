import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:p/ServiceLocator.dart';
import 'package:p/constants.dart';
import 'package:p/models/UserModel.dart';
import 'package:p/services/UserService.dart';
import 'package:p/widgets/FullWidthButtonWidget.dart';
import 'package:p/widgets/SpinnerWidget.dart';
import 'Bloc.dart';

class SearchTeachersPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text(
          'Search Teachers',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: Column(
        children: <Widget>[_SearchBar(), _SearchBody()],
      ),
    );
  }
}

class _SearchBar extends StatefulWidget {
  @override
  State<_SearchBar> createState() => _SearchBarState();
}

class _SearchBarState extends State<_SearchBar> {
  final TextEditingController _textController = TextEditingController();
  SearchTeachersBloc _searchTeachersBloc;

  @override
  void initState() {
    super.initState();
    _searchTeachersBloc = BlocProvider.of<SearchTeachersBloc>(context);
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _textController,
      autocorrect: false,
      onChanged: (text) {
        _searchTeachersBloc.add(
          TextChangedEvent(text: text),
        );
      },
      decoration: InputDecoration(
        prefixIcon: Icon(Icons.search),
        suffixIcon: GestureDetector(
          child: Icon(Icons.clear),
          onTap: _onClearTapped,
        ),
        border: InputBorder.none,
        hintText: 'Enter a search term',
      ),
    );
  }

  void _onClearTapped() {
    _textController.text = '';
    _searchTeachersBloc.add(TextChangedEvent(text: ''));
  }
}

class _SearchBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SearchTeachersBloc, SearchTeachersState>(
      builder: (BuildContext context, SearchTeachersState state) {
        if (state is SearchTeachersStateStart) {
          return Expanded(
            child: Center(
              child: FullWidthButtonWidget(
                buttonColor: Colors.blue,
                text: 'I do not know the teacher.',
                textColor: Colors.white,
                onPressed: () {
                  UserModel idkTeacher = UserModel(
                    created: DateTime.now(),
                    imgUrl: DUMMY_PROFILE_PHOTO_URL,
                    lastName: 'I Do Not Know',
                    firstName: '',
                    isAdmin: false,
                    email: 'johndoe@gmail.com',
                    teacherID: null,
                    dob: null,
                    school: 'IDK School',
                    fcmToken: null,
                    parentFirstName: null,
                    parentLastName: null,
                    profileType: PROFILE_TYPE.TEACHER.name,
                    uid: '$IDK_TEACHER_ID',
                  );

                  Navigator.pop(
                    context,
                    idkTeacher,
                  );
                },
              ),
            ),
          );
        }

        if (state is SearchTeachersStateLoading) {
          return SpinnerWidget();
        }

        if (state is SearchTeachersStateError) {
          return Expanded(
            child: Center(
              child: Text(state.error.message),
            ),
          );
        }

        if (state is SearchTeachersStateNoResults) {
          return Expanded(
            child: Center(
              child: Text('No results found. :('),
            ),
          );
        }

        if (state is SearchTeachersStateFoundResults) {
          final List<UserModel> teachers = state.teachers;

          return Expanded(
            child: ListView.builder(
              itemCount: teachers.length,
              itemBuilder: (BuildContext context, int index) {
                final UserModel teacher = teachers[index];

                return ListTile(
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage(teacher.imgUrl),
                  ),
                  title: Text(
                    '${teacher.firstName} ${teacher.lastName}',
                    style: TextStyle(color: Colors.black),
                  ),
                  subtitle: Text('${teacher.school}'),
                  onTap: () {
                    Navigator.pop(context, teacher);
                  },
                );
              },
            ),
          );
        }

        return Container();
      },
    );
  }
}
