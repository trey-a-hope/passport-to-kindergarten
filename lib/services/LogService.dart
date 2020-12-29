import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:p/models/EntryModel.dart';
import 'package:p/models/LogModel.dart';
import 'package:p/models/VisitModel.dart';

abstract class ILogService {

  void createVisitForUser({
    @required String uid,
    @required VisitModel visit,
  });

  Future<void> createEntry(
      {@required String uid,
      @required String type,
      @required EntryModel entry});

  Future<List<EntryModel>> retrieveEntries({
    @required String uid,
  });

  Future<Stream<QuerySnapshot>> streamEntries({
    @required String uid,
    @required String type,
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
    @required String idOfEntry,
    @required LogModel log,
  });
}

class LogService extends ILogService {
  final CollectionReference _usersColRef =
      Firestore.instance.collection('Users');

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
  Future<void> createLog({
    @required String uid,
    @required String collection,
    @required String idOfEntry,
    @required LogModel log,
  }) async {
    try {
      final WriteBatch batch = Firestore.instance.batch();

      final DocumentReference userDocRef = _usersColRef.document(uid);

      final DocumentReference entryDocRef =
          userDocRef.collection(collection).document(idOfEntry);

      final DocumentReference logDocRef =
          entryDocRef.collection('logs').document();

      log.id = logDocRef.documentID;

      batch.setData(logDocRef, log.toMap());

      batch.updateData(entryDocRef, {
        'logCount': FieldValue.increment(1),
        'modified': DateTime.now(),
      });

      if (collection == 'books') {
        batch.updateData(userDocRef, {'bookLogCount': FieldValue.increment(1)});
      } else if (collection == 'visits') {
        batch
            .updateData(userDocRef, {'visitLogCount': FieldValue.increment(1)});
      } else if (collection == 'stamps') {
        batch.updateData(userDocRef, {'stampCount': FieldValue.increment(1)});
      }

      await batch.commit();

      return;
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

  @override
  Future<List<EntryModel>> retrieveEntries(
      {@required String uid, @required String type}) async {
    try {
      final DocumentReference userDocRef = _usersColRef.document(uid);

      List<DocumentSnapshot> entryDocSnaps =
          (await userDocRef.collection(type).getDocuments()).documents;

      List<EntryModel> entries = entryDocSnaps
          .map(
            (entryDocSnap) => EntryModel.fromDocSnapshot(ds: entryDocSnap),
          )
          .toList();

      return entries;
    } catch (e) {
      throw Exception(
        e.toString(),
      );
    }
  }

  @override
  Future<Stream<QuerySnapshot>> streamEntries(
      {@required String uid, @required String type}) async {
    try {
      final DocumentReference userDocRef = _usersColRef.document(uid);

      Stream<QuerySnapshot> entriesQueryStream =
          userDocRef.collection(type).snapshots();

      return entriesQueryStream;
    } catch (error) {
      throw Exception(
        error.toString(),
      );
    }
  }

  @override
  Future<void> createEntry({
    @required String uid,
    @required String type,
    @required EntryModel entry,
  }) async {
    try {
      final WriteBatch batch = Firestore.instance.batch();

      final DocumentReference entryDocRef =
          _usersColRef.document(uid).collection(type).document();
      entry.id = entryDocRef.documentID;

      batch.setData(entryDocRef, entry.toMap());

      await batch.commit();

      return;
    } catch (e) {
      throw Exception(
        e.toString(),
      );
    }
  }
}
