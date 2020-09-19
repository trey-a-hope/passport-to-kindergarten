import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:p/ServiceLocator.dart';
import 'package:p/blocs/visitingLogAdd/Bloc.dart';
import 'package:p/models/UserModel.dart';
import 'package:p/models/VisitingLogModel.dart';
import 'package:p/services/AuthService.dart';
import 'package:p/services/VisitingLogService.dart';

abstract class VisitingLogAddDelegate {
  void showMessage({@required String message});
  void clearForm();
}

class VisitingLogAddBloc
    extends Bloc<VisitingLogAddEvent, VisitingLogAddState> {
  VisitingLogAddBloc() : super(null);

  VisitingLogAddDelegate _visitingLogAddDelegate;
  UserModel _currentUser;

  void setDelegate({@required VisitingLogAddDelegate delegate}) {
    this._visitingLogAddDelegate = delegate;
  }

  @override
  Stream<VisitingLogAddState> mapEventToState(
      VisitingLogAddEvent event) async* {
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
          VisitingLogModel visitLog = VisitingLogModel(
            id: null,
            description: description,
            created: DateTime.now(),
          );

          locator<VisitingLogService>().createVisitLog(
            uid: _currentUser.uid,
            visitingLog: visitLog,
          );

          yield LoadedState(
            user: _currentUser,
            autoValidate: false,
            formKey: formKey,
          );

          _visitingLogAddDelegate.clearForm();
          _visitingLogAddDelegate.showMessage(message: 'Visit log added.');
        } catch (error) {
          _visitingLogAddDelegate.showMessage(message: error.toString());
        }
      }

      //todo: submit visit log.
    }
  }
}
