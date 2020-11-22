import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:p/ServiceLocator.dart';
import 'package:p/blocs/visitingLogLogsAdd/Bloc.dart';
import 'package:p/models/LogModel.dart';
import 'package:p/models/UserModel.dart';
import 'package:p/services/AuthService.dart';
import 'package:p/services/LogService.dart';

abstract class VisitingLogLogsAddDelegate {
  void showMessage({@required String message});
  void clearForm();
}

class VisitingLogLogsAddBloc
    extends Bloc<VisitingLogLogsAddEvent, VisitingLogLogsAddState> {
  VisitingLogLogsAddBloc({
    @required this.title,
  }) : super(null);

  final String title;

  VisitingLogLogsAddDelegate _visitingLogLogsAddDelegate;
  UserModel _currentUser;

  void setDelegate({@required VisitingLogLogsAddDelegate delegate}) {
    this._visitingLogLogsAddDelegate = delegate;
  }

  @override
  Stream<VisitingLogLogsAddState> mapEventToState(
      VisitingLogLogsAddEvent event) async* {
    if (event is LoadPageEvent) {
      yield LoadingState();

      try {
        _currentUser = await locator<AuthService>().getCurrentUser();
        yield LoadedState(
          user: _currentUser,
          title: title,
        );
      } catch (error) {
        yield ErrorState(error: error);
      }
    }

    if (event is SubmitEvent) {
      final String description = event.description;

      yield LoadingState();

      try {
        LogModel visitLog = LogModel(
          id: null,
          created: DateTime.now(),
        );

        locator<LogService>().createLog(
          uid: _currentUser.uid,
          log: visitLog,
          collection: 'visits',
          documentID: null,
        );

        yield LoadedState(
          title: title,
          user: _currentUser,
        );

        _visitingLogLogsAddDelegate.clearForm();
        _visitingLogLogsAddDelegate.showMessage(message: 'Visit log added.');
      } catch (error) {
        _visitingLogLogsAddDelegate.showMessage(message: error.toString());
      }
    }
  }
}
