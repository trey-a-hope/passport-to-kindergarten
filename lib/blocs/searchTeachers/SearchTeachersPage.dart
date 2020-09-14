import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:p/models/UserModel.dart';
import 'package:p/widgets/SpinnerWidget.dart';
import 'Bloc.dart' as SEARCH_TEACHERS_BP;

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
  SEARCH_TEACHERS_BP.SearchTeachersBloc _searchTeachersBloc;

  @override
  void initState() {
    super.initState();
    _searchTeachersBloc =
        BlocProvider.of<SEARCH_TEACHERS_BP.SearchTeachersBloc>(context);
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
          SEARCH_TEACHERS_BP.TextChangedEvent(text: text),
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
    _searchTeachersBloc.add(SEARCH_TEACHERS_BP.TextChangedEvent(text: ''));
  }
}

class _SearchBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SEARCH_TEACHERS_BP.SearchTeachersBloc,
        SEARCH_TEACHERS_BP.SearchTeachersState>(
      builder:
          (BuildContext context, SEARCH_TEACHERS_BP.SearchTeachersState state) {
        if (state is SEARCH_TEACHERS_BP.SearchTeachersState) {
          return Expanded(
            child: Center(child: Icon(Icons.book, size: 200, color: Colors.grey.shade300,)),
          );
        }

        if (state is SEARCH_TEACHERS_BP.SearchTeachersStateLoading) {
          return SpinnerWidget();
        }

        if (state is SEARCH_TEACHERS_BP.SearchTeachersStateError) {
          return Expanded(
            child: Center(
              child: Text(state.error.message),
            ),
          );
        }

        if (state is SEARCH_TEACHERS_BP.SearchTeachersStateNoResults) {
          return Expanded(
            child: Center(
              child: Text('No results found. :('),
            ),
          );
        }

        if (state is SEARCH_TEACHERS_BP.SearchTeachersStateFoundResults) {
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
                  title: Text('${teacher.firstName} ${teacher.lastName}'),
                  subtitle: Text('${teacher.school}'),
                  trailing: Icon(Icons.chevron_right),
                  onTap: () {
                    //Return to sign up page with this teacher.
                  },
                );
              },
            ),
          );
        }

        return Center(
          child: Text('YOU SHOULD NEVER SEE THIS...'),
        );
      },
    );
  }
}
