import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:p/ServiceLocator.dart';
import 'package:p/models/ChildLogModel.dart';
import 'package:p/models/ParentLogModel.dart';
import 'package:p/models/UserModel.dart';
import 'package:p/models/LogModel.dart';
import 'package:p/services/AuthService.dart';
import 'package:p/services/LogService.dart';

import 'Bloc.dart';

abstract class ReadingLogLogsAddDelegate {
  void showMessage({@required String message});
  void clearForm();
}

class ReadingLogLogsAddBloc
    extends Bloc<ReadingLogLogsAddEvent, ReadingLogLogsAddState> {
  ReadingLogLogsAddBloc({
    @required this.book,
  }) : super(null);

  ReadingLogLogsAddDelegate _readingLogLogsAddDelegate;
  UserModel _currentUser;
  ParentLogModel book;
  void setDelegate({@required ReadingLogLogsAddDelegate delegate}) {
    this._readingLogLogsAddDelegate = delegate;
  }

  @override
  Stream<ReadingLogLogsAddState> mapEventToState(
      ReadingLogLogsAddEvent event) async* {
    if (event is LoadPageEvent) {
      yield LoadingState();

      try {
        _currentUser = await locator<AuthService>().getCurrentUser();

        yield LoadedState(
          autoValidate: false,
          formKey: GlobalKey<FormState>(),
          book: book,
        );
      } catch (error) {
        yield ErrorState(error: error);
      }
    }

    if (event is SubmitEvent) {
      //final String bookTitle = event.bookTitle;
      final GlobalKey<FormState> formKey = event.formKey;
      final String notes = event.notes;

      if (formKey.currentState.validate()) {
        yield LoadingState();

        try {
          ChildLogModel log = ChildLogModel(
            id: null,
            created: DateTime.now(),
            title: 'Test title here.',
            notes: notes,
          );

          locator<LogService>().createChildLog(
            uid: _currentUser.uid,
            collection: 'books',
            documentID: book.id,
            subCollection: 'logs',
            childLogModel: log,
          );

          yield LoadedState(
            autoValidate: false,
            formKey: formKey,
            book: book,
          );

          _readingLogLogsAddDelegate.clearForm();
          _readingLogLogsAddDelegate.showMessage(message: 'Log added.');
        } catch (error) {
          _readingLogLogsAddDelegate.showMessage(message: error.toString());
        }
      }
    }
  }
}
