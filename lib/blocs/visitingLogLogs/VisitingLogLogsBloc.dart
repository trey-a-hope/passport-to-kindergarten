import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:p/ServiceLocator.dart';
import 'package:p/models/UserModel.dart';
import 'package:p/models/LogModel.dart';
import 'package:p/services/AuthService.dart';
import 'package:p/services/LogService.dart';

import 'Bloc.dart';

abstract class VisitingLogLogsDelegate {
  void showMessage({@required String message});
  void clearForm();
}

class VisitingLogLogsBloc
    extends Bloc<VisitingLogLogsEvent, VisitingLogLogState> {
  VisitingLogLogsBloc({
    @required this.title,
    @required this.initialSelectedDay,
  }) : super(null);

  final String title;
  final DateTime initialSelectedDay;

  VisitingLogLogsDelegate _visitingLogLogsDelegate;
  UserModel _currentUser;

  void setDelegate({@required VisitingLogLogsDelegate delegate}) {
    this._visitingLogLogsDelegate = delegate;
  }

  @override
  Stream<VisitingLogLogState> mapEventToState(
      VisitingLogLogsEvent event) async* {
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
              bookTitle: 'Visit Title');

          // locator<LogService>().createVisitLog(
          //   uid: _currentUser.uid,
          //   log: visitLog,
          // );

          yield LoadedState(
            user: _currentUser,
            autoValidate: false,
            formKey: formKey,
          );

          _visitingLogLogsDelegate.clearForm();
          _visitingLogLogsDelegate.showMessage(message: 'Visit log added.');
        } catch (error) {
          _visitingLogLogsDelegate.showMessage(message: error.toString());
        }
      }

      //todo: submit visit log.
    }
  }
}
