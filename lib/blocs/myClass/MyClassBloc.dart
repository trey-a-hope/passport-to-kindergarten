import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:p/ServiceLocator.dart';
import 'package:p/constants.dart';
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

        Stream<QuerySnapshot> studentsStream = await locator<UserService>()
            .streamStudentsForTeacher(teacherUID: _currentUser.uid);

        studentsStream.listen(
          (QuerySnapshot event) {
            List<UserModel> students = event.documents
                .map((doc) => UserModel.fromDocumentSnapshot(ds: doc))
                .toList();

            add(StudentsUpdatedEvent(students: students));
          },
        );
      } catch (error) {
        yield ErrorState(error: error);
      }
    }

    if (event is StudentsUpdatedEvent) {
      final List<UserModel> students = event.students;

      for (int studentCount = 0;
          studentCount < students.length;
          studentCount++) {
        final UserModel student = students[studentCount];

        final List<BookModel> books =
            await locator<LogService>().getBooksForUser(uid: student.uid);
        student.books = books;

        student.bookSortBy = 'recent';

        books.sort(
          (a, b) => b.modified.compareTo(a.modified),
        );

        for (int bookCount = 0; bookCount < books.length; bookCount++) {
          final BookModel book = books[bookCount];
          final List<LogModel> logs = await locator<LogService>().getLogs(
              uid: student.uid, collection: 'books', documentID: book.id);

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

          book.logEvents = logEvents;
        }

        final List<VisitModel> visits =
            await locator<LogService>().getVisitsForUser(uid: student.uid);
        student.visits = visits;

        student.visitSortBy = 'recent';

        visits.sort(
          (a, b) => b.modified.compareTo(a.modified),
        );

        for (int visitCount = 0; visitCount < visits.length; visitCount++) {
          final VisitModel visit = visits[visitCount];
          final List<LogModel> logs = await locator<LogService>().getLogs(
              uid: student.uid, collection: 'visits', documentID: visit.id);

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

          visit.logEvents = logEvents;
        }

        final List<StampModel> stamps =
            await locator<UserService>().getStampsForUser(uid: student.uid);
        student.stamps = stamps;
      }

      yield LoadedState(
        user: _currentUser,
        students: students,
        studentSelected: studentSelected,
      );
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

    if (event is CreateBookLogForStudentEvent) {
      final String studentUID = event.studentUID;
      final String bookID = event.bookID;
      final DateTime date = event.date;
      final bool totalLogLimitReached = event.totalLogLimitReached;

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

        if (totalLogLimitReached) {
          await locator<UserService>().createStamp(
            uid: studentUID,
            stamp: StampModel(
              name: '15 Books Read',
              assetImagePath: ASSET_p2k20_app_stamp_15_books_read,
              created: DateTime.now(),
              id: null,
            ),
          );
        }

        _myClassBlocDelegate.showMessage(message: 'Log added!');
      } catch (error) {
        yield ErrorState(error: error);
      }
    }

    if (event is CreateVisitLogForStudentEvent) {
      final String studentUID = event.studentUID;
      final String visitID = event.visitID;
      final DateTime date = event.date;
      final String name = event.visitName;

      try {
        final LogModel log = LogModel(
          created: date,
          id: null,
        );

        locator<LogService>().createLog(
          uid: studentUID,
          collection: 'visits',
          documentID: visitID,
          log: log,
        );

        String assetImagePath;
        switch (name) {
          case 'Dayton Art Institute':
            assetImagePath = ASSET_stamp_dayton_art_institute;
            break;
          case 'Dayton Metro Library':
            assetImagePath = ASSET_dayton_metro_library_logo;
            break;
          case 'Five Rivers Metro Park':
            assetImagePath = ASSET_five_rivers_metroparks_logo;
            break;
          case 'Boonshoft Museum of Discovery':
            assetImagePath = ASSET_boonshoft_logo;
            break;
          default:
            assetImagePath = ASSET_stamp_dayton_art_institute;
            break;
        }

        await locator<UserService>().createStamp(
          uid: studentUID,
          stamp: StampModel(
            name: '15 Books Read',
            assetImagePath: assetImagePath,
            created: DateTime.now(),
            id: null,
          ),
        );

        _myClassBlocDelegate.showMessage(message: 'Log added!');
      } catch (error) {
        yield ErrorState(error: error);
      }
    }

    if (event is StudentSelectedEvent) {
      studentSelected = event.studentSelected;

      yield LoadedState(
        user: _currentUser,
        students: _students,
        studentSelected: studentSelected,
      );
    }
  }
}
