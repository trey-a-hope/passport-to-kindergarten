import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:p/ServiceLocator.dart';
import 'package:p/blocs/readingLogLogs/Bloc.dart';
import 'package:p/models/ChildLogModel.dart';
import 'package:p/models/ParentLogModel.dart';
import 'package:p/models/UserModel.dart';
import 'package:p/models/LogModel.dart';
import 'package:p/services/AuthService.dart';
import 'package:p/services/LogService.dart';

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

      logs.sort(
        (a, b) => b.created.compareTo(a.created),
      );

      yield LoadedState(
        user: _currentUser,
        logs: logs,
        book: book,
      );
    }
  }
}
