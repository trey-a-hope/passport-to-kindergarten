import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:p/ServiceLocator.dart';
import 'package:p/models/BookModel.dart';
import 'package:p/models/ChildLogModel.dart';
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
  List<BookModel> books = List<BookModel>();
  DateTime selectedDateForBookLogs;
  Map<DateTime, List<ChildLogModel>> _events =
      Map<DateTime, List<ChildLogModel>>();
  bool studentSelected = false;

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
          books: books,
          selectedDateForBookLogs: selectedDateForBookLogs,
          events: _events,
          studentSelected: studentSelected,
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

    if (event is CreateLogForStudentEvent) {
      final String studentUID = event.studentUID;
      final String bookID = event.bookID;
      final DateTime now = DateTime.now();

      try {
        locator<LogService>().createChildLog(
          uid: studentUID,
          subCollection: 'logs',
          collection: 'books',
          documentID: bookID,
          childLogModel: ChildLogModel(
            title: 'Log for book - $bookID',
            created: now,
            notes: 'Notes for blah blah blah',
            id: null,
          ),
        );

        _myClassBlocDelegate.showMessage(message: 'Log added!');

        _myClassBlocDelegate.clearAddTitleForm();
      } catch (error) {
        yield ErrorState(error: error);
      }
    }

    if (event is GetBooksForStudentEvent) {
      final String studentUID = event.studentUID;
      try {
        books = await locator<LogService>().getBooksForUser(uid: studentUID);

        yield LoadedState(
          user: _currentUser,
          students: _students,
          books: books,
          selectedDateForBookLogs: selectedDateForBookLogs,
          events: _events,
          studentSelected: studentSelected,
        );
      } catch (error) {
        yield ErrorState(error: error);
      }
    }

    if (event is SelectDateForBookEvent) {
      final String studentUID = event.studentUID;
      final String bookID = event.bookID;
      selectedDateForBookLogs = event.selectedDate;

      final List<ChildLogModel> logs =
          await locator<LogService>().getLogsForBookForUser(
        uid: studentUID,
        bookID: bookID,
      );

      _events.clear();

      logs.forEach(
        (ChildLogModel log) {
          DateTime dayKey = DateTime(
            log.created.year,
            log.created.month,
            log.created.day,
          );

          if (_events.containsKey(dayKey)) {
            if (!_events[dayKey].contains(log)) {
              _events[dayKey].add(log);
            }
          } else {
            _events[dayKey] = [log];
          }
        },
      );

      yield LoadedState(
        user: _currentUser,
        students: _students,
        books: books,
        selectedDateForBookLogs: selectedDateForBookLogs,
        events: _events,
        studentSelected: studentSelected,
      );
    }

    if (event is ChangeDateForBookEvent) {
      final bool increase = event.increase;

      if (increase) {
        if (selectedDateForBookLogs.month == 12) return;
        selectedDateForBookLogs =
            DateTime(2020, selectedDateForBookLogs.month + 1);
      } else {
        if (selectedDateForBookLogs.month == 1) return;
        selectedDateForBookLogs =
            DateTime(2020, selectedDateForBookLogs.month - 1);
      }

      yield LoadedState(
        user: _currentUser,
        students: _students,
        books: books,
        selectedDateForBookLogs: selectedDateForBookLogs,
        events: _events,
        studentSelected: studentSelected,
      );
    }

    if (event is StudentSelectedEvent) {
      studentSelected = event.studentSelected;

      yield LoadedState(
        user: _currentUser,
        students: _students,
        books: books,
        selectedDateForBookLogs: selectedDateForBookLogs,
        events: _events,
        studentSelected: studentSelected,
      );
    }
  }
}
