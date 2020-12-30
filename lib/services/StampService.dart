import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:p/models/StampModel.dart';

abstract class IStampService {
  Future<void> createStamp({@required String uid, @required StampModel stamp});
  Future<List<StampModel>> getStampsForUser({
    @required String uid,
  });
}

class StampService extends IStampService {
  final CollectionReference _usersColRef =
      Firestore.instance.collection('Users');

  @override
  Future<void> createStamp(
      {@required String uid, @required StampModel stamp}) async {
    try {
      final WriteBatch batch = Firestore.instance.batch();

      final DocumentReference userDocRef = _usersColRef.document(uid);

      final CollectionReference stampsColRef = userDocRef.collection('stamps');

      final DocumentReference stampDocRef = stampsColRef.document();

      stamp.id = stampDocRef.documentID;

      batch.setData(stampDocRef, stamp.toMap());

      batch.updateData(userDocRef, {'stampCount': FieldValue.increment(1)});

      await batch.commit();

      return;
    } catch (e) {
      throw Exception(
        e.toString(),
      );
    }
  }

  @override
  Future<List<StampModel>> getStampsForUser({@required String uid}) async {
    try {
      final DocumentReference userDocRef = _usersColRef.document(uid);

      final CollectionReference stampColRef = userDocRef.collection('stamps');

      final List<DocumentSnapshot> stampDocSnaps =
          (await stampColRef.getDocuments()).documents;

      return stampDocSnaps
          .map((stampDocSnap) =>
              StampModel.fromDocumentSnapshot(ds: stampDocSnap))
          .toList();
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}
