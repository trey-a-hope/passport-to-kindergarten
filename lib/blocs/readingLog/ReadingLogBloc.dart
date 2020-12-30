import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:p/ServiceLocator.dart';
import 'package:p/constants.dart';
import 'package:p/models/BookModel.dart';
import 'package:p/models/EntryModel.dart';
import 'package:p/models/LogModel.dart';
import 'package:p/models/StampModel.dart';
import 'package:p/models/UserModel.dart';
import 'package:p/services/AuthService.dart';
import 'package:p/services/BookService.dart';
import 'package:p/services/LogService.dart';
import 'package:p/services/StampService.dart';
import 'package:p/services/UserService.dart';

import 'Bloc.dart';

abstract class ReadingLogDelegate {
  void showMessage({@required String message});
  void showAwardMessage();
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

        List<String> bookEntriesIDs = (await locator<LogService>()
                .retrieveEntries(uid: _currentUser.uid, type: 'books'))
            .map((bookEntry) => bookEntry.entryID)
            .toList();

        //Validate that this student has an entry for every book of the month currently.
        List<String> booksOfTheMonthIDs =
            (await locator<BookService>().retrieveBooksOfTheMonth())
                .map((bookOfTheMonth) => bookOfTheMonth.id)
                .toList();

        for (var i = 0; i < booksOfTheMonthIDs.length; i++) {
          if (!bookEntriesIDs.contains(booksOfTheMonthIDs[i])) {
            await locator<LogService>().createEntry(
              uid: _currentUser.uid,
              type: 'books',
              entry: EntryModel(
                id: null,
                entryID: booksOfTheMonthIDs[i],
                created: DateTime.now(),
                modified: DateTime.now(),
                logCount: 0,
              ),
            );
          }
        }

        Stream<QuerySnapshot> entriesStream = await locator<LogService>()
            .streamEntries(uid: _currentUser.uid, type: 'books');

        entriesStream.listen(
          (QuerySnapshot event) {
            List<EntryModel> bookEntries = event.documents
                .map(
                  (doc) => EntryModel.fromDocSnapshot(ds: doc),
                )
                .toList();

            add(
              BooksUpdatedEvent(bookEntries: bookEntries),
            );
          },
        );
      } catch (error) {
        yield ErrorState(error: error);
      }
    }

    if (event is BooksUpdatedEvent) {
      final List<EntryModel> bookEntries = event.bookEntries;

      _currentUser.bookSortBy = 'recent';

      bookEntries.sort(
        (a, b) => b.modified.compareTo(a.modified),
      );

      for (int i = 0; i < bookEntries.length; i++) {
        EntryModel bookEntry = bookEntries[i];

        final BookModel book = await locator<BookService>()
            .retrieveBook(bookID: bookEntry.entryID);

        bookEntry.book = book;

        final List<LogModel> logs = await locator<LogService>().retrieveLogs(
          uid: _currentUser.uid,
          type: 'books',
          idOfEntry: bookEntry.id,
        );

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

        bookEntry.logEvents = logEvents;
      }
      yield LoadedState(
        bookEntries: bookEntries,
        currentUser: _currentUser,
      );
    }

    if (event is CreateBookEvent) {
      final String title = event.title;
      final String author = event.author;
      final DateTime now = DateTime.now();

      try {
        await locator<BookService>().createBook(
          uid: _currentUser.uid,
          book: BookModel(
            author: author,
            title: title,
            created: now,
            modified: now,
            id: null,
            given: true,
            summary: null,
            conversationStarters: null,
            imgUrl: null,
            youtubeUrl: null,
          ),
        );

        _readingLogDelegate.showMessage(message: 'Book added!');
      } catch (error) {
        yield ErrorState(error: error);
      }
    }

    if (event is CreateBookLogEvent) {
      final String idOfEntry = event.idOfEntry;
      final DateTime date = event.date;
      final bool totalLogLimitReached = event.totalLogLimitReached;

      try {
        final LogModel log = LogModel(
          created: date,
          id: null,
        );

        locator<LogService>().createLog(
          uid: _currentUser.uid,
          collection: 'books',
          idOfEntry: idOfEntry,
          log: log,
        );

        if (totalLogLimitReached) {
          await locator<StampService>().createStamp(
            uid: _currentUser.uid,
            stamp: StampModel(
              name: '15 Books Read',
              imgUrl: '$STAMP_15_BOOKS_READ',
              created: DateTime.now(),
              id: null,
            ),
          );

          _readingLogDelegate.showAwardMessage();
        } else {
          _readingLogDelegate.showMessage(message: 'Log added!');
        }
      } catch (error) {
        yield ErrorState(error: error);
      }
    }
  }
}
