import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:p/ServiceLocator.dart';
import 'package:p/blocs/readingLogBooks/Bloc.dart';
import 'package:p/models/BookModel.dart';
import 'package:p/models/UserModel.dart';
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
  String _sortBy = 'recent';

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
            await locator<LogService>().streamBooksForUser(
          uid: _currentUser.uid,
        );

        booksStream.listen(
          (QuerySnapshot event) {
            List<BookModel> books = event.documents
                .map(
                  (doc) => BookModel.fromDocumentSnapshot(ds: doc),
                )
                .toList();
            add(
              BooksUpdatedEvent(books: books),
            );
          },
        );
      } catch (error) {
        yield ErrorState(error: error);
      }
    }

    if (event is BooksUpdatedEvent) {
      final List<BookModel> books = event.books;

      switch (_sortBy) {
        case 'recent':
          books.sort(
            (a, b) => b.modified.compareTo(a.modified),
          );
          break;
        case 'mostRead':
          books.sort(
            (a, b) => b.logCount.compareTo(a.logCount),
          );
          break;
        case 'leastRead':
          books.sort(
            (a, b) => a.logCount.compareTo(b.logCount),
          );
          break;
        default:
          break;
      }

      yield LoadedState(
        //user: _currentUser,
        books: books,
        sortBy: _sortBy,
      );
    }

    if (event is UpdateSortEvent) {
      _sortBy = event.sortBy;
      add(
        LoadPageEvent(),
      );
    }
  }
}
