import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:p/models/ParentLogModel.dart';
import 'package:p/models/LogModel.dart';

abstract class ILogService {
  // void createVisitLog({
  //   @required String uid,
  //   @required LogModel log,
  // });
  // void createReadLog({
  //   @required String uid,
  //   @required LogModel log,
  // });
  // Future<List<LogModel>> retrieveVisitLogs({
  //   @required String uid,
  // });

  Future<List<ParentLogModel>> retrieveParentLogs({
    @required String uid,
    @required String collection,
  });

  Future<Stream<QuerySnapshot>> retrieveParentLogsStream({
    @required String uid,
    @required String collection,
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

  // @override
  // void createVisitLog({@required String uid, @required LogModel log}) {
  //   try {
  //     final DocumentReference userDocRef = _usersColRef.document(uid);

  //     final CollectionReference visitLogColRef =
  //         userDocRef.collection('visitLogs');

  //     DocumentReference visitLogDocRef = visitLogColRef.document();
  //     log.id = visitLogDocRef.documentID;
  //     visitLogDocRef.setData(
  //       log.toMap(),
  //     );
  //   } catch (e) {
  //     throw Exception(
  //       e.toString(),
  //     );
  //   }
  // }

  // @override
  // Future<List<LogModel>> retrieveReadLogs({@required String uid}) async {
  //   try {
  //     final DocumentReference userDocRef = _usersColRef.document(uid);

  //     final CollectionReference readLogColRef =
  //         userDocRef.collection('readLogs');

  //     List<LogModel> readLogs = (await readLogColRef.getDocuments())
  //         .documents
  //         .map((doc) => LogModel.fromDocumentSnapshot(ds: doc))
  //         .toList();

  //     return readLogs;
  //   } catch (e) {
  //     throw Exception(
  //       e.toString(),
  //     );
  //   }
  // }

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
}
