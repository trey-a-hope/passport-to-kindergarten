import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:p/models/VisitingLogModel.dart';

abstract class IVisitingLogService {
  void createVisitLog({
    @required String uid,
    @required VisitingLogModel visitingLog,
  });
  Future<List<VisitingLogModel>> retrieveVisitLogs({
    @required String uid,
  });
}

class VisitingLogService extends IVisitingLogService {
  final CollectionReference _usersColRef =
      Firestore.instance.collection('Users');

  @override
  void createVisitLog(
      {@required String uid, @required VisitingLogModel visitingLog}) {
    try {
      final DocumentReference userDocRef = _usersColRef.document(uid);

      final CollectionReference visitLogColRef =
          userDocRef.collection('visitLogs');

      DocumentReference visitLogDocRef = visitLogColRef.document();
      visitingLog.id = visitLogDocRef.documentID;
      visitLogDocRef.setData(
        visitingLog.toMap(),
      );
    } catch (e) {
      throw Exception(
        e.toString(),
      );
    }
  }

  @override
  Future<List<VisitingLogModel>> retrieveVisitLogs(
      {@required String uid}) async {
    try {
      final DocumentReference userDocRef = _usersColRef.document(uid);

      final CollectionReference visitLogColRef =
          userDocRef.collection('visitLogs');

      List<VisitingLogModel> visitLogs = (await visitLogColRef.getDocuments())
          .documents
          .map((doc) => VisitingLogModel.fromDocumentSnapshot(ds: doc))
          .toList();

      return visitLogs;
    } catch (e) {
      throw Exception(
        e.toString(),
      );
    }
  }
}
