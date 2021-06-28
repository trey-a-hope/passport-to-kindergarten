import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:p/models/BookModel.dart';
import 'package:p/models/EntryModel.dart';

abstract class IBookService {
  Future<void> createBook({
    @required String uid,
    @required BookModel book,
  });

  Future<BookModel> retrieveBook({@required String bookID});
  Future<List<BookModel>> retrieveBooksOfTheMonth();
  Future<void> updateBook(
      {@required String bookID, @required Map<String, dynamic> data});
}

class BookService extends IBookService {
  final CollectionReference _usersColRef =
      FirebaseFirestore.instance.collection('Users');
  final CollectionReference _booksColRef =
      FirebaseFirestore.instance.collection('Books');
  final CollectionReference _dataColRef =
      FirebaseFirestore.instance.collection('Data');

  @override
  Future<void> createBook({
    @required String uid,
    @required BookModel book,
  }) async {
    try {
      final WriteBatch batch = FirebaseFirestore.instance.batch();

      //Add new book to books collection.
      final DocumentReference bookDocRef = _booksColRef.doc();
      book.id = bookDocRef.id;
      batch.set(bookDocRef, book.toMap());

      //Add a new entry in the user's profile linking the book to them.
      final DocumentReference entryDocRef =
          _usersColRef.doc(uid).collection('books').doc();
      final String entryID = entryDocRef.id;

      EntryModel entry = EntryModel(
        id: entryID,
        entryID: book.id,
        created: DateTime.now(),
        modified: DateTime.now(),
        logCount: 0,
      );

      batch.set(entryDocRef, entry.toMap());

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
      final DocumentReference bookDocRef = _booksColRef.doc(bookID);

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
      final Map<String, dynamic> data =
          (await _dataColRef.doc('books_of_the_month').get()).data();

      final dynamic ids = data['ids'];

      final List<String> booksOfTheMonthIDs = [];

      for (dynamic booksOfTheMonthID in ids) {
        booksOfTheMonthIDs.add(booksOfTheMonthID);
      }

      List<BookModel> booksOfTheMonth = [];

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

  @override
  Future<void> updateBook(
      {@required String bookID, @required Map<String, dynamic> data}) async {
    try {
      DocumentSnapshot documentSnapshot = await _booksColRef.doc(bookID).get();
      DocumentReference documentReference = documentSnapshot.reference;
      await documentReference.update(data);
      return;
    } catch (e) {
      throw Exception(
        e.toString(),
      );
    }
  }
}
