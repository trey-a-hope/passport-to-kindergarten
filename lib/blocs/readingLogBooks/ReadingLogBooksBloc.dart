import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:p/ServiceLocator.dart';
import 'package:p/blocs/readingLogBooks/Bloc.dart';
import 'package:p/models/ParentLogModel.dart';
import 'package:p/models/UserModel.dart';
import 'package:p/models/LogModel.dart';
import 'package:p/services/AuthService.dart';
import 'package:p/services/LogService.dart';

abstract class ReadingLogBooksDelegate {
  void showMessage({@required String message});
}

class ReadingLogBooksBloc
    extends Bloc<ReadingLogBooksEvent, ReadingLogBooksState> {
  ReadingLogBooksBloc() : super(null);

  ReadingLogBooksDelegate _readingLogBooksDelegate;
  UserModel _currentUser;

  void setDelegate({@required ReadingLogBooksDelegate delegate}) {
    this._readingLogBooksDelegate = delegate;
  }

  @override
  Stream<ReadingLogBooksState> mapEventToState(
      ReadingLogBooksEvent event) async* {
    if (event is LoadPageEvent) {
      yield LoadingState();

      try {
        _currentUser = await locator<AuthService>().getCurrentUser();

        Stream<QuerySnapshot> booksStream =
            await locator<LogService>().retrieveParentLogsStream(
          uid: _currentUser.uid,
          collection: 'books',
        );

        booksStream.listen((QuerySnapshot event) {
          List<ParentLogModel> books = event.documents
              .map((doc) => ParentLogModel.fromDocumentSnapshot(ds: doc))
              .toList();
          add(BooksUpdatedEvent(books: books));
        });
      } catch (error) {
        yield ErrorState(error: error);
      }
    }

    if (event is BooksUpdatedEvent) {
      final List<ParentLogModel> books = event.books;

      yield LoadedState(
        user: _currentUser,
        books: books,
      );
    }
  }
}
