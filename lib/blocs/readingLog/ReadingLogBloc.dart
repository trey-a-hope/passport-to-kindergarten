import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:p/ServiceLocator.dart';
import 'package:p/models/BookModel.dart';
import 'package:p/models/LogModel.dart';
import 'package:p/models/UserModel.dart';
import 'package:p/services/AuthService.dart';
import 'package:p/services/LogService.dart';

import 'Bloc.dart';

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

      _currentUser.bookSortBy = 'recent';

      books.sort(
        (a, b) => b.modified.compareTo(a.modified),
      );

      for (int bookCount = 0; bookCount < books.length; bookCount++) {
        final BookModel book = books[bookCount];
        final List<LogModel> logs = await locator<LogService>().getLogs(
            uid: _currentUser.uid, collection: 'books', documentID: book.id);

        Map<DateTime, List<LogModel>> logEvents =
            Map<DateTime, List<LogModel>>();

        logs.forEach(
          (LogModel log) {
            DateTime dayKey = DateTime(
              log.created.year,
              log.created.month,
              log.created.day,
            );

            if (logEvents.containsKey(dayKey)) {
              if (!logEvents[dayKey].contains(log)) {
                logEvents[dayKey].add(log);
              }
            } else {
              logEvents[dayKey] = [log];
            }
          },
        );

        book.logEvents = logEvents;
      }

      yield LoadedState(
        books: books,
        currentUser: _currentUser,
      );
    }

    if (event is CreateBookEvent) {
      final String title = event.title;
      final String author = event.author;
      final DateTime now = DateTime.now();

      try {
        await locator<LogService>().createBookForUser(
          uid: _currentUser.uid,
          book: BookModel(
            author: author,
            title: title,
            logCount: 0,
            created: now,
            modified: now,
            id: null,
            given: true,
            summary: null,
            conversationStarters: null,
            assetImagePath: null,
          ),
        );

        _readingLogDelegate.showMessage(message: 'Book added!');

      } catch (error) {
        yield ErrorState(error: error);
      }
    }

    if (event is CreateBookLogEvent) {
      final String bookID = event.bookID;
      final DateTime date = event.date;

      try {
        final LogModel log = LogModel(
          created: date,
          id: null,
        );

        locator<LogService>().createLog(
          uid: _currentUser.uid,
          collection: 'books',
          documentID: bookID,
          log: log,
        );

        _readingLogDelegate.showMessage(message: 'Log added!');
      } catch (error) {
        yield ErrorState(error: error);
      }
    }
  }
}
