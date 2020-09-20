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

        List<LogModel> readLogs = await locator<LogService>().retrieveReadLogs(
          uid: _currentUser.uid,
        );

        yield LoadedState(
          user: _currentUser,
          readLogs: readLogs,
        );
      } catch (error) {
        yield ErrorState(error: error);
      }
    }
  }
}
