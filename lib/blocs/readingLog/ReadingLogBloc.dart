import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:p/ServiceLocator.dart';
import 'package:p/blocs/readingLog/Bloc.dart';
import 'package:p/models/UserModel.dart';
import 'package:p/models/LogModel.dart';
import 'package:p/services/AuthService.dart';
import 'package:p/services/LogService.dart';

abstract class ReadingLogDelegate {
  void showMessage({@required String message});
}

class ReadingLogBloc extends Bloc<ReadingLogEvent, ReadingLogState> {
  ReadingLogBloc() : super(null);

  ReadingLogDelegate _readingLogDelegate;
  UserModel _currentUser;

  void setDelegate({@required ReadingLogDelegate delegate}) {
    this._readingLogDelegate = delegate;
  }

  @override
  Stream<ReadingLogState> mapEventToState(ReadingLogEvent event) async* {
    if (event is LoadPageEvent) {
      yield LoadingState();

      try {
        _currentUser = await locator<AuthService>().getCurrentUser();

        Stream<QuerySnapshot> readLogsStream = await locator<LogService>()
            .retrieveReadLogsStream(uid: _currentUser.uid);

        readLogsStream.listen((QuerySnapshot event) {
          List<LogModel> readLogs = event.documents
              .map((doc) => LogModel.fromDocumentSnapshot(ds: doc))
              .toList();
          add(ReadLogsUpdatedEvent(readLogs: readLogs));
        });
      } catch (error) {
        yield ErrorState(error: error);
      }
    }

    if (event is ReadLogsUpdatedEvent) {
      final List<LogModel> readLogs = event.readLogs;

      yield LoadedState(
        user: _currentUser,
        readLogs: readLogs,
      );
    }
  }
}
