import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:p/models/BookModel.dart';
import 'package:p/models/ChildLogModel.dart';
import 'package:p/models/ParentLogModel.dart';

abstract class ILogService {
  void createBookForUser({
    @required String uid,
    @required BookModel book,
  });

  Future<List<BookModel>> getBooksForUser({
    @required String uid,
  });

  Future<List<ChildLogModel>> getLogsForBookForUser({
    @required String uid,
    @required String bookID,
  });

  //RECATOR EVERYTHING BELOW!

  void createParentLog(
      {@required String uid,
      @required String collection,
      @required ParentLogModel parentLog});

  void createChildLog({
    @required String uid,
    @required String collection,
    @required String documentID,
    @required String subCollection,
    @required ChildLogModel childLogModel,
  });

  Future<List<ParentLogModel>> retrieveParentLogs({
    @required String uid,
    @required String collection,
  });

  Future<Stream<QuerySnapshot>> retrieveParentLogsStream({
    @required String uid,
    @required String collection,
  });

  Future<Stream<QuerySnapshot>> retrieveChildLogsStream({
    @required String uid,
    @required String collection,
    @required String documentID,
    @required String subCollection,
  });

  Future<Stream<QuerySnapshot>> streamVisitLogs({
    @required String uid,
    String title,
  });

  Future<void> createVisitLog({
    @required String uid,
    ChildLogModel log,
  });
}

class LogService extends ILogService {
  final CollectionReference _usersColRef =
      Firestore.instance.collection('Users');

  @override
  void createParentLog(
      {@required String uid,
      @required String collection,
      @required ParentLogModel parentLog}) {
    try {
      final DocumentReference userDocRef = _usersColRef.document(uid);

      final CollectionReference parentLogColRef =
          userDocRef.collection(collection);

      DocumentReference parentLogDocRef = parentLogColRef.document();
      parentLog.id = parentLogDocRef.documentID;
      parentLogDocRef.setData(
        parentLog.toMap(),
      );
    } catch (e) {
      throw Exception(
        e.toString(),
      );
    }
  }

  @override
  void createChildLog(
      {@required String uid,
      @required String collection,
      @required String documentID,
      @required String subCollection,
      @required ChildLogModel childLogModel}) {
    try {
      final WriteBatch batch = Firestore.instance.batch();

      final DocumentReference userDocRef = _usersColRef.document(uid);

      final DocumentReference parentLogDocRef =
          userDocRef.collection(collection).document(documentID);

      final DocumentReference childLogDocRef =
          parentLogDocRef.collection(subCollection).document();

      childLogModel.id = childLogDocRef.documentID;

      batch.setData(
        childLogDocRef,
        childLogModel.toMap(),
      );

      batch.updateData(
        parentLogDocRef,
        {
          'logCount': FieldValue.increment(1),
          'modified': DateTime.now(),
        },
      );

      batch.commit();
    } catch (e) {
      throw Exception(
        e.toString(),
      );
    }
  }

  @override
  Future<List<ParentLogModel>> retrieveParentLogs({
    @required String uid,
    @required String collection,
  }) async {
    try {
      final DocumentReference userDocRef = _usersColRef.document(uid);

      final CollectionReference parentLogColRef =
          userDocRef.collection(collection);

      List<ParentLogModel> visitLogs = (await parentLogColRef.getDocuments())
          .documents
          .map((doc) => ParentLogModel.fromDocumentSnapshot(ds: doc))
          .toList();

      return visitLogs;
    } catch (e) {
      throw Exception(
        e.toString(),
      );
    }
  }

  @override
  Future<Stream<QuerySnapshot>> retrieveParentLogsStream({
    @required String uid,
    @required String collection,
  }) async {
    try {
      final DocumentReference userDocRef = _usersColRef.document(uid);

      final CollectionReference parentLogColRef =
          userDocRef.collection(collection);

      return parentLogColRef.snapshots();
    } catch (e) {
      throw Exception(
        e.toString(),
      );
    }
  }

  @override
  Future<Stream<QuerySnapshot>> retrieveChildLogsStream({
    @required String uid,
    @required String collection,
    @required String documentID,
    @required String subCollection,
  }) async {
    try {
      final DocumentReference userDocRef = _usersColRef.document(uid);

      final CollectionReference childLogColRef = userDocRef
          .collection(collection)
          .document(documentID)
          .collection(subCollection);

      return childLogColRef.snapshots();
    } catch (e) {
      throw Exception(
        e.toString(),
      );
    }
  }

  @override
  Future<Stream<QuerySnapshot>> streamVisitLogs({
    @required String uid,
    String title,
  }) async {
    try {
      final DocumentReference userDocRef = _usersColRef.document(uid);

      Query query = userDocRef.collection('visitLogs');

      if (title != null) {
        query = query.where('title', isEqualTo: title);
      }

      Stream<QuerySnapshot> visitLogQueryStream = query.snapshots();

      return visitLogQueryStream;
    } catch (e) {
      throw Exception(
        e.toString(),
      );
    }
  }

  @override
  Future<void> createVisitLog({
    @required String uid,
    @required ChildLogModel log,
  }) async {
    try {
      final DocumentReference userDocRef = _usersColRef.document(uid);

      final CollectionReference parentLogColRef =
          userDocRef.collection('visitLogs');

      DocumentReference childLogDocRef = parentLogColRef.document();
      log.id = childLogDocRef.documentID;
      childLogDocRef.setData(
        log.toMap(),
      );
    } catch (e) {
      throw Exception(
        e.toString(),
      );
    }
  }

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
  Future<List<ChildLogModel>> getLogsForBookForUser({
    @required String uid,
    @required String bookID,
  }) async {
    try {
      final DocumentReference userDocRef = _usersColRef.document(uid);

      List<DocumentSnapshot> logDocs = (await userDocRef
              .collection('books')
              .document(bookID)
              .collection('logs')
              .getDocuments())
          .documents;

      List<ChildLogModel> logs = logDocs
          .map((logDoc) => ChildLogModel.fromDocumentSnapshot(ds: logDoc))
          .toList();

      return logs;
    } catch (e) {
      throw Exception(
        e.toString(),
      );
    }
  }
}
