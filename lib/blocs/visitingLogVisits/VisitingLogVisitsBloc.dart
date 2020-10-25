import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:p/ServiceLocator.dart';
import 'package:p/models/ParentLogModel.dart';
import 'package:p/models/UserModel.dart';
import 'package:p/services/AuthService.dart';
import 'package:p/services/LogService.dart';
import 'Bloc.dart';

abstract class VisitingLogVisitsDelegate {
  void showMessage({@required String message});
}

class VisitingLogVisitsBloc extends Bloc<VisitingLogVisitsEvent, VisitingLogVisitsState> {
  VisitingLogVisitsBloc() : super(null);

  VisitingLogVisitsDelegate _visitingLogVisitsDelegate;
  UserModel _currentUser;

  void setDelegate({@required VisitingLogVisitsDelegate delegate}) {
    this._visitingLogVisitsDelegate = delegate;
  }

  @override
  Stream<VisitingLogVisitsState> mapEventToState(VisitingLogVisitsEvent event) async* {
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
