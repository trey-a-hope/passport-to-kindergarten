import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:p/ServiceLocator.dart';
import 'package:p/blocs/visitingLog/Bloc.dart';
import 'package:p/models/ParentLogModel.dart';
import 'package:p/models/UserModel.dart';
import 'package:p/models/LogModel.dart';
import 'package:p/services/AuthService.dart';
import 'package:p/services/LogService.dart';

abstract class VisitingLogDelegate {
  void showMessage({@required String message});
}

class VisitingLogBloc extends Bloc<VisitingLogEvent, VisitingLogState> {
  VisitingLogBloc() : super(null);

  VisitingLogDelegate _visitingLogDelegate;
  UserModel _currentUser;

  void setDelegate({@required VisitingLogDelegate delegate}) {
    this._visitingLogDelegate = delegate;
  }

  @override
  Stream<VisitingLogState> mapEventToState(VisitingLogEvent event) async* {
    if (event is LoadPageEvent) {
      yield LoadingState();

      try {
        _currentUser = await locator<AuthService>().getCurrentUser();

        List<ParentLogModel> visitLogs =
            await locator<LogService>().retrieveParentLogs(
          uid: _currentUser.uid,
          collection: 'visitLogs',
        );

        yield LoadedState(
          user: _currentUser,
          visitLogs: visitLogs,
        );
      } catch (error) {
        yield ErrorState(error: error);
      }
    }
  }
}
