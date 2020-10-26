import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:p/ServiceLocator.dart';
import 'package:p/models/ParentLogModel.dart';
import 'package:p/models/UserModel.dart';
import 'package:p/services/AuthService.dart';
import 'package:p/services/LogService.dart';

import 'Bloc.dart';

abstract class ReadingLogBooksAddDelegate {
  void showMessage({@required String message});
  void clearForm();
}

class ReadingLogBooksAddBloc
    extends Bloc<ReadingLogBooksAddEvent, ReadingLogBooksAddState> {
  ReadingLogBooksAddBloc() : super(null);

  ReadingLogBooksAddDelegate _readingLogBooksAddDelegate;
  UserModel _currentUser;

  void setDelegate({@required ReadingLogBooksAddDelegate delegate}) {
    this._readingLogBooksAddDelegate = delegate;
  }

  @override
  Stream<ReadingLogBooksAddState> mapEventToState(
      ReadingLogBooksAddEvent event) async* {
    if (event is LoadPageEvent) {
      yield LoadingState();

      try {
        _currentUser = await locator<AuthService>().getCurrentUser();

        yield LoadedState(
          autoValidate: false,
          formKey: GlobalKey<FormState>(),
        );
      } catch (error) {
        yield ErrorState(error: error);
      }
    }

    if (event is SubmitEvent) {
      final String bookTitle = event.bookTitle;
      final GlobalKey<FormState> formKey = event.formKey;

      if (formKey.currentState.validate()) {
        yield LoadingState();

        try {
          ParentLogModel book = ParentLogModel(
            id: null,
            created: DateTime.now(),
            modified: DateTime.now(),
            title: bookTitle,
            logCount: 0,
          );

          locator<LogService>().createParentLog(
            uid: _currentUser.uid,
            collection: 'books',
            parentLog: book,
          );

          yield LoadedState(
            autoValidate: false,
            formKey: formKey,
          );

          _readingLogBooksAddDelegate.clearForm();
          _readingLogBooksAddDelegate.showMessage(message: 'Book added.');
        } catch (error) {
          _readingLogBooksAddDelegate.showMessage(message: error.toString());
        }
      }
    }
  }
}
