import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:p/ServiceLocator.dart';
import 'package:p/blocs/readingLogLogs/Bloc.dart';
import 'package:p/models/ChildLogModel.dart';
import 'package:p/models/ParentLogModel.dart';
import 'package:p/models/UserModel.dart';
import 'package:p/services/AuthService.dart';
import 'package:p/services/LogService.dart';
import 'package:table_calendar/table_calendar.dart';

abstract class ReadingLogLogsDelegate {
  void showMessage({@required String message});
}

class ReadingLogLogsBloc
    extends Bloc<ReadingLogLogsEvent, ReadingLogLogsState> {
  ReadingLogLogsBloc({
    @required this.book,
  }) : super(null);

  ReadingLogLogsDelegate _readingLogLogsDelegate;
  UserModel _currentUser;
  ParentLogModel book;
  final CalendarController _calendarController = CalendarController();
  Map<DateTime, List<ChildLogModel>> _events =
      Map<DateTime, List<ChildLogModel>>();

  void setDelegate({@required ReadingLogLogsDelegate delegate}) {
    this._readingLogLogsDelegate = delegate;
  }

  @override
  Stream<ReadingLogLogsState> mapEventToState(
      ReadingLogLogsEvent event) async* {
    if (event is LoadPageEvent) {
      yield LoadingState();

      try {
        _currentUser = await locator<AuthService>().getCurrentUser();

        Stream<QuerySnapshot> logsStream = await locator<LogService>()
            .retrieveChildLogsStream(
                uid: _currentUser.uid,
                collection: 'books',
                documentID: book.id,
                subCollection: 'logs');

        logsStream.listen((QuerySnapshot event) {
          List<ChildLogModel> logs = event.documents
              .map((doc) => ChildLogModel.fromDocumentSnapshot(ds: doc))
              .toList();
          add(LogsUpdatedEvent(logs: logs));
        });
      } catch (error) {
        yield ErrorState(error: error);
      }
    }

    if (event is LogsUpdatedEvent) {
      final List<ChildLogModel> logs = event.logs;

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

      // logs.sort(
      //   (a, b) => b.created.compareTo(a.created),
      // );

      final DateTime today = DateTime.now();

      yield LoadedState(
        user: _currentUser,
        book: book,
        calendarController: _calendarController,
        events: _events,
        dateKey: DateTime(
          today.year,
          today.month,
          today.day,
        ),
      );
    }

    if (event is OnDaySelectedEvent) {
      final DateTime selectedDay = event.selectedDay;

      yield LoadedState(
        user: _currentUser,
        book: book,
        calendarController: _calendarController,
        events: _events,
        dateKey: DateTime(
          selectedDay.year,
          selectedDay.month,
          selectedDay.day,
        ),
      );
    }
  }
}
