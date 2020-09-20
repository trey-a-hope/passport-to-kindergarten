import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:p/ServiceLocator.dart';
import 'package:p/blocs/readingLogAdd/Bloc.dart';
import 'package:p/models/UserModel.dart';
import 'package:p/models/LogModel.dart';
import 'package:p/services/AuthService.dart';
import 'package:p/services/LogService.dart';

abstract class ReadingLogAddDelegate {
  void showMessage({@required String message});
  void clearForm();
}

class ReadingLogAddBloc extends Bloc<ReadingLogAddEvent, ReadingLogAddState> {
  ReadingLogAddBloc() : super(null);

  ReadingLogAddDelegate _readingLogAddDelegate;
  UserModel _currentUser;

  void setDelegate({@required ReadingLogAddDelegate delegate}) {
    this._readingLogAddDelegate = delegate;
  }

  @override
  Stream<ReadingLogAddState> mapEventToState(ReadingLogAddEvent event) async* {
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
          );

          locator<LogService>().createReadLog(
            uid: _currentUser.uid,
            log: visitLog,
          );

          yield LoadedState(
            user: _currentUser,
            autoValidate: false,
            formKey: formKey,
          );

          _readingLogAddDelegate.clearForm();
          _readingLogAddDelegate.showMessage(message: 'Read log added.');
        } catch (error) {
          _readingLogAddDelegate.showMessage(message: error.toString());
        }
      }

      //todo: submit visit log.
    }
  }
}
