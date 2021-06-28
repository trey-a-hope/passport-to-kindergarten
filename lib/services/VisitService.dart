import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:p/models/VisitModel.dart';

abstract class IVisitService {
  Future<void> createVisit({
    @required VisitModel visit,
  });
  Future<VisitModel> retrieveVisit({
    @required String visitID,
  });

  Future<List<VisitModel>> retrieveVisits();
}

class VisitService extends IVisitService {
  // final CollectionReference _usersColRef =
  //     Firestore.instance.collection('Users');
  final CollectionReference _visitsColRef =
      FirebaseFirestore.instance.collection('Visits');
  // final CollectionReference _dataColRef = Firestore.instance.collection('Data');

  @override
  Future<void> createVisit({@required VisitModel visit}) async {
    try {
      final WriteBatch batch = FirebaseFirestore.instance.batch();

      //Add new book to books collection.
      final DocumentReference videoDocRef = _visitsColRef.doc();
      visit.id = videoDocRef.id;
      batch.set(videoDocRef, visit.toMap());

      await batch.commit();

      return;
    } catch (e) {
      throw Exception(
        e.toString(),
      );
    }
  }

  @override
  Future<VisitModel> retrieveVisit({@required String visitID}) async {
    try {
      final DocumentReference visitDocRef = _visitsColRef.doc(visitID);

      final DocumentSnapshot visitDocSnapshot = (await visitDocRef.get());

      VisitModel visit = VisitModel.fromDocumentSnapshot(ds: visitDocSnapshot);

      return visit;
    } catch (e) {
      throw Exception(
        e.toString(),
      );
    }
  }

  @override
  Future<List<VisitModel>> retrieveVisits() async {
    try {
      return (await _visitsColRef.get())
          .docs
          .map((doc) => VisitModel.fromDocumentSnapshot(ds: doc))
          .toList();
    } catch (e) {
      throw Exception(
        e.toString(),
      );
    }
  }
}
