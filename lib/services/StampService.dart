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
      FirebaseFirestore.instance.collection('Users');

  @override
  Future<void> createStamp(
      {@required String uid, @required StampModel stamp}) async {
    try {
      final WriteBatch batch = FirebaseFirestore.instance.batch();

      final DocumentReference userDocRef = _usersColRef.doc(uid);

      final CollectionReference stampsColRef = userDocRef.collection('stamps');

      final DocumentReference stampDocRef = stampsColRef.doc();

      stamp.id = stampDocRef.id;

      batch.set(stampDocRef, stamp.toMap());

      batch.update(userDocRef, {'stampCount': FieldValue.increment(1)});

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
      final DocumentReference userDocRef = _usersColRef.doc(uid);

      final CollectionReference stampColRef = userDocRef.collection('stamps');

      final List<DocumentSnapshot> stampDocSnaps =
          (await stampColRef.get()).docs;

      return stampDocSnaps
          .map((stampDocSnap) =>
              StampModel.fromDocumentSnapshot(ds: stampDocSnap))
          .toList();
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}
