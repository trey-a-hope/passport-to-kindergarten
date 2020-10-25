import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:p/ServiceLocator.dart';
import 'package:p/blocs/visitingLogLogsAdd/Bloc.dart';
import 'package:p/models/UserModel.dart';
import 'package:p/models/LogModel.dart';
import 'package:p/services/AuthService.dart';
import 'package:p/services/LogService.dart';

abstract class VisitingLogLogsAddDelegate {
  void showMessage({@required String message});
  void clearForm();
}

class VisitingLogLogsAddBloc
    extends Bloc<VisitingLogLogsAddEvent, VisitingLogLogsAddState> {
  VisitingLogLogsAddBloc() : super(null);

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
          autoValidate: false,
          formKey: GlobalKey<FormState>(),
        );
      } catch (error) {
        yield ErrorState(error: error);
      }
    }

    if (event is SubmitEvent) {
      final String description = event.description;
      final GlobalKey<FormState> formKey = event.formKey;

      if (formKey.currentState.validate()) {
        yield LoadingState();

        try {
          LogModel visitLog = LogModel(
            id: null,
            description: description,
            created: DateTime.now(),
            bookTitle: 'Visit Title'
          );

          // locator<LogService>().createVisitLog(
          //   uid: _currentUser.uid,
          //   log: visitLog,
          // );

          yield LoadedState(
            user: _currentUser,
            autoValidate: false,
            formKey: formKey,
          );

          _visitingLogLogsAddDelegate.clearForm();
          _visitingLogLogsAddDelegate.showMessage(message: 'Visit log added.');
        } catch (error) {
          _visitingLogLogsAddDelegate.showMessage(message: error.toString());
        }
      }

      //todo: submit visit log.
    }
  }
}
