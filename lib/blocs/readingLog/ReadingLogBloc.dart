import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:p/ServiceLocator.dart';
import 'package:p/blocs/readingLog/Bloc.dart';
import 'package:p/models/BookModel.dart';
import 'package:p/models/UserModel.dart';
import 'package:p/models/LogModel.dart';
import 'package:p/services/AuthService.dart';
import 'package:p/services/LogService.dart';

abstract class ReadingLogDelegate {
  void showMessage({@required String message});
}

class ReadingLogBloc extends Bloc<ReadingLogEvent, ReadingLogState> {
  ReadingLogBloc() : super(null);

  ReadingLogDelegate _readingLogDelegate;
  UserModel _currentUser;

  void setDelegate({@required ReadingLogDelegate delegate}) {
    this._readingLogDelegate = delegate;
  }

  @override
  Stream<ReadingLogState> mapEventToState(ReadingLogEvent event) async* {
    if (event is LoadPageEvent) {
      yield LoadingState();

      try {
        _currentUser = await locator<AuthService>().getCurrentUser();

        Stream<QuerySnapshot> booksStream = await locator<LogService>()
            .retrieveBooksStream(uid: _currentUser.uid);

        booksStream.listen((QuerySnapshot event) {
          List<BookModel> books = event.documents
              .map((doc) => BookModel.fromDocumentSnapshot(ds: doc))
              .toList();
          add(BooksUpdatedEvent(books: books));
        });
      } catch (error) {
        yield ErrorState(error: error);
      }
    }

    if (event is BooksUpdatedEvent) {
      final List<BookModel> books = event.books;

      yield LoadedState(
        user: _currentUser,
        books: books,
      );
    }
  }
}
