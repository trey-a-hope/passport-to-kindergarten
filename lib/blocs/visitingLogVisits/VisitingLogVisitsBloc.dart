import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:p/ServiceLocator.dart';
import 'package:p/models/LogModel.dart';
import 'package:p/models/UserModel.dart';
import 'package:p/services/AuthService.dart';
import 'package:p/services/LogService.dart';
import 'Bloc.dart';

abstract class VisitingLogVisitsDelegate {
  void showMessage({@required String message});
}

class VisitingLogVisitsBloc
    extends Bloc<VisitingLogVisitsEvent, VisitingLogVisitsState> {
  VisitingLogVisitsBloc() : super(null);

  VisitingLogVisitsDelegate _visitingLogVisitsDelegate;
  UserModel _currentUser;

  void setDelegate({@required VisitingLogVisitsDelegate delegate}) {
    this._visitingLogVisitsDelegate = delegate;
  }

  @override
  Stream<VisitingLogVisitsState> mapEventToState(
      VisitingLogVisitsEvent event) async* {
    if (event is LoadPageEvent) {
      yield LoadingState();

      try {
        _currentUser = await locator<AuthService>().getCurrentUser();

        Stream<QuerySnapshot> logsStream = await locator<LogService>()
            .streamLogs(
                uid: _currentUser.uid,
                collection: 'visits',
                documentID: null); //TODO:

        logsStream.listen((QuerySnapshot event) {
          List<LogModel> logs = event.documents
              .map((doc) => LogModel.fromDocumentSnapshot(ds: doc))
              .toList();
          add(LogsUpdatedEvent(logs: logs));
        });
      } catch (error) {
        yield ErrorState(error: error);
      }
    }

    if (event is LogsUpdatedEvent) {
      final List<LogModel> logs = event.logs;

      yield LoadedState(
        logs: logs,
        user: _currentUser,
      );
    }
  }
}
