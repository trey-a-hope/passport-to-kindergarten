import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:p/constants.dart';
import 'package:p/models/BookModel.dart';
import 'package:p/models/VisitModel.dart';

abstract class IDummyService {
  // Future<void> addIDKTeacherToUsers();
  Future<void> addDefaultBooksToStudent({
    @required String uid,
  });
  Future<void> addDefaultVisitsToStudent({
    @required String uid,
  });
  Future<void> addPropertyToAllDocsInCollection({
    @required String collection,
    @required String propertyName,
    @required dynamic propertyValue,
  });
}

class DummyService extends IDummyService {
  final CollectionReference _usersColRef =
      Firestore.instance.collection('Users');

  @override
  Future<void> addDefaultBooksToStudent({
    @required String uid,
  }) async {
    try {
      final DocumentReference userDocRef = _usersColRef.document(uid);

      for (int i = 0; i < DEFAULT_BOOKS.length; i++) {
        final BookModel defaultBook = DEFAULT_BOOKS[i];
        DocumentReference defaultBookRef =
            userDocRef.collection('books').document();
        defaultBook.id = defaultBookRef.documentID;
        defaultBookRef.setData(
          defaultBook.toMap(),
        );
      }

      return;
    } catch (e) {
      throw Exception(
        e.toString(),
      );
    }
  }

  @override
  Future<void> addDefaultVisitsToStudent({@required String uid}) async {
    try {
      final DocumentReference userDocRef = _usersColRef.document(uid);

      for (int i = 0; i < DEFAULT_VISITS.length; i++) {
        final VisitModel defaultVisit = DEFAULT_VISITS[i];
        DocumentReference defaultVisitRef =
            userDocRef.collection('visits').document();
        defaultVisit.id = defaultVisitRef.documentID;
        defaultVisitRef.setData(
          defaultVisit.toMap(),
        );
      }

      return;
    } catch (e) {
      throw Exception(
        e.toString(),
      );
    }
  }

  @override
  Future<void> addPropertyToAllDocsInCollection({
    @required String collection,
    @required String propertyName,
    @required dynamic propertyValue,
  }) async {
    try {
      final List<DocumentSnapshot> docs =
          (await Firestore.instance.collection(collection).getDocuments())
              .documents;

      for (int i = 0; i < docs.length; i++) {
        final DocumentSnapshot doc = docs[i];

        await Firestore.instance
            .collection(collection)
            .document(doc.documentID)
            .updateData(
          {
            propertyName: propertyValue,
          },
        );
      }

      return;
    } catch (e) {
      throw Exception(
        e.toString(),
      );
    }
  }
}
