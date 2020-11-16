import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:p/models/BookModel.dart';
import 'package:p/models/LogModel.dart';
import 'package:p/models/VisitModel.dart';

abstract class ILogService {
  void createBookForUser({
    @required String uid,
    @required BookModel book,
  });

  void createVisitForUser({
    @required String uid,
    @required VisitModel visit,
  });

  Future<List<BookModel>> getBooksForUser({
    @required String uid,
  });

  Future<Stream<QuerySnapshot>> streamBooksForUser({
    @required String uid,
  });

  Future<Stream<QuerySnapshot>> streamVisitsForUser({
    @required String uid,
  });

  Future<List<VisitModel>> getVisitsForUser({
    @required String uid,
  });

  Future<List<LogModel>> getLogs({
    @required String uid,
    @required String collection,
    @required String documentID,
  });

  Future<Stream<QuerySnapshot>> streamLogs({
    @required String uid,
    @required String collection,
    @required String documentID,
  });

  Future<void> createLog({
    @required String uid,
    @required String collection,
    @required String documentID,
    @required LogModel log,
  });
}

class LogService extends ILogService {
  final CollectionReference _usersColRef =
      Firestore.instance.collection('Users');

  @override
  Future<void> createBookForUser({
    @required String uid,
    @required BookModel book,
  }) async {
    try {
      final DocumentReference userDocRef = _usersColRef.document(uid);

      final CollectionReference booksColRef = userDocRef.collection('books');

      DocumentReference bookDocRef = booksColRef.document();
      book.id = bookDocRef.documentID;
      bookDocRef.setData(
        book.toMap(),
      );
    } catch (e) {
      throw Exception(
        e.toString(),
      );
    }
  }

  @override
  Future<List<BookModel>> getBooksForUser({
    @required String uid,
  }) async {
    try {
      final DocumentReference userDocRef = _usersColRef.document(uid);

      List<DocumentSnapshot> bookDocSnaps =
          (await userDocRef.collection('books').getDocuments()).documents;

      List<BookModel> books = bookDocSnaps
          .map(
            (bookDocSnap) => BookModel.fromDocumentSnapshot(ds: bookDocSnap),
          )
          .toList();

      return books;
    } catch (e) {
      throw Exception(
        e.toString(),
      );
    }
  }

  @override
  void createVisitForUser(
      {@required String uid, @required VisitModel visit}) async {
    try {
      final DocumentReference userDocRef = _usersColRef.document(uid);

      final CollectionReference visitsColRef = userDocRef.collection('visits');

      DocumentReference visitDocRef = visitsColRef.document();
      visit.id = visitDocRef.documentID;
      visitDocRef.setData(
        visit.toMap(),
      );
    } catch (e) {
      throw Exception(
        e.toString(),
      );
    }
  }

  @override
  Future<List<VisitModel>> getVisitsForUser({@required String uid}) async {
    try {
      final DocumentReference userDocRef = _usersColRef.document(uid);

      List<DocumentSnapshot> visitDocSnaps =
          (await userDocRef.collection('visits').getDocuments()).documents;

      List<VisitModel> visits = visitDocSnaps
          .map(
            (visitDocSnap) => VisitModel.fromDocumentSnapshot(ds: visitDocSnap),
          )
          .toList();

      return visits;
    } catch (e) {
      throw Exception(
        e.toString(),
      );
    }
  }

  @override
  Future<void> createLog(
      {@required String uid,
      @required String collection,
      @required String documentID,
      @required LogModel log}) async {
    try {
      final DocumentReference userDocRef = _usersColRef.document(uid);

      final DocumentReference logDocRef = userDocRef
          .collection('books')
          .document(documentID)
          .collection('logs')
          .document();

      log.id = logDocRef.documentID;
      logDocRef.setData(
        log.toMap(),
      );
    } catch (e) {
      throw Exception(
        e.toString(),
      );
    }
  }

  @override
  Future<List<LogModel>> getLogs(
      {@required String uid,
      @required String collection,
      @required String documentID}) async {
    try {
      final DocumentReference userDocRef = _usersColRef.document(uid);

      List<DocumentSnapshot> logDocSnaps = (await userDocRef
              .collection(collection)
              .document(documentID)
              .collection('logs')
              .getDocuments())
          .documents;

      return logDocSnaps
          .map((logDocSnap) => LogModel.fromDocumentSnapshot(ds: logDocSnap))
          .toList();
    } catch (e) {
      throw Exception(
        e.toString(),
      );
    }
  }

  @override
  Future<Stream<QuerySnapshot>> streamLogs({
    @required String uid,
    @required String collection,
    @required String documentID,
  }) async {
    try {
      final DocumentReference userDocRef = _usersColRef.document(uid);

      Stream<QuerySnapshot> logQueryStream = userDocRef
          .collection(collection)
          .document(documentID)
          .collection('logs')
          .snapshots();

      return logQueryStream;
    } catch (error) {
      throw Exception(
        error.toString(),
      );
    }
  }

  @override
  Future<Stream<QuerySnapshot>> streamBooksForUser(
      {@required String uid}) async {
    try {
      final DocumentReference userDocRef = _usersColRef.document(uid);

      Stream<QuerySnapshot> booksQueryStream =
          userDocRef.collection('books').snapshots();

      return booksQueryStream;
    } catch (error) {
      throw Exception(
        error.toString(),
      );
    }
  }

  @override
  Future<Stream<QuerySnapshot>> streamVisitsForUser(
      {@required String uid}) async {
    try {
      final DocumentReference userDocRef = _usersColRef.document(uid);

      Stream<QuerySnapshot> visitsQueryStream =
          userDocRef.collection('visits').snapshots();

      return visitsQueryStream;
    } catch (error) {
      throw Exception(
        error.toString(),
      );
    }
  }
}
