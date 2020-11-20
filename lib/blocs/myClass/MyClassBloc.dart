import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:p/ServiceLocator.dart';
import 'package:p/models/BookModel.dart';
import 'package:p/models/LogModel.dart';
import 'package:p/models/StampModel.dart';
import 'package:p/models/UserModel.dart';
import 'package:p/models/VisitModel.dart';
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
  List<BookModel> _selectedStudentBooks = List<BookModel>();
  List<VisitModel> _selectedStudentVisits = List<VisitModel>();
  List<StampModel> _selectedStudentStamps = List<StampModel>();

  DateTime selectedDateForBookLogs;
  Map<DateTime, List<LogModel>> _events = Map<DateTime, List<LogModel>>();
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
          books: _selectedStudentBooks,
          selectedStudentVisits: _selectedStudentVisits,
          selectedDateForBookLogs: selectedDateForBookLogs,
          studentSelected: studentSelected,
          stamps: _selectedStudentStamps,
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
            given: true,
            summary: null,
            conversationStarters: null,
            assetImagePath: null,
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
      final DateTime date = event.date;

      try {
        final LogModel log = LogModel(
          created: date,
          id: null,
        );

        locator<LogService>().createLog(
          uid: studentUID,
          collection: 'books',
          documentID: bookID,
          log: log,
        );

        Map<DateTime, List<LogModel>> logEvents = _selectedStudentBooks
            .firstWhere(
                (selectedStudentBook) => selectedStudentBook.id == bookID)
            .logEvents;

        DateTime dayKey = DateTime(
          log.created.year,
          log.created.month,
          log.created.day,
        );

        if (logEvents.containsKey(dayKey)) {
          if (!logEvents[dayKey].contains(log)) {
            logEvents[dayKey].add(log);
          }
        } else {
          logEvents[dayKey] = [log];
        }

        yield LoadedState(
          user: _currentUser,
          students: _students,
          books: _selectedStudentBooks,
          selectedStudentVisits: _selectedStudentVisits,
          selectedDateForBookLogs: selectedDateForBookLogs,
          studentSelected: studentSelected,
          stamps: _selectedStudentStamps,
        );

        _myClassBlocDelegate.showMessage(
            message: 'Log added, close and reopen tile to see results.');
      } catch (error) {
        yield ErrorState(error: error);
      }
    }

    if (event is GetBooksForStudentEvent) {
      _myClassBlocDelegate.showMessage(message: 'Fetching logs, one second...');
      final String studentUID = event.studentUID;

      try {
        _selectedStudentBooks =
            await locator<LogService>().getBooksForUser(uid: studentUID);

        for (int i = 0; i < _selectedStudentBooks.length; i++) {
          final BookModel selectedStudentBook = _selectedStudentBooks[i];

          final List<LogModel> logs = await locator<LogService>().getLogs(
            uid: studentUID,
            collection: 'books',
            documentID: selectedStudentBook.id,
          );

          _events.clear();
          Map<DateTime, List<LogModel>> logEvents =
              Map<DateTime, List<LogModel>>();

          logs.forEach(
            (LogModel log) {
              DateTime dayKey = DateTime(
                log.created.year,
                log.created.month,
                log.created.day,
              );

              if (logEvents.containsKey(dayKey)) {
                if (!logEvents[dayKey].contains(log)) {
                  logEvents[dayKey].add(log);
                }
              } else {
                logEvents[dayKey] = [log];
              }
            },
          );

          selectedStudentBook.logEvents = logEvents;
        }

        yield LoadedState(
          user: _currentUser,
          students: _students,
          books: _selectedStudentBooks,
          selectedStudentVisits: _selectedStudentVisits,
          selectedDateForBookLogs: selectedDateForBookLogs,
          studentSelected: studentSelected,
          stamps: _selectedStudentStamps,
        );
      } catch (error) {
        yield ErrorState(error: error);
      }
    }

    if (event is StudentSelectedEvent) {
      studentSelected = event.studentSelected;

      yield LoadedState(
        user: _currentUser,
        students: _students,
        books: _selectedStudentBooks,
        selectedStudentVisits: _selectedStudentVisits,
        selectedDateForBookLogs: selectedDateForBookLogs,
        studentSelected: studentSelected,
        stamps: _selectedStudentStamps,
      );
    }
  }
}
