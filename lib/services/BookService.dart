import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:p/models/BookModel.dart';
import 'package:p/models/EntryModel.dart';
import 'package:p/models/LogModel.dart';
import 'package:p/models/VisitModel.dart';

abstract class IBookService {
  Future<void> createBook({
    @required String uid,
    @required BookModel book,
  });

  Future<BookModel> retrieveBook({@required String bookID});
  Future<List<BookModel>> retrieveBooksOfTheMonth();

  // BookModel retrieveBook({@required String bookID});

  // void updateBook(
  //     {@required String bookID, @required Map<String, dynamic> data});

  // void deleteBook({@required String bookID});
}

class BookService extends IBookService {
  final CollectionReference _usersColRef =
      Firestore.instance.collection('Users');
  final CollectionReference _booksColRef =
      Firestore.instance.collection('Books');
  final CollectionReference _dataColRef = Firestore.instance.collection('Data');

  @override
  Future<void> createBook({
    @required String uid,
    @required BookModel book,
  }) async {
    try {
      final WriteBatch batch = Firestore.instance.batch();

      //Add new book to books collection.
      final DocumentReference bookDocRef = _booksColRef.document();
      book.id = bookDocRef.documentID;
      batch.setData(bookDocRef, book.toMap());

      //Add a new entry in the user's profile linking the book to them.
      final DocumentReference entryDocRef =
          _usersColRef.document(uid).collection('books').document();
      final String entryID = entryDocRef.documentID;

      EntryModel entry = EntryModel(
        id: entryID,
        entryID: book.id,
        created: DateTime.now(),
        modified: DateTime.now(),
        logCount: 0,
      );

      batch.setData(entryDocRef, entry.toMap());

      await batch.commit();

      return;
    } catch (e) {
      throw Exception(
        e.toString(),
      );
    }
  }

  @override
  Future<BookModel> retrieveBook({@required String bookID}) async {
    try {
      final DocumentReference bookDocRef = _booksColRef.document(bookID);

      final DocumentSnapshot bookDocSnapshot = (await bookDocRef.get());

      BookModel book = BookModel.fromDocumentSnapshot(ds: bookDocSnapshot);

      return book;
    } catch (e) {
      throw Exception(
        e.toString(),
      );
    }
  }

  @override
  Future<List<BookModel>> retrieveBooksOfTheMonth() async {
    try {
      final dynamic data =
          (await _dataColRef.document('books_of_the_month').get()).data['ids'];

      final List<String> booksOfTheMonthIDs = [];

      for (dynamic booksOfTheMonthID in data) {
        booksOfTheMonthIDs.add(booksOfTheMonthID);
      }

      List<BookModel> booksOfTheMonth = List<BookModel>();

      for (var i = 0; i < booksOfTheMonthIDs.length; i++) {
        final BookModel bookOfTheMonth =
            await retrieveBook(bookID: booksOfTheMonthIDs[i]);

        booksOfTheMonth.add(bookOfTheMonth);
      }

      return booksOfTheMonth;
    } catch (e) {
      throw Exception(
        e.toString(),
      );
    }
  }

  // @override
  // void deleteBook({String bookID}) {
  //   // TODO: implement deleteBook
  // }

  // @override
  // BookModel retrieveBook({String bookID}) {
  //   // TODO: implement retrieveBook
  //   throw UnimplementedError();
  // }

  // @override
  // void updateBook({String bookID, Map<String, dynamic> data}) {
  //   // TODO: implement updateBook
  // }
}
