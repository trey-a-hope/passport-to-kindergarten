import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:p/models/LogModel.dart';

abstract class ILogService {
  void createVisitLog({
    @required String uid,
    @required LogModel log,
  });
  void createReadLog({
    @required String uid,
    @required LogModel log,
  });
  Future<List<LogModel>> retrieveVisitLogs({
    @required String uid,
  });

  Future<List<LogModel>> retrieveReadLogs({
    @required String uid,
  });
}

class LogService extends ILogService {
  final CollectionReference _usersColRef =
      Firestore.instance.collection('Users');

  @override
  void createReadLog({@required String uid, @required LogModel log}) {
    try {
      final DocumentReference userDocRef = _usersColRef.document(uid);

      final CollectionReference readLogColRef =
          userDocRef.collection('readLogs');

      DocumentReference readLogDocRef = readLogColRef.document();
      log.id = readLogDocRef.documentID;
      readLogDocRef.setData(
        log.toMap(),
      );
    } catch (e) {
      throw Exception(
        e.toString(),
      );
    }
  }

  @override
  void createVisitLog({@required String uid, @required LogModel log}) {
    try {
      final DocumentReference userDocRef = _usersColRef.document(uid);

      final CollectionReference visitLogColRef =
          userDocRef.collection('visitLogs');

      DocumentReference visitLogDocRef = visitLogColRef.document();
      log.id = visitLogDocRef.documentID;
      visitLogDocRef.setData(
        log.toMap(),
      );
    } catch (e) {
      throw Exception(
        e.toString(),
      );
    }
  }

  @override
  Future<List<LogModel>> retrieveReadLogs({@required String uid}) async {
    try {
      final DocumentReference userDocRef = _usersColRef.document(uid);

      final CollectionReference readLogColRef =
          userDocRef.collection('readLogs');

      List<LogModel> readLogs = (await readLogColRef.getDocuments())
          .documents
          .map((doc) => LogModel.fromDocumentSnapshot(ds: doc))
          .toList();

      return readLogs;
    } catch (e) {
      throw Exception(
        e.toString(),
      );
    }
  }

  @override
  Future<List<LogModel>> retrieveVisitLogs({@required String uid}) async {
    try {
      final DocumentReference userDocRef = _usersColRef.document(uid);

      final CollectionReference visitLogColRef =
          userDocRef.collection('visitLogs');

      List<LogModel> visitLogs = (await visitLogColRef.getDocuments())
          .documents
          .map((doc) => LogModel.fromDocumentSnapshot(ds: doc))
          .toList();

      return visitLogs;
    } catch (e) {
      throw Exception(
        e.toString(),
      );
    }
  }
}
