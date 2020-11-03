import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:p/ServiceLocator.dart';
import 'package:p/models/BookModel.dart';
import 'package:p/models/UserModel.dart';
import 'package:p/services/AuthService.dart';
import 'package:p/services/LogService.dart';
import 'package:p/services/UserService.dart';
import 'MyClassEvent.dart';
import 'MyClassState.dart';

abstract class MyClassBlocDelegate {
  void showMessage({@required String message});
  void clearAddTitleForm();
}

class MyClassBloc extends Bloc<MyClassEvent, MyClassState> {
  MyClassBloc() : super(null);

  MyClassBlocDelegate _myClassBlocDelegate;
  UserModel _currentUser;
  List<UserModel> _students;

  void setDelegate({@required MyClassBlocDelegate delegate}) {
    this._myClassBlocDelegate = delegate;
  }

  @override
  Stream<MyClassState> mapEventToState(MyClassEvent event) async* {
    if (event is LoadPageEvent) {
      yield LoadingState();

      try {
        _currentUser = await locator<AuthService>().getCurrentUser();

        _students = await locator<UserService>()
            .retrieveStudentsForTeacher(uid: _currentUser.uid);

        yield LoadedState(
          user: _currentUser,
          students: _students,
        );
      } catch (error) {
        yield ErrorState(error: error);
      }
    }

    if (event is CreateBookForStudentEvent) {
      final String studentUID = event.studentUID;
      final String title = event.title;
      final String author = event.author;
      final DateTime now = DateTime.now();

      try {
        await locator<LogService>().createBookForUser(
          uid: studentUID,
          book: BookModel(
            author: author,
            title: title,
            logCount: 0,
            created: now,
            modified: now,
            id: null,
          ),
        );

        _myClassBlocDelegate.showMessage(message: 'Book added!');

        _myClassBlocDelegate.clearAddTitleForm();
      } catch (error) {
        yield ErrorState(error: error);
      }
    }
  }
}
