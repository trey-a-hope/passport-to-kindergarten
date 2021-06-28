import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:p/models/EntryModel.dart';
import 'package:p/models/LogModel.dart';

abstract class ILogService {
  Future<void> createEntry({
    @required String uid,
    @required String type,
    @required EntryModel entry,
  });

  Future<List<EntryModel>> retrieveEntries({
    @required String uid,
  });

  Future<Stream<QuerySnapshot>> streamEntries({
    @required String uid,
    @required String type,
  });

  Future<List<LogModel>> retrieveLogs({
    @required String uid,
    @required String type,
    @required String idOfEntry,
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
      FirebaseFirestore.instance.collection('Users');

  @override
  Future<void> createLog({
    @required String uid,
    @required String collection,
    @required String idOfEntry,
    @required LogModel log,
  }) async {
    try {
      final WriteBatch batch = FirebaseFirestore.instance.batch();

      final DocumentReference userDocRef = _usersColRef.doc(uid);

      final DocumentReference entryDocRef =
          userDocRef.collection(collection).doc(idOfEntry);

      final DocumentReference logDocRef = entryDocRef.collection('logs').doc();

      log.id = logDocRef.id;

      batch.set(logDocRef, log.toMap());

      batch.update(entryDocRef, {
        'logCount': FieldValue.increment(1),
        'modified': DateTime.now(),
      });

      if (collection == 'books') {
        batch.update(userDocRef, {'bookLogCount': FieldValue.increment(1)});
      } else if (collection == 'visits') {
        batch.update(userDocRef, {'visitLogCount': FieldValue.increment(1)});
      } else if (collection == 'stamps') {
        batch.update(userDocRef, {'stampCount': FieldValue.increment(1)});
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
  Future<List<LogModel>> retrieveLogs({
    @required String uid,
    @required String type,
    @required String idOfEntry,
  }) async {
    try {
      final DocumentReference userDocRef = _usersColRef.doc(uid);

      List<DocumentSnapshot> logDocSnaps = (await userDocRef
              .collection(type)
              .doc(idOfEntry)
              .collection('logs')
              .get())
          .docs;

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
      final DocumentReference userDocRef = _usersColRef.doc(uid);

      Stream<QuerySnapshot> logQueryStream = userDocRef
          .collection(collection)
          .doc(documentID)
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
  Future<List<EntryModel>> retrieveEntries(
      {@required String uid, @required String type}) async {
    try {
      final DocumentReference userDocRef = _usersColRef.doc(uid);

      List<DocumentSnapshot> entryDocSnaps =
          (await userDocRef.collection(type).get()).docs;

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
      final DocumentReference userDocRef = _usersColRef.doc(uid);

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
      final WriteBatch batch = FirebaseFirestore.instance.batch();

      final DocumentReference entryDocRef =
          _usersColRef.doc(uid).collection(type).doc();
      entry.id = entryDocRef.id;

      batch.set(entryDocRef, entry.toMap());

      await batch.commit();

      return;
    } catch (e) {
      throw Exception(
        e.toString(),
      );
    }
  }
}
